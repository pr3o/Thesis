#import "../config/thesis-config.typ": glpl, gl
#import "data/requirements_list.typ": *

#pagebreak(to:"odd")
= Listati di codice <cap:B-appendice>
== _Endpoint_ REST

== Mappa dei _tool_ MCP esposti

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