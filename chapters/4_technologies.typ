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
#linkfn("https://dotnet.microsoft.com/it-it/")[.NET] @dotnet è la piattaforma di sviluppo ed esecuzione creata da Microsoft su cui vengono eseguiti i linguaggi C\# e Visual Basic .NET; fornisce un'estesa libreria di classi base e gestisce l'esecuzione sicura del codice tramite _Common Language Runtime_ e _garbage collection_. Occorre però distinguere due famiglie:
- *.NET Framework*: storico e disponibile solo su Windows, la cui versione finale è la 4.8;
- *.NET moderno*: multipiattaforma e _open-source_, giunto alla versione 10.

Questa distinzione è centrale per il progetto, poiché le due famiglie non sono interoperabili all'interno dello stesso processo.
Il gestionale Agilis è realizzato in Visual Basic .NET su .NET Framework 4.8; i nuovi componenti di intelligenza artificiale (server e client MCP) sono invece sviluppati in C\# su .NET 10, condizione necessaria per poter adottare le librerie più recenti dell'ecosistema --- come l'SDK di MCP --- non disponibili sul Framework _legacy_.
L'impossibilità di caricare assembly .NET 10 all'interno di un processo .NET Framework 4.8 ha reso la separazione in processi distinti non una semplice scelta di disaccoppiamento, ma una necessità tecnica (cfr. @sez:isolamento).

== C\#
#figure(
    caption: [Logo di C\#.],
    image("../images/Csharp-logo.png", alt: "Logo C#", width: 40%)
)
C\# è un linguaggio orientato agli oggetti, fortemente tipizzato e multi-paradigma, sviluppato da Microsoft. Grazie alla sua sintassi chiara, al controllo dei tipi a tempo di compilazione e alla gestione automatica della memoria, rappresenta uno standard industriale per le applicazioni _enterprise_. Nel progetto è stato il linguaggio principale per la logica di _back-end_, rivelandosi ideale per la realizzazione del server MCP e per l'orchestrazione conversazionale.

== Visual Basic .NET
Visual Basic .NET è un linguaggio orientato agli oggetti che, al pari di C\#, viene compilato per la piattaforma .NET. Nel progetto è stato impiegato per il modulo di interfaccia integrato nel gestionale. La scelta non è stata discrezionale, ma dettata da un vincolo di omogeneità: il modulo di pianificazione del reparto _Delivery_ in cui il chatbot si innesta è interamente scritto in Visual Basic .NET, e l'integrazione richiede di operare direttamente sugli oggetti dell'interfaccia esistente --- leggere lo stato del pianificatore, applicare in anteprima le proposte e agganciarsi al flusso di salvataggio --- attività che impongono di sviluppare nello stesso linguaggio e nello stesso processo del modulo ospitante.

== Microsoft Semantic Kernel
Semantic Kernel è il framework di orchestrazione LLM utilizzato nel client. Fornisce l'astrazione del _Kernel_ (host del modello e dei plugin), il _function calling_ automatico --- è il framework a decidere e auto-invocare i _tool_ in base al ragionamento del modello --- e una catena di filtri che permette di intercettare ogni invocazione di strumento.\
Quest'ultimo meccanismo è stato sfruttato per l'anti-loop, l'osservabilità e il rinnovo del token. I _tool_ MCP esposti dal server vengono mappati in funzioni del _kernel_ e resi invocabili dal modello.

== SDK del Model Context Protocol
#figure(
    caption: [Logo di MCP.],
    image("../images/mcp-logo.png", alt: "Logo MCP", width: 30%)
)
L'integrazione del protocollo MCP, descritto concettualmente nella @cap:stato-arte, è stata realizzata avvalendosi del relativo SDK per .NET @mcp-csharp-sdk.
Questa libreria costituisce la dipendenza fondamentale che ha imposto l'uso di .NET 10 per i nuovi componenti del sistema, essendone un requisito tecnico imprescindibile.
Dal punto di vista implementativo, l'SDK fornisce tutti i blocchi costitutivi per l'architettura: per il lato server, semplifica l'esposizione delle funzionalità aziendali e gestisce la comunicazione bidirezionale tramite i canali standard di _input/output_; per il lato client, offre meccanismi per interrogare il server, mappare a _runtime_ gli strumenti esposti e tradurli in interfacce comprensibili per il modello linguistico.


