#import "../config/thesis-config.typ": glpl, gl,
#pagebreak(to:"odd")

= Implementazione <cap:implementazione>

#text(style: "italic", [
    In questo capitolo descrivo come sono state realizzate le scelte architetturali illustrate nel capitolo precedente, organizzando l'esposizione per problema affrontato e riportando i frammenti di codice più significativi; i listati estesi sono raccolti in appendice.
])
#v(1em)
== Le API REST di Symposium per la pianificazione
Il primo strato realizzato è quello dei dati: senza un canale di accesso al patrimonio informativo del gestionale, il modello sarebbe cieco rispetto allo stato reale di risorse, task e agende. L'esposizione avviene tramite un _plugin_ REST aggiunto a Symposium, sviluppato ex-novo come contributo di questo lavoro.

Il _plugin_ è realizzato come modulo _pluggable_: i _controller_ risiedono nel _namespace_ `OmegaGruppo.Plugins.MCP.Controllers` e vengono registrati nel contenitore di _dependency injection_ di Symposium senza alcuna modifica al codice del _backend_ preesistente.
Tutti gli _endpoint_ condividono il prefisso di rotta `mcp/<Risorsa>` e restano logicamente separati dalle API storiche del gestionale.
La superficie esposta copre l'intero dominio della pianificazione --- risorse e competenze, task di commessa, calendario lavorativo dei turni, appuntamenti --- affiancata da endpoint di area gestionale (documenti, ordini, offerte, scadenze, anagrafica, articoli) e da pochi endpoint di scrittura (CreaDocumento, CreaOfferta). 
L'elenco completo è riportato in #link(<cap:B-appendice>)[Appendice B].

È importante notare che il _plugin_ è deliberatamente più ampio di quanto il _chatbot_ utilizzi: al modello vengono esposti unicamente otto tool di sola lettura legati alla pianificazione (cfr. @sez:strategia-anti-allucinazione-implementazione), affiancati da un *_plugin_ nativo locale* per la validazione delle proposte. Gli _endpoint_ di scrittura restano fuori dal perimetro dell'assistente, coerentemente con il principio per cui l'AI non persiste mai direttamente sul database (`CMR3`).

Il secondo aspetto critico è la sicurezza _multi-tenant_, che concretizza quanto anticipato nella @sez:sicurezza-token. L'identità di _tenant_ non è mai un parametro di _query_ controllabile dal chiamante: è derivata dal _token_.
Un middleware (`SympAuthorizeMiddleware`) valida il _Bearer_ JWT a ogni richiesta ed estrae dai claim i valori di `Azienda` e `Ditta`, che vengono resi disponibili ai _controller_ tramite il servizio di contesto `ICallContextDataService`. Ciascun _controller_, prima di interrogare il database, recupera il codice ditta dal contesto e lo applica come filtro obbligatorio in ogni _query_:

```cs
var codditt = _callContextDataService.GetRequestBase().Ditta;
// ...ogni query LINQ vincola i risultati alla ditta dell'operatore:
var risultati = _db.Risorse.Where(og => og.codditt == codditt && /* altri filtri */);

```

In questo modo il confinamento dei dati alla ditta dell'operatore è garantito a livello di codice e non può essere aggirato da un parametro malevolo o da un'allucinazione del modello: anche se l'LLM richiedesse dati di un'altra azienda, la query resterebbe vincolata al _tenant_ ricavato dal _token_.

== Il server MCP: bootstrap e tool
Il primo problema implementativo è esporre le risorse del gestionale come strumenti invocabili, garantendo che il _token_ corretto prevalga sempre.
Il _server_ MCP è costruito con `Host.CreateApplicationBuilder` e l'ordine delle fonti di configurazione è deliberato: le variabili d'ambiente prevalgono su `appsettings.json`, perchè il _token_ aggiornato arriva dall'_host_ come variabile d'ambiente e non deve essere sovrascritto da un eventuale _token_ di sviluppo --- scaduto --- presente nel file di configurazione.
In avvio vengono registrati il _provider_ del _token_ come _singleton_ e i _tool_ che espongono le risorse del gestionale; il trasporto è `stdio`.

