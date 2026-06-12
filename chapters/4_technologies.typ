#import "../config/thesis-config.typ": glpl, gl, linkfn
#pagebreak(to:"odd")

= Tecnologie utilizzate<cap:tecnologie-utilizzate>

#text(style: "italic", [
    In questo capitolo illustro le tecnologie utilizzate per lo sviluppo del progetto, descrivendone brevemente le caratteristiche principali e motivando le ragioni che mi hanno portato a sceglierle.
    ])
#v(1em)

== La piattaforma .NET
#figure(
    caption: [Logo di .NET.],
    image("../images/DOTNET-logo.png", alt: "Logo DOTNET", width: 30%)
)
#linkfn("https://dotnet.microsoft.com/it-it/")[.NET] è la piattaforma di sviluppo ed esecuzione creata da Microsoft su cui vengono eseguiti i linguaggi C\# e Visual Basic .NET; fornisce un'estesa libreria di classi base e gestisce l'esecuzione sicura del codice tramite _Common Language Runtime_ e _garbage collection_. Occorre però distinguere due famiglie:
- *.NET Framework*: storico e disponibile solo su Windows, la cui versione finale è la 4.8;
- *.NET moderno*: multipiattaforma e _open-source_, giunto alla versione 10.

Questa distinzione è centrale per il progetto, poiche le due famiglie non sono interoperabili all'interno dello stesso processo.
Il gestionale Agilis è realizzato in Visual Basic .NET su .NET Framework 4.8; i nuovi componenti di intelligenza artificiale (server e client MCP) sono invece sviluppati in C\# su .NET 10, condizione necessaria per poter adottare le librerie più recenti dell'ecosistema - come l'SDK di MCP - non disponibili sul Framework _legacy_.
L'impossibilità di caricare assembly .NET 10 all'interno di un processo .NET Framework 4.8 ha reso la separazione in processi distinti non una semplice scelta di disaccoppiamento, ma una necessità tecnica (cfr. 5.2).

== C\#
#figure(
    caption: [Logo di C\#.],
    image("../images/Csharp-logo.png", alt: "Logo C#", width: 40%)
)
C\# è un linguaggio orientato agli oggetti, fortemente tipizzato e multi-paradigma, sviluppato da Microsoft. Grazie alla sua sintassi chiara, al controllo dei tipi a tempo di compilazione e alla gestione automatica della memoria, rappresenta uno standard industriale per le applicazioni _enterprise_. Nel progetto è stato il linguaggio principale per la logica di _back-end_, rivelandosi ideale per la realizzazione del server MCP e per l'orchestrazione conversazionale.

== Visual Basic .NET
Visual Basic .NET è un linguaggio orientato agli oggetti che, al pari di C\#, viene compilato per la piattaforma .NET. Nel progetto è stato impiegato per il modulo di interfaccia integrato nel gestionale. La scelta non è stata discrezionale, ma dettata da un vincolo di omogeneità: il modulo di pianificazione del reparto _Delivery_ in cui il chatbot si innesta è interamente scritto in Visual Basic .NET, e l'integrazione richide di operare direttamente sugli oggetti dell'interfaccia esistente - leggere lo stato del pianificatore, applicare in anteprima le proposte e agganciarsi al flusso di salvataggio - attività che impongono di sviluppare nello stesso linguaggio e nello stesso processo del modulo ospitante.

== Microsoft Semantic Kernel
Semantic Kernel è il framework di orchestrazione LLM utilizzato nel client. Fornisce l'astrazione del _Kernel_ (host del modello e dei plugin), il _function calling_ automatico - è il framework a decidere e auto-invocare i tool in base al ragionamento del modello - e una catena di filtri che permette di intercettare ogni invocazione di strumento.\
Quest'ultimo meccanismo è stato sfruttato per l'anti-loop, l'osservabilità e il rinnovo del token. I tool MCP esposti dal server vengono mappati in funzioni del _kernel_ e resi invocabili dal modello.

== SDK del Model Context Protocol
#figure(
    caption: [Logo di MCP.],
    image("../images/mcp-logo.png", alt: "Logo MCP", width: 30%)
)
Il protocollo MCP, descritto concettualmente nel @cap:stato-arte, è stato adottato attraverso il relativo SDK per .NET, disponibile solo su .NET 10. L'SDK fornisce le primitive per costruire un server di tool (annotazioni `[McpServerTool]`, trasporto _stdio_) e per realizzare il lato client che scopre i tool a runtime e li espone al modello. È la dipendenza che ha imposto l'uso di .NET 10 per i nuovi componenti.