== #gl("endpoint") LLM e Ollama
#figure(
    caption: [Logo di Ollama.],
    image("../images/Ollama-logo.png", alt: "Logo Ollama", width: 25%)
)
L'inferenza è delegata a un endpoint LLM remoto _OpenAI-compatibile_, ospitato su un server aziendale con runtime di tipo #linkfn("https://ollama.com/")[Ollama] @ollama. Ollama è uno strumento _open source_ che facilita l'esecuzione, la gestione e il _deployment_ di LLM in ambienti locali: a differenza delle soluzioni #gl("cloud"), consente di eseguire i modelli direttamente sull'infrastruttura ospite, garantendo privacy dei dati e assenza di latenza verso API di terze parti, e offre un'interfaccia conforme allo standard delle API OpenAI#footnote[Società di ricerca e sviluppo che fornisce API per modelli linguistici generativi.] @openai. Questa compatibilità ha permesso di interrogare il modello tramite librerie client standard, mantenendo il sistema indipendente dallo specifico motore di inferenza. L'esecuzione in locale è resa praticabile dalla #gl("quantizzazione"), tecnica che riduce la precisione numerica dei pesi della rete abbassandone i requisiti di memoria e di calcolo.

#figure(
    caption: [Logo di Qwen.],
    image("../images/Qwen_Logo.png", alt: "Logo Qwen", width: 60%)
)

Per il motore di inferenza è stato adottato un modello della famiglia #linkfn("https://qwen.ai/home")[*Qwen*] @qwen, sviluppata da Alibaba Cloud. Qwen è una famiglia di _Large Language Model_ _open-source_ con spiccate capacità di ragionamento logico-deduttivo e comprensione multilingue, italiano compreso. La famiglia offre un supporto nativo alla catena di ragionamento esplicita (_thinking chain_): il modello può separare il proprio monologo interno (visibile all'operatore come canale di trasparenza) dalla risposta destinata all'utente, abilitando questo comportamento tramite un semplice _flag_ `think` nel _payload_ della richiesta HTTP. Qwen è disponibile in diverse taglie; per questo progetto sono state valutate la variante a 9 miliardi di parametri (9B) e quella a 27 miliardi (27B), entrambe in versione quantizzata per ridurre i requisiti hardware.
Le dinamiche che hanno guidato la selezione della versione e taglia dello specifico modello sono descritte nella @sez:scelta-modello.


== Visual Studio 2026
#figure(
    caption: [Logo di Visual Studio 2026.],
    image("../images/vs-logo.png", alt: "Logo Visual Studio 2026.", width: 30%)
)
L'intero ciclo di produzione del software è stato orchestrato tramite #linkfn("https://visualstudio.microsoft.com/it/vs/")[Visual Studio 2026] @visual-studio, l'ambiente di sviluppo integrato (IDE) impiegato per la stesura, il _debugging_ e la compilazione del codice. Scelto per la profonda integrazione con l'ecosistema .NET e il linguaggio C\#, offre analisi statica, suggerimenti contestuali e profilazione delle prestazioni, oltre a un'interfaccia visuale per il versionamento integrata nell'ambiente.

== Git
#figure(
    caption: [Logo di Git.],
    image("../images/Git-logo.png", alt: "Logo Git", width: 40%)
)
#linkfn("https://git-scm.com/")[Git] @git è un sistema di versionamento distribuito, sviluppato da Linus Torvalds nel 2005, che permette di tracciare le modifiche al codice sorgente e di collaborare in modo efficiente. I suoi elementi principali sono la _working directory_, la _staging area_, i _commit_ (istantanee immutabili dello stato del progetto), i _branch_ (linee di sviluppo parallele) e i _repository_ locale e remoto, riconciliati tramite l'operazione di _merge_. In Omega le funzionalità di Git vengono utilizzate prevalentemente attraverso l'area di versionamento integrata in Visual Studio (@fig:vs-git).

#figure(
    caption: [Sezione Visual Studio 2026 dedicata a versionamento.],
    image("../images/vs-git.png")
)<fig:vs-git>