Ogni _tool_ è una classe con un metodo annotato `[McpServerTool]` e `[Description(...)]` che riceve via _dependency injection_ il _resolver_ del _client_ REST.
Il _server_ espone due tipologie di strumenti.
La maggior parte sono _tool_ *pass-through*, che mappano direttamente una risorsa del dominio (appuntamenti, task, risorse, competenze, calendario lavorativo): costruiscono i parametri opzionali, chiamano l'_endpoint_ `mcp/<Risorsa>` e ne formattano la risposta.
Gli altri sono _tool_ *compositi*, che non restituiscono una risorsa grezza ma un risultato derivato, calcolato in modo deterministico aggregando più fonti --- è il caso degli spazi liberi di una risorsa e della ricerca della risorsa disponibile, dettagliati nella sezione @sez:strategia-anti-allucinazione-implementazione.
Fa eccezione, infine, il _tool_ di _control-plane_ per l'aggiornamento del _bearer_, riservato all'_host_ ed escluso dai _tool_ visibili al modello. La tabella completa dei tool e degli _endpoint_ corrispondenti è in #link(<cap:B-appendice>)[Appendice B].

== Il client MCP: orchestrazione e catena di filtri
Il _client_ MCP è l'_host_ dell'LLM e il coordinatore dell'intera conversazione. In avvio crea il _Kernel_ di Semantic Kernel puntato all'_endpoint_ remoto, avvia il _server_ MCP ereditando le variabili d'ambiente di autenticazione, mappa i _tool_ MCP in funzioni del _Kernel_ --- escludendo il tool di _control-plane_ --- e registra i filtri di auto-invocazione.

L'ordine di registrazione è significativo, perché il primo filtro registrato è il più esterno della catena.
Si registrano, nell'ordine: un filtro *anti-loop*, che termina l'esecuzione al superamento di un numero massimo di round di _tool_; un filtro di *osservabilità* che accoda nome, parametri e risultato di ogni invocazione in una coda concorrente a beneficio dell'interfaccia; e il filtro `SymposiumAuthRefreshFilter`, che --- riconosciuto il segnale di _token_ scaduto --- ne richiede il rinnovo e ritenta l'operazione.
La meccanica di quest'ultimo è dettagliata nella @sez:vita-token.

== Implementazione delle strategie anti-allucinazione e dei _Plugin_ <sez:strategia-anti-allucinazione-implementazione>
Le tre strategie di delega deterministica introdotte in @sez:strategia-anti-allucinazione si traducono in altrettanti elementi concreti nell'ambiente Semantic Kernel.

#v(1em)

- *Validazione esterna delle proposte.* Il fulcro è il _tool_ `pianifica_e_proponi`, che riceve dal modello un _array_ tipizzato di operazioni --- crea, modifica, elimina --- e ne verifica programmaticamente la consistenza. In presenza di sovrapposizioni tra le operazioni o con l'agenda esistente non registra nulla e restituisce al modello l'elenco degli errori insieme alla lista completa da correggere e ripassare. Solo a validazione superata la proposta viene depositata nel `ProposteCapturePlugin`, un contenitore passivo che l'orchestratore legge a fine turno per emetterla come _card_ verso l'interfaccia. La validazione resta così responsabilità del _tool_, mentre il _plugin_ di cattura si limita a trasportare una proposta già verificata.

