#import "../config/thesis-config.typ": glpl, gl,
#pagebreak(to:"odd")

= Implementazione <cap:implementazione>

#text(style: "italic", [
    In questo capitolo descrivo come sono state realizzate le scelte architetturali illustrate nel capitolo precedente, organizzando l'esposizione per problema affrontato e riportando i frammenti di codice più significativi; i listati estesi sono raccolti in appendice.
])
#v(1em)
== Il server MCP: bootstrap e tool
Il server MCP è costruito con `Host.CreateApplicationBuilder`. L'ordine delle fonti di configurazione è deliberato: le variabili d'ambiente devono prevalere su `appsettings.json`, perchè il token aggiornato arriva dall'host come variabile d'ambiente e non deve essere sovrascritto da un eventuale token di sviluppo, scaduto, presente nel file. In avvio vengono registrati il provider del token come _singleton_ e i tool che espongono le risorse del gestionale, mentre il trasporto è _stdio_.\

Ogni tool è una classe con un metodo annotato `[McpServerTool]` e `[Description(...)]`: riceve via _dependency injection_ il _resolver_ del client REST, costruisce i parametri opzionali, chiama l'endpoint `mcp/<Risorsa>` e formatta la risposta. I tool offerti all'LLM corrispondono alle risorse del dominio (appuntamenti, task, risorse, competenze, calendario lavorativo); fa eccezione il tool di _control-plane_ per l'aggiornamento del _bearer_, riservato all'host ed escluso dai tool visibili al modello. La tabella completa dei tool e degli endpoint corrispondenti è in Appendice B.

== Il client MCP: orchestrazione e catena di filtri
Il client MCP è l'host dell'LLM. In avvio crea il _Kernel_ di Semantic Kernel puntato all'endpoint remoto, avvia il server MCP ereditando le variabili d'ambiente di autenticazione, mappa i tool MCP in funzioni del _Kernel_ (escludendo il tool di _control-plane_) e registra i filtri di auto-invocazione. L'ordine di registrazione conta, perché il primo registrato è il più esterno della catena: un filtro anti-loop che termina l'esecuzione quando si supera un numero massimo di round di tool; un filtro di osservabilità che accoda nome, parametri e risultato di ogni invocazione in una coda concorrente per l'interfaccia; e un filtro di _refresh_ del token che, riconosciuto il segnale di token scaduto, ne richiede il rinnovo e ritenta l'operazione.

== Implementazione delle strategie anti-allucinazione e dei _Plugin_
Le decisioni architetturali volte a contenere il carico cognitivo dell'LLM (cfr. @sez:strategia-anti-allucinazione) si sono tradotte nell'implementazione di specifici _plugin_ e _tool_ all'interno dell'ambiente Semantic Kernel.

Il fulcro della strategia è il _tool_ di proposta `pianifica_e_proponi`.
Riceve dal modello un array tipizzato di operazioni --- `crea`, `modifica`, `elimina` --- e ne valida programmaticamente la consistenza: in caso di sovrapposizioni tra le operazioni o con l'agenda esistente, non registra nulla e restituisce al modello l'elenco degli errori insieme alla lista completa da correggere e ripassare.
Solo a validazione superata la proposta viene depositata nel `ProposteCapturePlugin`, un contenitore passivo che l'orchestratore legge a fine turnpo per emetterla come card verso l'interfaccia.
La validazione è quindi responsabilità del _tool_ stesso, mentre il _plugin_ di cattura si limita a trasportare la proposta già verificata.

Per quanto riguarda i _tool_ ad alta granularità, sono stati sviluppati `trova_risorsa_disponibile` e `get_spazi_liberi`, che condividono la logica di intersezione tra appuntamenti e calendario lavorativo incapsulata nel componente `DisponibilitaCore`, evitando che il modello debba comporre mentalmente più strumenti elementari e dedurne le fasce libere.

L'effettiva esposizione degli strumenti al modello è stata razionalizzata.
Dei numerosi _endpoint_ disponibili in Symposium, sono stati resi invocabili unicamente sette _tool_ core legati alla pianificazione (appuntamenti, task, risorse, competenze, turni calendario, spazi liberi, risorsa disponibile).

