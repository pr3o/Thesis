// Pattern architetturali
#let getPatterns() = {
  let P = ()

  P.push(([Adapter], [Adattatori di contesto/changeset, orchestratore], [Disaccoppia il pannello chatbot da XSPMPRIS; il _ViewModel_ dipende solo da interfacce.]))

  P.push(([Facade], [Modulo chatbot], [Nasconde l'assemblaggio di adapter, orchestratore, _ViewModel_ e _view_ dietro factory statiche.]))

  P.push(([Decorator], [`DeferredOrchestrator`], [Costruisce l'orchestratore reale in _background_; evita il _deadlock_ sync-su-async sul thread UI.]))

  P.push(([Proxy remoto / Bridge], [Orchestratore lato VB], [Proxy verso l'orchestratore C\# che vive in un altro processo; DTO speculari sul _wire_.]))

  P.push(([Chain of Responsibility], [Filtri di auto-invocazione], [Intercetta ogni invocazione di _tool_ per anti-loop, osservabilità e _refresh_ del token.]))

  P.push(([Producer / Consumer], [Filtro di cattura verso coda concorrente], [Sincronizza la cattura dei _tool_ con lo _streaming_ del testo.]))

  P.push(([State Machine], [_Stripper_ dello _streaming_], [Ripulisce e smista lo _stream_ di _chunk_, gestendo i marcatori spezzati a cavallo di due _chunk_.]))

  P.push(([Sentinel value], [`__AUTH_EXPIRED`], [Segnala il token scaduto attraverso un confine che trasporta solo stringhe.]))

  P.push(([Memento], [_Snapshot_ pre-modifica], [Consente il _rollback_ dell'anteprima allo stato precedente.]))

  P.push(([Singleton mutabile thread-safe], [Provider del token], [Unico punto di verità del _bearer_ corrente nel server MCP, aggiornabile a runtime.]))

  return P
}

// Decisioni architetturali e trade-off
#let getDecisions() = {
  let D = ()

  D.push(([Tre processi separati sul nodo A], [Isola il runtime .NET 10 dal processo _legacy_; server MCP _self-contained_.], [Modello e orchestratore _in-process_: impossibile per i runtime divergenti.]))

  D.push(([LLM remoto sul server aziendale], [Centralizza GPU e modello; workstation leggera.], [Modello locale su ogni postazione: costo hardware elevato.]))

  D.push(([Accesso ai dati via REST (MCP)], [I dati restano dietro le porte già presidiate da Symposium.], [Accesso diretto al database: duplica logica e scavalca la sicurezza.]))

  D.push(([L'AI non scrive mai sul database], [_Changeset_ applicato come anteprima; persistenza demandata ad Agilis.], [Scrittura diretta da parte dell'AI: rischio inaccettabile in produzione.]))

  D.push(([_Streaming_ a canali separati], [UX reattiva; ragionamento su canale dedicato e blocco JSON nascosto.], [Risposta unica a fine elaborazione: attesa lunga e output non pulito.]))

  D.push(([_Refresh_ del token a più livelli], [Robustezza alla scadenza del JWT senza interrompere la conversazione.], [Singolo controllo all'avvio: il token scadrebbe a metà sessione.]))

  D.push(([Costruzione _lazy_ dell'orchestratore], [Apertura del pannello immediata e UI sempre reattiva.], [Costruzione sincrona: _deadlock_ e blocco dell'interfaccia.]))

  D.push(([Contesto limitato alla _viewport_], [Evita di far ragionare il modello su record fuori vista.], [Invio dell'intero dataset: costo di token e rumore informativo.]))

  return D
}
