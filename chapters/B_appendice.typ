#import "../config/thesis-config.typ": glpl, gl
#import "data/requirements_list.typ": *
#import "data/implementations.typ": *

#pagebreak(to:"odd")
= Listati di codice <cap:B-appendice>
== _Endpoint_ REST

La colonna _Esposto_ indica se l'_endpoint_ è reso invocabile dal modello (✔) o se è disponibile nel _plugin_ ma fuori dal perimetro del chatbot (✘).

#figure(
  table(
    columns: (2fr, 3.5fr, 2fr, 3fr),
    align: (center + horizon, left + horizon, center + horizon, left + horizon),
    table.header([*Metodo*], [*Rotta*], [*Esposto*], [*Descrizione*]),
    ..getEndpoints().flatten()
  ),
  caption: [Lista degli _endpoint_ esposti da Symposium per il server MCP.],
)<tab:endpoints>

== Mappa degli strumenti esposti al modello
Di seguito la mappa completa degli strumenti a disposizione del modello linguistico, suddivisi in base alla loro natura architetturale: strumenti remoti esposti tramite protocollo MCP e _plugin nativi_ iniettati localmente nel Semantic Kernel.
#figure(
  table(
    columns: (2.5fr, 1fr, 2fr),
    align: (center + horizon, left + horizon, left + horizon),
    table.header([*Tool*], [*Tipo*], [*Fonte*]),
    ..getTools().flatten()
  ),
  caption: [Mappa tool MCP esposti --> fonti dati.],
)<tab:tools>

== Estratti di codice

#figure( caption: [Le interfacce che disaccoppiano il pannello chatbot dal modulo `XSPMPRIS`.])[
  ```vb
  ' Confine verso l'orchestratore (client MCP). Implementato da McpClientOrchestrator
  ' e decorato da DeferredOrchestrator per la costruzione asincrona.
  Public Interface IChatbotOrchestratorClient
      Function InitializeAsync() As Task
      Function SendTurnAsync(...) As Task(Of OrchestratorResponse)
      Function RefineAsync(...) As Task(Of OrchestratorResponse)
      Sub OnTokenRefreshed(nuovoToken As String)
      Sub ResetConversation()
      Sub RichiediAnnullamentoTurno()
      Sub Shutdown()
  End Interface

  ' Estrazione del contesto dal _ViewModel_ di XSPMPRIS. Implementato da XspmprisContextAdapter.
  Public Interface IPlanningContextProvider
      Function BuildContext() As ChatContext
      Function ResolveAppuntamento(progr As Integer) As AppuntamentoSnapshot
      Function ResolveRisorsa(cod As Integer) As String
      Event ContextChanged As EventHandler
  End Interface

  ' Applicazione/rollback del changeset sullo scheduler. Implementato da XspmprisChangesetApplier.
  Public Interface IChangesetApplier
      Function Valida(changeset As ChatbotChangeset) As ValidationResult
      Function ApplicaAnteprima(changeset As ChatbotChangeset) As ApplyResult
      Sub AnnullaAnteprima(changesetId As Guid)
      Sub ConfermaAnteprima(changesetId As Guid)
  End Interface

  ' Estrazione testo dagli allegati. Servizio dispatcher + estrattori specializzati.
  Public Interface IAttachmentExtractionService
      ReadOnly Property MaxCaratteriPerAllegato As Integer
      ReadOnly Property MaxAllegatiPerTurno As Integer
      Function ClassificaTipo(percorsoLocale As String) As AttachmentTipo
      Function EstraiAsync(target As ChatAttachment) As Task
  End Interface

  
  ```
]<cod:interfaces>