- *_Tool_ ad alta granularità.* I _tool_ `trova_risorsa_disponibile` e `get_spazi_liberi` non sono semplici letture, ma calcoli compositi: invece di esporre al modello gli strumenti elementari (calendario, appuntamenti) lasciandogli dedurre mentalmente le intersezioni temporali --- operazione su cui un modello a 9B allucina facilmente --- restituiscono fasce orarie libere già calcolate. La logica risiede nel componente `DisponibilitaCore`, interno al _server_ MCP, che recupera dalle API di Symposium il calendario dei turni e gli impegni della risorsa nell'intervallo richiesto e ne calcola la differenza insiemistica. Il metodo `FinestreLavorative` traduce le regole del calendario aziendale in slot lavorativi concreti per ogni giorno del periodo (escludendo giorni non lavorativi e pause); il metodo `Libere` sottrae da queste finestre gli impegni esistenti, con una scansione lineare a cursore, come si vede in @cod:fasce-libere. Il risultato è un elenco ordinato e privo di sovrapposizioni, restituito al modello come dato finito. Spostando questo calcolo nel software deterministico si elimina alla radice una delle principali fonti di errore aritmetico-temporale del modello, in linea con la strategia di delega descritta nella @sez:strategia-anti-allucinazione.


#figure(caption: [Calcolo deterministico delle fasce libere per sottrazione degli impegni dalle finestre lavorative.])[
```cs
// Sottrae gli impegni dalle finestre lavorative, restituendo le fasce libere.
internal static List<Slot> Libere(List<Slot> finestre, List<Slot> impegni)
{
    var libere = new List<Slot>();
    foreach (var f in finestre)
    {
        var cursore = f.Inizio;
        var interni = impegni
            .Where(i => i.Fine > f.Inizio && i.Inizio < f.Fine)
            .OrderBy(i => i.Inizio);
        foreach (var imp in interni)
        {
            if (imp.Inizio > cursore)
                libere.Add(new Slot { Inizio = cursore, Fine = imp.Inizio });
            if (imp.Fine > cursore)
                cursore = imp.Fine;   // salta oltre l'impegno
        }
        if (cursore < f.Fine)
            libere.Add(new Slot { Inizio = cursore, Fine = f.Fine });
    }
    return libere.Where(s => s.Fine > s.Inizio).OrderBy(s => s.Inizio).ToList();
}

```]<cod:fasce-libere>


- *Contenimento dell'esposizione e del contesto.* Dei numerosi _endpoint_ disponibili in Symposium sono stati resi invocabili unicamente gli otto _tool_ _core_ legati alla pianificazione (cfr. @tab:tools), riducendo la superficie decisionale del modello.

#v(1em)

A supporto dell'autonomia decisionale sono inoltre stati integrati due _plugin_ nativi: `KnowledgePlugin`, base di conoscenza che espone procedure e FAQ del gestionale (requisito `FMR17`), e `WebFetchPlugin`, per recuperare informazioni esterne utili ad arricchire il contesto su entità non presenti nel database.

== L'integrazione lato Agilis: contesto e allegati
Affinché il modello ragioni su dati pertinenti, il lato Agilis deve tradurre lo stato vivo del pianificatore e gli eventuali documenti forniti dall'operatore in un contesto testuale conciso. Questa responsabilità è affidata a due componenti distinti, entrambi agganciati al pannello tramite interfacce (cfr. #link(<cap:B-appendice>)[Appendice B]), in applicazione del pattern _Adapter_ (@sez:pattern-architetturali).

- *Costruzione del contesto.* Il componente `XspmprisContextAdapter` legge dal _ViewModel_ dello _scheduler_ la finestra temporale effettivamente renderizzata, le risorse visibili e gli appuntamenti che vi ricadono, applicando gli stessi filtri attivi nell'interfaccia (periodo, risorsa selezionata). Il punto delicato è il contenimento del rumore informativo, anticipato nella @sez:strategia-anti-allucinazione: un contesto troppo ampio degrada la qualità delle risposte e gonfia il costo in _token_. Per questo il numero di appuntamenti trasmessi è limitato a un tetto rigido; in caso di superamento, l'eccesso viene troncato in ordine cronologico e la circostanza viene segnalata esplicitamente al modello tramite un _flag_ di contesto, così che possa invitare l'operatore a restringere il periodo anziché ragionare su dati parziali in modo silenzioso:


