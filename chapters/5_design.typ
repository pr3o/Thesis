#import "../config/thesis-config.typ": glpl, gl,
#pagebreak(to:"odd")

= Progettazione <cap:progettazione>

#text(style: "italic", [
    In questo capitolo affronto la progettazione del sistema: descrivo l'architettura di distribuzione sui tre nodi, i componenti principali e le loro interazioni, il modello di interazione uomo-AI ad anteprima e conferma, la gestione della sicurezza e del ciclo di vita del token, e le principali decisioni architetturali con i relativi compromessi.
])
#v(1em)

== Architettura di distribuzione: i tre nodi
La soluzione si distribuisce su tre nodi di rete distinti. È il punto da cui discende ogni altra scelta progettuale, poichè determina firewall, sicurezza e _deployment_.
#v(1em)
- *Nodo A - Workstation operatore.* Ospita l'interfaccia nativa di Agilis e l'intera catena MCP locale: il client e il server MCP sono processi figli, avviati _on-demand_ all'apertura del pannello chatbot. Tutto il carico di orchestrazione locale è confinato qui.
- *Nodo B - Server AI aziendale.* È il servizio centralizzato e remoto che esegue il modello di linguaggio, raggiunto via HTTP. Nessun modello gira sulla workstation: il carico inferenziale è confinato sul server, così da non gravare sulle postazioni degli operatori.
- *Nodo C -Server applicativo Agilis.* Ospita lo strato dei servizi REST di Symposium, il plugin MCP e il database del gestionale.
#v(1em)
I flussi sono rigidamente direzionali. Il nodo A è il fulcro: apre un flusso HTTP verso il nodo B per inviare i _prompt_ e ricevere lo _streaming_ dei token, e interroga in parallelo il nodo C tramite chiamate REST per recuperare i dati gestionali. I nodi B e C non comunicano mai direttamente tra loro, garantendo che il _back-end_ aziendale resti isolato dall'infrastruttura AI.


== I componenti software e l'isolamento in processi <sez:isolamento>
Il sistema si articola in quattro componenti:
#v(1em)

1. *OmegaGruppo.McpServer* (.NET 10, nodo A) - espone i dati del gestionale come tool MCP, chiamando le API REST di Symposium.
2. *OmegaGruppo.McpClient* (.NET 10 + Semantic Kernel, nodo A) - è l'host dell'LLM e l'orchestratore conversazionale: avvia il server MCP, espone una _Named Pipe_ verso Agilis e dialoga con l'LLM remoto.
3. *Agilis / XSPMPRIS - Chatbot* (Visual Basic .NET, nodo A) - la UI del pannello, la lettura del contesto dello _scheduler_, l'anteprima e l'applicazione delle proposte, l'acquisizione e il _refresh_ del token.
4. *Symposium - Plugin MCP* (ASP.NET Core, nodo C) - il _back-end_ REST `mcp/*` che interroga il database del gestionale.
#v(1em)

Dei quattro, i primi tre sono stati progettati ex-novo nell'ambito di questo lavoro; il quarto estende il _back-end_ Symposium preesistente.\

Sul nodo A i tre processi sono deliberatamente separati per tre ragioni. Anzitutto l'*isolamento di runtime*: Agilis è _legacy_ (.NET Framework / VB), mentre client e server MCP richiedono .NET 10 e Semantic Kernel; processi separati evitano alla radice i conflitti di runtime e di dipendenze, soddisfacendo il vincolo di piena compatibilità con il gestionale (`CMR1`). In secondo luogo il *ciclo di vita gestito*: ogni apertura del pannello avvia un client MCP, che a sua volta avvia il server; la chiusura effettua uno _shutdown_ coordinato a cascata che evita i processi orfani. Infine la natura *self-contained* del server MCP, pubblicabile come singolo file e indipendente da un runtime .NET preinstallato sulla workstation.

