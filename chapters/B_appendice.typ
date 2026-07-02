#import "../config/thesis-config.typ": glpl, gl
#import "data/requirements_list.typ": *
#import "data/implemetations.typ": *

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
  caption: [Lista degli _endpoint_ esposti da Symposium per il _server_ MCP.],
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
  caption: [Mappa _tool_ MCP esposti --> fonti dati.],
)<tab:tools>

== Interfacce di disaccoppiamento

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

  ' Estrazione del contesto dal ViewModel di XSPMPRIS. Implementato da XspmprisContextAdapter.
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
]

== Costruzione _lazy_ dell'orchestratore

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
]