#figure(caption: [Tetto al numero di appuntamenti immessi nel contesto, con segnalazione del troncamento al modello.])[
```vb
Const MaxAppuntamentiContesto As Integer = 20
If ctx.AppuntamentiVisibili.Count > MaxAppuntamentiContesto Then
    Dim totale = ctx.AppuntamentiVisibili.Count
    ctx.AppuntamentiVisibili = ctx.AppuntamentiVisibili _
        .OrderBy(Function(a) a.DataInizio) _
        .Take(MaxAppuntamentiContesto).ToList()
    ctx.FiltriAttivi("appuntamentiTroncati") =
        $"mostrati {MaxAppuntamentiContesto} di {totale}: restringi il periodo o le risorse"
End If
```]


- *Estrazione degli allegati.* Per soddisfare i requisiti di arricchimento del contesto tramite file, un servizio dedicato (`AttachmentExtractionService`) normalizza documenti eterogenei in testo. Il servizio funge da dispatcher verso estrattori specializzati, selezionati per estensione: i fogli Excel vengono convertiti in tabelle _Markdown_ tramite `DevExpress.Spreadsheet` (con un tetto di righe per foglio); i PDF vengono estratti con `DevExpress.Pdf`; le email sono gestite nel formato `.msg` tramite la libreria _MsgReader_ e nel formato `.eml` tramite _MimeKit_, producendo un'intestazione strutturata (mittente, destinatari, data, oggetto) seguita dal corpo ripulito dalle citazioni. Per contenere l'occupazione di contesto, ogni allegato è troncato a circa sedicimila caratteri e ogni turno ammette al più cinque allegati.
#v(1em)
Una limitazione nota riguarda i PDF privi di livello testuale (documenti acquisiti come immagine): non essendo previsto un livello di riconoscimento ottico dei caratteri, l'estrazione restituisce un esito vuoto e l'allegato viene marcato in errore con un messaggio esplicativo. Ogni allegato attraversa infatti un proprio ciclo di vita (`InEstrazione`, `Pronto`, `Errore`, `NonSupportato`) e solo gli allegati nello stato `Pronto` concorrono alla costruzione del _payload_ inviato al modello.


== Il modulo chatbot in Agilis: _changeset_, anteprima e macchina a stati
Il lato Agilis del sistema (Visual Basic .NET, nodo A) traduce le proposte in un'anteprima visiva sullo scheduler, senza alcuna scrittura sul database.
Il componente centrale è `XspmprisChangesetApplier`, che applica un _changeset_ --- un insieme di operazioni di creazione, modifica ed eliminazione --- agli oggetti già presenti in memoria nel ViewModel della timeline.

Ogni elemento toccato viene marcato come proposto dal chatbot (`IsProposedByChatbot`) e collegato all'identificativo del _changeset_, così da essere distinguibile visivamente e ripristinabile in blocco.
Il punto delicato è il _rollback_: la classe `TimelineItem` adotta un _dirty tracking_ automatico per cui ogni assegnazione sporca il _flag_ `HasChanges`.
Per non perdere lo stato originale si applica il pattern *Memento*, salvando uno snapshot pre-modifica (`PreChatbotSnapshot`) prima di mutare l'oggetto; il valore "pulito" di `HasChanges` viene catturato prima della clonazione e riassegnato per ultimo.

#figure(caption: [Applicazione di un'operazione di modifica con _snapshot Memento_.])[
```vb
Case OperazioneTipo.Update
    Dim target As TimelineItem = Nothing
    If itemsPerProgr.TryGetValue(op.ProgrTarget.Value, target) Then
        ' Memento: snapshot pre-modifica per il rollback (una sola volta).
        If target.PreChatbotSnapshot Is Nothing Then
            Dim hasChangesPreModifica = target.HasChanges
            Dim snap = target.Clone()
            snap.PreChatbotSnapshot = Nothing
            snap.HasChanges = hasChangesPreModifica  ' valore pulito, riassegnato per ultimo
            target.PreChatbotSnapshot = snap
        End If
        ApplicaModificaSuItem(target, op.DatiNuovi)
        target.IsProposedByChatbot = True
        target.ChatbotChangesetId = changeset.Id
        target.HasChanges = True
    End If
```]