A supporto dell'autonomia decisionale, sono stati inoltre integrati due _plugin_ essenziali:
- *KnowledgePlugin:* una base di conoscenza che interroga le procedure e le FAQ del gestionale (soddisfacendo il requisito `FMR17`).
- *WebFetchPlugin:* un modulo per la ricerca di informazioni esterne, utile ad arricchire il contesto su entità non presenti nel database.

== Il modulo chatbot in Agilis: _changeset_, anteprima e macchina a stati
Il lato Agilis del sistema (Visual Basic .NET, nodo A) traduce le proposte in un'anteprima visiva sullo scheduler, senza alcuna scrittura sul database.
Il componente centrale è `XspmprisChangesetApplier`, che applica un _changeset_ --- un insieme di operazioni di creazione, modifica ed eliminazione --- agli oggetti già presenti in memoria nel ViewModel della timeline.

Ogni elemento toccato viene marcato come proposto dal chatbot (`IsProposedByChatbot`) e collegato all'dentificativo del _changeset_, così da essere distinguibile visivamente e ripristinabile in blocco.
Il punto delicato è il _rollback_: la classe `TimelineItem` adotta un _dirty tracking_ automatco per cui ogni assegnazione sporca il _flag_ `HasChanges`.
Per non perdere lo stato originale si applica il pattern *Memento*, salvando uno snapshot pre-modifica (`PreChatbotSnapshot`) prima di mutare l'oggetto; il valore "pulito" di `HasChanges` viene catturato prima della clonazione e riassegnato per ultimo.
#v(1em)
#figure(caption: [Applicazione di un'operazione di modifica con _snapshot Memento_.])[
```vb
Case OperazioneTipo.Update
    Dim target As TimelineItem = Nothing
    If itemsPerProgr.TryGetValue(op.ProgrTarget.Value, target) Then
        ' Memento: snapshot pre-modifica per il rollback (una sola volta).
        If target.PreChatbotSnapshot Is Nothing Then
            Dim hasChagesPreModifica = target.HasChanges
            Dim snap = target.Clone()
            snap.PreChatbotSnapshot = Nothing
            snap.HasChanges = hasChagesPreModifica  ' valore pulito, riassegnato per ultimo
            target.PreChatbotSnapshot = snap
        End If
        ApplicaModificaSuItem(target, op.DatiNuovi)
        target.IsProposedByChatbot = True
        target.ChatbotChangesetId = changeset.Id
        target.HasChanges = True
    End If
```]
#v(1em)
La conferma non è un'azione speciale dell'AI: `ConfermaAnteprima` si limita a scartare lo _snapshot_ di _rollback_ e a ripulire i _marker_, lasciando `HasChanges = True` affinchè la modifica venga persistita dal normale flusso di salvataggio di Agilis. L'annullamento (`AnnullaAnteprima`) percorre la strada inversa: ripristina gli `Update` dal `PreChatbotSnapshot`, rimuove le creazioni (riconoscibili dal `Progr` temporaneo negativo) e reintegra le eliminazioni dalla collezione `DeletedItems`.

L'intera interazione è governata da una macchina a stati esplicita (`PanelMode`) che rende mutualmente esclusivi gli stati del pannello e ne disciplina le transizioni: `Idle`, `AwaitingResponse`, `Browsing`, `Selected`, `Previewing`, `Refining`.

== Gestione e normalizzazione dello streaming
Lo streaming dei _token_ dall'_endpoint_ remoto pone due problemi: separare il testo destinato all'utente dalla catena di ragionamento (_thinking_), e farlo su un flusso SSE in cui i marcatori possono arrivare spezzati a cavallo di due _chunk_. 