== Il flusso end-to-end
Si consideri la richiesta _"Pianifica l'attività di collaudo per Marco la prossima settimana"_. Il flusso si svolge così:
#v(1em)
1. *Raccolta del contesto.* Agilis raccoglie il messaggio e costruisce il contesto (periodo visibile, risorse e appuntamenti nella _viewport_) ed eventuali allegati estratti in testo.
2. *Invio sulla pipe.* Inoltra la richiesta al client MCP sulla _Named Pipe_ (A #sym.arrow.r A).
3. *Inoltro all'LLM.* Il client MCP inoltra la richiesta all'LLM remoto (A #sym.arrow.r B) via Semantic Kernel, in _streaming_.
4. *Decisione e auto-invocazione dei tool.* Guidato dal _system prompt_, il modello decide quali tool invocare; Semantic Kernel li auto-invoca (ad esempio `get_turni_calendario`, obbligatorio prima di proporre, poi `get_tasks`, `get_risorse`, `get_appuntamenti`).
5. *Esecuzione REST.* Il server MCP esegue ogni tool chiamando l'endpoint `mcp/*` di Symposium (A #sym.arrow.r C) con il _Bearer_ JWT; Symposium interroga il database e restituisce JSON.
6. *Produzione della risposta e cattura delle proposte.* L'LLM produce in _streaming_ il testo visibile e il ragionamento su un canale separato. A differenza degli approcci classici basati sul _parsing_ di un JSON generato a fine risposta, il sistema cattura le alternative di pianificazione in modo reattivo: il modello le dichiara invocando un _tool_ dedicato alla proposta, che funge da validatore deterministico.
7. *Eventi verso Agilis.* Il client MCP invia ad Agilis una sequenza di eventi (_delta_, _thinking_, _tool_, _end_); l'evento finale contiene le alternative strutturate.
8. *Selezione e anteprima.* Agilis mostra le alternative come _card_; selezionandone una, l'anteprima viene applicata allo _scheduler_ su oggetti in memoria, senza alcuna scrittura sul database.
9. *Decisione finale.* L'operatore conferma (salvataggio standard di Agilis), annulla (_rollback_) oppure affina la proposta.

== Il modello di interazione AI-uomo: anteprima e conferma
È il cuore concettuale del sistema e la risposta progettuale al vincolo per cui il chatbot non deve mai modificare la pianificazione in autonomia (`CMR3`). L'assistente non scrive mai sul database: produce un _changeset_, ovvero un insieme di operazioni di creazione, aggiornamento o cancellazione sugli appuntamenti, che viene applicato *solo in memoria* come anteprima sullo _scheduler_. Gli elementi modificati sono marcati come proposti dal chatbot e collegati a un identificativo di _changeset_; prima di mutarli viene salvato uno _snapshot_ (pattern _Memento_) che consente il _rollback_.\

La conferma non è un'azione speciale dell'AI: è il normale flusso di salvataggio di Agilis, innescato dall'operatore esattamente come per una modifica manuale. L'annullamento ripristina lo _snapshot_ pre-modifica. Si ottiene così una netta separazione delle responsabilità: l'AI *propone*, l'operatore *dispone*, e la persistenza resta nel codice collaudato del gestionale. Il pannello è governato da una macchina a stati (Idle #sym.arrow.r AwaitingResponse #sym.arrow.r Browsing #sym.arrow.r Selected #sym.arrow.r Previewing #sym.arrow.r Refining) che rende espliciti e mutuamente esclusivi gli stati dell'interazione.

== Sicurezza e ciclo di vita del token <sez:sicurezza-token>
I dati di autorizzazione nascono nella sessione Agilis dell'operatore già autenticato e fluiscono lungo la catena di processi. Vale una distinzione netta, dettata da un principio di minimizzazione dei segreti: le *credenziali* (la password) restano nel processo Agilis, dove servono solo al login iniziale verso Symposium, e non vengono mai passate ai processi MCP; l'*identità di tenant* (azienda, ditta, nome utente) viene propagata come variabile d'ambiente al client MCP, che la ribadisce al server, il quale la trasforma in _header_ fissi delle chiamate REST, usati da Symposium per il filtro _multi-tenant_ che confina ogni query alla ditta dell'operatore; il *token JWT* è l'unico segreto che attraversa i confini di processo, e solo come _Bearer_.\

La scadenza del JWT durante una conversazione - la sessione usa token a tempo - è gestita con una difesa stratificata, articolata su più livelli: un margine di scadenza che rinnova il token poco prima della sua effettiva invalidazione senza attendere l'errore 401; una rilettura del provider che, su 401, ritenta con il token più recente già disponibile; un _refresh_ reattivo che, riconosciuto un apposito segnale di token scaduto, ne richiede uno nuovo ad Agilis e ritenta l'operazione; un _refresh_ proattivo che aggiorna il token tra un turno e l'altro; e un unico punto di verità che custodisce il _bearer_ corrente. La meccanica di dettaglio di questi livelli è descritta nel capitolo di implementazione.

== Pattern Architetturali adottati <sez:pattern-architetturali>
I pattern architetturali non sono fini a sé stessi: ciascuno risolve un problema specifico imposto dai vincoli o dai requisiti non funzionali. I più significativi sono il pattern *Adapter*, che disaccoppia il pannello chatbot da XSPMPRIS facendo dipendere il _ViewModel_ solo da interfacce; il *Decorator*, usato per costruire l'orchestratore reale in _background_ ed evitare il blocco del _thread_ di interfaccia; la *Chain of Responsibility*, realizzata dai filtri di auto-invocazione per anti-loop, osservabilità e _refresh_ del token; il *Memento*, per lo _snapshot_ di _rollback_ dell'anteprima; e un insieme di *macchine a stati* per la pulizia e lo smistamento dello _stream_ del modello. Il catalogo completo dei pattern, con la relativa motivazione, è riportato in #link(<cap:A-appendice>)[Appendice A].

== Decisioni architetturali e _trade-off_
Le scelte di fondo del progetto possono essere lette come una sequenza di compromessi consapevoli. La separazione in tre processi sul nodo A isola il runtime .NET 10 dal processo _legacy_, a fronte dell'impossibilità di mantenere modello e orchestratore in-process. La collocazione dell'LLM su un server remoto centralizza GPU e modello e mantiene leggera la workstation, scartando l'opzione del modello locale per il costo hardware su ogni macchina. L'accesso ai dati esclusivamente via REST mantiene i dati dietro le porte già presidiate, evitando di duplicare logica e di scavalcare la sicurezza con un accesso diretto al database. Il principio per cui l'AI non scrive mai sul database, applicando i _changeset_ come anteprima in memoria, scarta la scrittura diretta come rischio inaccettabile su un gestionale di produzione. Lo _streaming_ a canali separati privilegia una UX reattiva rispetto a un'unica risposta a fine elaborazione. Il _refresh_ del token a più livelli garantisce robustezza alla scadenza del JWT senza interrompere la conversazione. La costruzione _lazy_ dell'orchestratore evita il _deadlock_ all'apertura del pannello. Infine, il contenimento del contesto alla sola _viewport_ evita che il modello ragioni su migliaia di record fuori vista, contenendo costo di token e rumore informativo. La tabella sinottica di queste decisioni, con le alternative scartate, è riportata in #link(<cap:A-appendice>)[Appendice A].

=== Scelta del modello e _trade-off_ inferenziali <sez:scelta-modello>
L'elaborazione semantica e decisionale del sistema è affidata a un modello della famiglia Qwen, selezionato per il suo supporto nativo a una catena di ragionamento esplicito (_thinking_).

Durante la fase di sviluppo, l'adozione di questa architettura ha richiesto una valutazione comparativa tra la variante *Qwen 3.5 a 9 miliardi di parametri (9B)* e *Qwen 3.6 a 27 miliardi di parametri (27B)*. I test hanno evidenziato un _trade-off_ netto: nelle prove svolte solo la variante a 27B ha mostrato un'aderenza pressochè completa ai dai recuperati tramite i _tool_, riducendo le allucinazioni a casi trascurabili (cfr. requisito QMR1).
Tuttavia, l'esecuzione del modello a 27B introduce requisiti hardware e latenze di risposta attualmente incompatibili con l'infrastruttura di test e con i target di reattività del sistema.

Si è pertanto deciso di mantenere la variante 9B come base per lo sviluppo e l'implementazione del prototipo.
Poichè il modello 9B, durante elaborazioni prolungate, tende fisiologicamente a sviluppare catene logiche che si autoalimentano sfociando in allucinazioni, si è reso necessario un profondo intervento architetturale sul software circostante per mitigarne i limiti.

=== Mitigazione delle allucinazioni tramite delega deterministica <sez:strategia-anti-allucinazione>
La criticità inferenziale del modello 9B è stata affrontata applicando un principio di progettazione rigoroso: la riduzione sistematica del carico operazionale demandato al modello.
Ogni complessità deterministica è stata spostata dall'LLM al software circostante.
#v(1em)
- *Validazione esterna delle proposte.* Le proposte non vengono estratte da un blocco JSON libero, ma dichiarate tramite un _tool_ dedicato che verifica programmaticamente l'assenza di conflitti in agenda, scartando a monte le proposte invalide.
- *_Tool_ ad alta granularità.* Sono stati sviluppati _tool_ complessi (es. calcolo delle disponibilità) che restituiscono risultati finiti, evitando che il modello debba comporre mentalmente più strumenti elementari e dedurne le intersezioni temporali.
- *Gestione e contenimento del contesto.* Il _prompt_ è stato arricchito con tecniche _few-shot_ (esempi di chiamate), limitando contestualmente il rumore informativo (es. imponendo un tetto massimo di 20 appuntamenti visibili per finestra temporale).
#v(1em)

L'insieme di queste strategie ha permesso di abbattere drasticamente il tasso di occorrenza delle allucinazioni, rendendo il prototipo basato su 9B operativo e affidabile per la maggior parte delle casistiche.
Tuttavia, per garantire la totale sicurezza decisionale richiesta da un ambiente di produzione, l'adozione del modello a 27B rimane un requisito strutturale imprescindibile. 