== Endpoint LLM e Ollama
#figure(
    caption: [Logo di Ollama.],
    image("../images/Ollama-logo.png", alt: "Logo Ollama", width: 20%)
)
L'inferenza è delegata a un endpoint LLM remoto _OpenAI-compatibile_, ospitato su un server aziendale con runtime di tipo #linkfn("https://ollama.com/")[Ollama]. Ollama è uno strumento _open source_ che facilita l'esecuzione, la gestione e il _deployment_ di LLM in ambienti locali: a differenza delle soluzioni _cloud_, consente di eseguire i modelli direttamente sull'infrastruttura ospite, garantendo privacy dei dati e assenza di latenza verso API di terze parti, e offre un'interfaccia conforme allo standard delle API OpenAI#footnote[Società di ricerca e sviluppo che fornisce API per modelli linguistici generativi.]. Questa compatibilità ha permesso di interrogare il modello tramite librerie client standard, mantenendo il sistema indipendente dallo specifico motore di inferenza. L'esecuzione in locale è resa praticabile dalla _quantizzazione_, tecnica che riduce la precisione numerica dei pesi della rete abbassandone i requisiti di memoria e di calcolo.

Il modello adottato è *Gemma 4 12B*. La scelta non è stata immediata ma è il risultato di una fase di sperimentazione comparativa. In una prima fase sono stati condotti numerosi test con modelli della famiglia Qwen, dotati di una catena di ragionamento esplicito (_thinking_) tipicamente vantaggiosa per i compiti di pianificazione. Tali test hanno però evidenziato un comportamento problematico: durante la fase di ragionamento il modello tendeva a "incepparsi", sviluppando catene logiche che si autoalimentavano fino a convincersi di premesse non vere, con conseguenti allucinazioni nelle proposte finali. Gemma 4 12B, a parità di prompt e di strumenti a disposizione, ha mostrato in pratica una minore incidenza di allucinazioni e una maggiore aderenza ai dati effettivamente recuperati tramite i tool, requisito qualitativo prioritario per un sistema di supporto decisionale (cfr. requisito `QMR1`, coerenza delle risposte con il contesto). Per questa ragione la scelta è ricaduta su Gemma. L'indipendenza dal motore di inferenza garantita dall'interfaccia OpenAI-compatibile ha reso questo confronto agevole, poiché il cambio di modello non ha richiesto modifiche al codice client.


== Visual Studio 2026
#figure(
    caption: [Logo di Visual Studio 2026.],
    image("../images/vs-logo.png", alt: "Logo Visual Studio 2026.", width: 30%)
)
L'intero ciclo di produzione del software è stato orchestrato tramite #linkfn("https://visualstudio.microsoft.com/it/vs/")[Visual Studio 2026], l'ambiente di sviluppo integrato (IDE) impiegato per la stesura, il _debugging_ e la compilazione del codice. Scelto per la profonda integrazione con l'ecosistema .NET e il linguaggio C\#, offre analisi statica, suggerimenti contestuali e profilazione delle prestazioni, oltre a un'interfaccia visuale per il versionamento integrata nell'ambiente.

== Git
#figure(
    caption: [Logo di Git.],
    image("../images/Git-logo.png", alt: "Logo Git", width: 40%)
)
#linkfn("https://git-scm.com/")[Git] è un sistema di versionamento distribuito, sviluppato da Linus Torvalds nel 2005, che permette di tracciare le modifiche al codice sorgente e di collaborare in modo efficiente. I suoi elementi principali sono la _working directory_, la _staging area_, i _commit_ (istantanee immutabili dello stato del progetto), i _branch_ (linee di sviluppo parallele) e i _repository_ locale e remoto, riconciliati tramite l'operazione di _merge_. In Omega le funzionalità di Git vengono utilizzate prevalentemente attraverso l'area di versionamento integrata in Visual Studio (@fig:vs-git).

#figure(
    caption: [Sezione Visual Studio 2026 dedicata a versionamento.],
    image("../images/vs-git.png")
)<fig:vs-git>