#figure( caption: [`DeferredOrchestrator`. _Decorator_ che costruisce l'orchestratore reale in _background_, evitando il blocco del _thread_ di interfaccia all'apertura del pannello.])[
  ```vb
  Public Sub New(factory As Func(Of Task(Of IChatbotOrchestratorClient)))
    ' La factory effettua una chiamata HTTP a Symposium (login): eseguirla nel
    ' thread UI bloccherebbe l'apertura del pannello. La si avvia in background.
    _innerTask = Task.Run(factory)

    ' Osserva un eventuale fallimento della factory per evitare che
    ' un'eccezione non osservata possa terminare il processo.
    _innerTask.ContinueWith(
        Sub(t) Debug.WriteLine("[DeferredOrchestrator] Factory FAULTED: " & t.Exception?.GetBaseException()?.Message),
        CancellationToken.None,
        TaskContinuationOptions.OnlyOnFaulted,
        TaskScheduler.Default)
  End Sub

  Public Async Function SendTurnAsync(...) As Task(Of OrchestratorResponse)
      Dim inner = Await _innerTask            ' attende la costruzione, senza bloccare la UI
      Return Await inner.SendTurnAsync(...)
  End Function
  
  ```

  #figure(
    caption: [Esempio di tool MCP che mappa l'_endpoint_ `mcp/Appuntamenti` del _plugin_ REST di Symposium.],
    ```cs
    [McpServerTool]
    [Description("Cerca appuntamenti del pianificatore. Restituisce titolo, date inizio/fine, luogo, stato, commessa, taskid, risorse assegnate, note interne, note cliente. Filtri: codRisorsa (og_progr), dataDa, dataA, codStato, conto, codLead, commessa, taskId. Possibilità di paginazione attraverso skip e take.")]
    public async Task<string> GetAppuntamenti(IRestClientResolver rcr,
        [Description("Codice appuntamento (ap_progr) per filtrare per appuntamento specifico [Opzionale]")] int? codApp = null,
        [Description("Codice risorsa ORGANIG (og_progr) per filtrare appuntamenti di una risorsa specifica [Opzionale]")] int? codRisorsa = null,
        [Description("Data/ora inizio da (yyyy-MM-dd o yyyy-MM-ddTHH:mm) [Opzionale]")] DateTime? dataDa = null,
        [Description("Data/ora inizio a (yyyy-MM-dd o yyyy-MM-ddTHH:mm) [Opzionale]")] DateTime? dataA = null,
        [Description("Codice stato appuntamento [Opzionale]")] int? codStato = null,
        [Description("Codice conto cliente collegato [Opzionale]")] int? conto = null,
        [Description("Codice lead collegato [Opzionale]")] int? codLead = null,
        [Description("Codice commessa collegata [Opzionale]")] int? commessa = null,
        [Description("Codice task collegato [Opzionale]")] int? taskId = null,
        [Description("Numero di record da saltare")] int skip = 0,
        [Description("Numero massimo di record")] int take = 100)
        {
            // ...
        }
        ```
)<cod:mcp-tool-example>

#figure(caption: [Il filtro anti-loop: termina l'esecuzione al superamento del numero massimo di round di tool.])[
```cs
sealed class MaxToolRoundsFilter(int maxRounds) : IAutoFunctionInvocationFilter
{
    public async Task OnAutoFunctionInvocationAsync(
        AutoFunctionInvocationContext context,
        Func<AutoFunctionInvocationContext, Task> next)
    {
        if (context.RequestSequenceIndex >= maxRounds)
        {
            context.Terminate = true;
            return;
        }
        await next(context);
    }
}
```]<cod:max-tool-rounds>

#figure(caption: [Il filtro di osservabilità: intercetta ogni invocazione di tool e ne accoda nome, parametri ed esito in una `ConcurrentQueue` a disposizione dell'interfaccia.])[
```cs
public sealed record ToolCallRecord(string Nome, string ParametriJson, string? Risultato);

public sealed class ToolCaptureFilter : IAutoFunctionInvocationFilter
{
    private readonly ConcurrentQueue<ToolCallRecord> _queue = new();

    public bool TryDequeue(out ToolCallRecord record) => _queue.TryDequeue(out record!);

    public async Task OnAutoFunctionInvocationAsync(
        AutoFunctionInvocationContext context,
        Func<AutoFunctionInvocationContext, Task> next)
    {
        var parametri = SerializeArgs(context.Arguments);
        await next(context);
        var risultato = context.Result?.GetValue<object?>()?.ToString();
        _queue.Enqueue(new ToolCallRecord(context.Function.Name, parametri, risultato));
    }
}
```]<cod:tool-capture>

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

  #figure(caption: [Estrazione email: gli allegati sono elencati per nome, senza estrazione del contenuto.])[
  ```vb
  ' .msg via MsgReader: solo nomi degli allegati
  If msg.Attachments IsNot Nothing Then
      For Each allegato In msg.Attachments
          Dim att = TryCast(allegato, MsgReader.Outlook.Storage.Attachment)
          If att IsNot Nothing Then
              nomiAllegati.Add(If(att.FileName, "(allegato)"))
          End If
      Next
  End If

  ' .eml via MimeKit: stessa limitazione
  For Each allegato In msg.Attachments
      Dim part = TryCast(allegato, MimeKit.MimePart)
      If part IsNot Nothing AndAlso Not String.IsNullOrEmpty(part.FileName) Then
          nomiAllegati.Add(part.FileName)
      End If
  Next
  ```]<cod:estrazione-allegati-email>

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
```]<cod:changeset-memento>


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
```]<cod:auth-margin>


  #figure(caption: [Traduzione del 401 in un _sentinel_ lato server MCP.])[
```cs
public static string FormatResponse(RestResponseWithData<byte[]> resp)
{
    if (resp.IsSuccessful)      return Encoding.UTF8.GetString(resp.Data!);
    if ((int)resp.StatusCode == 401) return AuthExpiredSentinel;   // "__AUTH_EXPIRED"
    return $"Nessun dato trovato (errore: {resp.StatusCode})";
}

```]<cod:sentinel-401>

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
```]<cod:refresh-reactive>
]