La conferma non è un'azione speciale dell'AI: `ConfermaAnteprima` si limita a scartare lo _snapshot_ di _rollback_ e a ripulire i _marker_, lasciando `HasChanges = True` affinchè la modifica venga persistita dal normale flusso di salvataggio di Agilis. L'annullamento (`AnnullaAnteprima`) percorre la strada inversa: ripristina gli `Update` dal `PreChatbotSnapshot`, rimuove le creazioni (riconoscibili dal `Progr` temporaneo negativo) e reintegra le eliminazioni dalla collezione `DeletedItems`.

L'intera interazione è governata da una macchina a stati esplicita (`PanelMode`) che rende mutualmente esclusivi gli stati del pannello e ne disciplina le transizioni: `Idle`, `AwaitingResponse`, `Browsing`, `Selected`, `Previewing`, `Refining`.

== Gestione e normalizzazione dello streaming
Lo streaming dei _token_ dall'_endpoint_ remoto pone due problemi: separare il testo destinato all'utente dalla catena di ragionamento (_thinking_), e farlo su un flusso SSE in cui i marcatori possono arrivare spezzati a cavallo di due _chunk_. 

La separazione è realizzata da un `DelegatingHandler` HTTP (`OllamaThinkingHandler`) interposto sul client: in fase di richiesta inietta il _flag_ `think` per abilitare il _reasoning_ del modello; in fase di risposta avvolge lo stream in un `ReasoningToThinkStream` che normalizza l'_output_ marcando il ragionamento con _tag_ `<think>...</think>`.
#figure(caption: [_Handler_ che abilita il _thinking_ e normalizza lo _stream_ SSE.])[
```cs
protected override async Task<HttpResponseMessage> SendAsync(
    HttpRequestMessage request,
    CancellationToken ct)
{
    if (InjectThink && request.Content is not null && request.Method == HttpMethod.Post)
    {
        var body = await request.Content.ReadAsStringAsync(ct);
        if (JsonNode.Parse(body) is JsonObject obj)
        {
            obj["think"] = true;       // abilita il reasoning
            request.Content = new StringContent(obj.ToJsonString(), Encoding.UTF8, "application/json");
        }
    }
    var response = await base.SendAsync(request, ct);
    if (InjectThink && response.Content is not null)
    {
        var original = await response.Content.ReadAsStreamAsync(ct);
        response.Content = new StreamContent(new ReasoningToThinkStream(original, Debug));
    }
    return response;
}
```]
A valle, l'orchestratore consuma il flusso normalizzato con una macchina a stati (lo _stripper_) che instrada i frammenti sui canali corretti --- testo visibile e ragionamento --- gestendo i marcatori `<think>` eventualmente spezzati tra due _chunk_ e ripulendo l'_output_ da blocchi residui.
Da qui nascono gli eventi `delta` e `thinking` inviati ad Agilis. Questa scelta di disaccoppiamento garantisce inoltre l'indipendenza dallo specifico motore: con un _proxy_ che espone già i _tool-call_ SSE nativi, l'iniezione è disabilitata e il flusso passa invariato.