La separazione è realizzata da un `DelegatingHandler` HTTP (`OllamaThinkingHandler`) interposto sul client: in fase di richiesta inietta il _flag_ `think` per abilitare il _reasoning_ del modello; in fase di risposta avvolge lo stream in un `ReasoningToThinkStream` che normalizza l'_output_ marcando il ragionamento con _tag_ `<think>...</think>`.
#v(1em)
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
#v(1em)
A valle, l'orchestratore consuma il flusso normalizzato con una macchina a stati (lo _stripper_) che instrada i frammenti sui canali corretti --- testo visibile e ragionamento --- gestendo i marcatori `<think>` eventualmente spezzati tra due _chunk_ e ripulendo l'_output_ da blocchi residui.
Da qui nascono gli eventi `delta` e `thinking` inviati ad Agilis. Questa scelta di disaccoppiamento garantisce inoltre l'indipendenza dallo scientifico motore: con un _proxy_ che espone già i _tool-call_ SSE nativi, l'iniezione è disabilitata e il flusso passa invariato.

== Ciclo di vita del _token_ in dettaglio
La difesa stratificata anticipata della @sez:sicurezza-token si concretizza su livelli collocati in punti diversi della catena di processi, secondo il principio di minimizzazione dei segreti: la password non lascia mai Agilis, e solo il JWT attraversa i confini di processo, come Bearer.
#v(1em)
1. *Margine di scadenza (lato Agilis).* Il connettore verso Symposium rinnova il _token_ *prima* della sua invalidazione, senza attendere l'errore 401, usando il _refresh token_.
#v(1em)
#figure(caption: [Margine di scadenza lato Agilis.])[
```cs
public async Task AuthenticateIfNecessary()
{
    // Rinnovo proattivo: se manca meno di 1 minuto alla scadenza, refresh anticipato.
    if (_loginResponse != null && _loginResponse.AccessToken.TokenExpiration > DateTime.UtcNow.AddMinutes(1))
        return;
    // ... RefreshTokenRequest con _loginResponse.RefreshToken.Token ...
}
```]
#v(1em)
2. *Segnalazione attraverso confine di processo.* Il _server_ MCP non può propagare eccezioni tipizzate al _client_ su un canale che trasporta solo stringhe: traduce quindi il 401 in un _sentinel value_ testuale, `__AUTH_EXPIRED`.
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
3. *Refresh reattivo (lato _client_).* Un filtro di auto-invocaziome (`SymposiumRefreshFilter`) riconnosce la _sentinel_ nel risultato di un _tool_, richiede un nuovo _token_ ad Agilis attraverso la _pipe_, lo applica al _server_ tramite il _tool_ di _control-plane_ `SetSymposiumToken` e ri-invoca l'operazione una sola volta. Un semaforo serializza i 401 paralleli in un unico _refresh_.
#v(1em)
#figure(caption: [_Refresh_ reattivo del _token_ su _sentinel_ `__AUTH_EXPIRED`.])[
```cs
public async Task OnAutoFunctionInvocationAsync(
    AutoFunctionInvocationContext context, Func<…> next)
{
    await next(context);
    if (!IsAuthExpired(context.Result)) return;

    await _refreshGate.WaitAsync();              // un solo refresh per ondata di 401
    try {
        var newToken = await needTokenAsync(CancellationToken.None);   // ← Agilis via pipe
        if (string.IsNullOrWhiteSpace(newToken)) return;
        if (!string.Equals(_lastAppliedToken, newToken, StringComparison.Ordinal)) {
            await mcpServerClient.CallToolAsync("SetSymposiumToken",
                new Dictionary<string, object?> { ["token"] = newToken });
            _lastAppliedToken = newToken;
        }
    } finally { _refreshGate.Release(); }

    context.Result = await context.Function.InvokeAsync(context.Kernel, context.Arguments); // retry
}
```]
#v(1em)
4. *_Refresh_ proattivo tra turni e* 5. *unico punto di verità.* Tra un turno e l'altro Agilis può inviare al _client_ un _token_ aggiornato, propagato al _server_ con lo stesso _tool_ di _control-plane_; il `SymposiumTokenProvider`, *singleton* _thread-safe_ nel _server_ MCP, custodisce l'unica copia mutabile del _bearer_ corrente. La combinazione dei cinque livelli rende la conversazione resiliente alla scadenza del JWT senza mai interromperla.