== Ciclo di vita del _token_ in dettaglio <sez:vita-token>
La difesa stratificata anticipata della @sez:sicurezza-token si concretizza su livelli collocati in punti diversi della catena di processi, secondo il principio di minimizzazione dei segreti: la password non lascia mai Agilis, e solo il JWT attraversa i confini di processo, come _Bearer_.
#v(1em)
1. *Margine di scadenza con _fallback_(lato Agilis).* Il connettore verso Symposium rinnova il _token_ *prima* della sua invalidazione, senza attendere l'errore 401, sfruttando il _refresh token_. Se anche il _refresh token_ risulta scaduto --- caso tipico dopo lunghe inattività --- il connettore non propaga l'errore: azzera la sessione e ricade su un _login_ completo con le credenziali ancora custodite nel processo Agilis, ripristinando in modo trasparente una sessione valida.
#figure(caption: [Margine di scadenza lato Agilis.])[
```cs
public async Task AuthenticateIfNecessary()
{
    // Token ancora valido (margine di 1 minuto): nessuna azione.
    if (_loginResponse != null && _loginResponse.AccessToken.TokenExpiration > DateTime.UtcNow.AddMinutes(1))
        return;
    
    // Sessione esistente: prova il refresh. Se il refresh token è scaduto
    // o rifiutato, azzera la sessione e ricade nel login completo.
    if (_loginResponse != null)
    {
        try
        {
            var refresh = await /* POST Login/RefreshToken */;
            if (refresh.IsSuccessful){ /* aggiorna token e bearer */ return; }
        }
        catch { /* errore di rete --> fallback */ }
    }

    // Login completo: primo accesso oppure refresh token scaduto.
    var login = await /* POST Login/Authenticate con le credenziali di sessione */;
    // aggiorna _loginResponse e configura il bearer
}
```]
2. *Ritentativo col _token_ corrente (lato _server_ MCP).* Prima di arrendersi, il _client_ REST del _server_ è configurato con `WithActionOnUnauthorized`: su 401 rilegge dal provider il _token_ più recente disponibile, riconfigura il _bearer_ e ritenta la chiamata una volta. Solo se anche questo tentativo fallisce, il _server_ traduce il 401 in un _sentinel value_ testuale, `__AUTH_EXPIRED`, poichè il canale verso il _client_ trasporta solo stringhe e non può veicolare eccezioni tipizzate.
#v(1em)
#figure(caption: [Traduzione del 401 in un _sentinel_ lato _server_ MCP.])[
```cs
public static string FormatResponse(RestResponseWithData<byte[]> resp)
{
    if (resp.IsSuccessful)      return Encoding.UTF8.GetString(resp.Data!);
    if ((int)resp.StatusCode == 401) return AuthExpiredSentinel;   // "__AUTH_EXPIRED"
    return $"Nessun dato trovato (errore: {resp.StatusCode})";
}

```]
#v(1em)
3. *Refresh reattivo (lato _client_).* Un filtro di auto-invocaziome (`SymposiumAuthRefreshFilter`) riconnosce la _sentinel_ nel risultato di un _tool_, richiede un nuovo _token_ ad Agilis attraverso la _pipe_, lo applica al _server_ tramite il _tool_ di _control-plane_ `SetSymposiumToken` e ri-invoca l'operazione una sola volta. Un semaforo serializza i 401 paralleli in un unico _refresh_.
#figure(caption: [_Refresh_ reattivo del _token_ su _sentinel_ `__AUTH_EXPIRED`.])[
```cs
public async Task OnAutoFunctionInvocationAsync(
    AutoFunctionInvocationContext context, Func<…> next)
{
    await next(context);
    if (!IsAuthExpired(context.Result)) return;

    await _refreshGate.WaitAsync();              
    // un solo refresh per ondata di 401
    try {
        var newToken = await needTokenAsync(CancellationToken.None);  
        // Agilis via pipe
        if (string.IsNullOrWhiteSpace(newToken)) return;
        if (!string.Equals(_lastAppliedToken, newToken, StringComparison.Ordinal)) {
            await mcpServerClient.CallToolAsync(
                "SetSymposiumToken",
                new Dictionary<string, object?> { ["token"] = newToken });
            _lastAppliedToken = newToken;
        }
    } finally { _refreshGate.Release(); }

    context.Result = await context.Function.InvokeAsync(context.Kernel, context.Arguments); // retry
}
```]
4. *_Refresh_ proattivo tra turni e* 5. *unico punto di verità.* Tra un turno e l'altro Agilis può inviare al _client_ un _token_ aggiornato, propagato al _server_ con lo stesso _tool_ di _control-plane_; il `SymposiumTokenProvider`, *singleton* _thread-safe_ nel _server_ MCP, custodisce l'unica copia mutabile del _bearer_ corrente. La combinazione dei cinque livelli rende la conversazione resiliente alla scadenza del JWT senza mai interromperla.