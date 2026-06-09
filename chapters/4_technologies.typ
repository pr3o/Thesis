#import "../config/thesis-config.typ": glpl, gl, linkfn
#pagebreak(to:"odd")

= Tecnologie utilizzate<cap:tecnologie-utilizzate>

#text(style: "italic", [
    In questo capitolo illustro le tecnologie utilizzate per lo sviluppo del progetto, descrivendo brevemente le loro caratteristiche principali. 
    ])
#v(1em)

== Large Language Models
I _Large Language Models_ sono modelli probabilistici avanzati, progettati per la comprensione e la generazione di testo in linguaggio naturale. Queste capacità vengono acquisite durante la fase di addestramento attraverso la processazine di enormi quantità di dati per apprendere miliardi di parametri. Data questa loro caratteristica, un bias nei dati di addestramento può rendere l'_output_ di un LLM meno affidabile.Per tale motivo, allo stato attuale, si è ritenuto inopportuno sviluppare un sistema in grado di pianificare le attività aziendali in totale autonomia; si è optato invece per un approccio di supporto decisionale che richieda sempre la validazione e il controllo finale da parte di un operatore umano. \
Nonostante le notevoli capacità di sintesi e ragionamento logico, questo modelli presentano un limite architetturale fondamentale: operano come sistemi isolati. Per concezione, un LLM puro non è in grado di eseguire operazioni dirette sull'ambiente esterno, come interrogare una base dati gestionale, leggere il file system o invocare API esterne. Per superare questa barriera ed operare in scenari applicativi reali, il modello deve avvalersi del #gl("tool-use"): l'LLM assume il ruolo di orchestratore decisionale, ma necessita di strumenti esterni messi a disposizione dal sistema ospite per eseguire materialmente le azioni deterministiche.

== Model Context Protocol
#figure(
    caption: [Logo di MCP.],
    image("../images/mcp-logo.png", alt: "Logo MCP", width: 30%)
)
Al fine di standardizzare la comunicazione tra i modelli linguistici e questi strumenti esterni, è stato introdotto il #linkfn("https://modelcontextprotocol.io/docs/getting-started/intro")[Model Context Protocol] (MCP). Questo protocollo _open-source_ sviluppato da Anthropic#footnote[Società statunitense di ricerca e sviluppo nell’intelligenza artificiale.], basato su un'architettura _host-client-server_, risolve il problema della frammentazione eliminando la necessità di sviluppare un'integrazione dedicata per ogni combinazione tra applicazione di intelligenza artificiale e sorgente dati o strumento esterno.\
Paragonabile a quello che lo standard USB-C rappresenta per i dispositivi hardware, MCP funge da livello di connessione universale per le applicazioni basate su intelligenza artificiale. Tramite MCP, l'accesso a sorgenti dati esterne (come database aziendali o file locali), strumenti esecutivi e flussi di lavoro viene uniformato attraverso un’interfaccia coerente.\
Tale astrazione disaccoppia nettamente il motore di ragionamento dell’intelligenza artificiale dall’infrastruttura esecutiva aziendale, garantendo un’interazione sicura, modulare e facilmente scalabile. L'adozione di questo standard riduce inoltre in modo significativo la complessità e i tempi di sviluppo ingegneristico: godendo di un ampio supporto da parte dell'ecosistema (che include nativamente i principali ambienti di sviluppo e assistenti AI), MCP promuove il paradigma del _build once_, _integrate everywhere_#footnote[Riadattamento del noto motto _write once, run anywhere_, qui inteso come interoperabilità universale di un singolo server con molteplici client AI.], permettendo a un singolo server di estendere universalmente le capacità di molteplici client.\
Come illustrato nello schema concettuale in @fig:mcp-diagram, l'architettura si divide in due domini comunicanti tramite un flusso dati bidirezionale: da un lato le applicazioni basate su intelligenza artificiale, dall'altro le sorgenti dati e i servizi di terze parti. MCP si posiziona al centro come protocollo standardizzato, fungendo da ponte universale. In tale architettura un _host_#footnote[Applicazione ospite.] - come un #gl("ide") o un assistente conversazionale - istanzia, per ciascun _server_ a cui si collega, un _client_ MCP che ne media la comunicazione; ogni _server_, a sua volta, espone le proprie capacità a tuttii client in modo uniforme.
#figure(
    caption: [Rappresentazione architetturale di alto livello del Model Context Protocol (MCP).],
    image("../images/mcp-simple-diagram.png", width: 120%)
)<fig:mcp-diagram>
== Ollama
#figure(
    caption: [Logo di Ollama.],
    image("../images/Ollama-logo.png", alt: "Logo Ollama", width: 20%)
)
#linkfn("https://ollama.com/")[Ollama] è uno strumento open-source progettato per facilitare l'esecuzione, la gestione e il _deployment_ di LLM in ambienti locali. A differenza di molte soluioni basate su _cloud_, Ollama permette di eseguire i modelli linguistici direttamente sull'infrastruttura ospite. Questa caratteristica risulta fondamentale nei contesti aziendali, in quanto garantisce la totale privacy dei dati elaborati e l'assenza di latenza di rete legata alle API di terze parti, fornanedo al contempo un'interfaccia #gl("rest") conforme allo standard delle API OpenAI#footnote[Società di ricerca e sviluppo che fornisce API per modelli linguistici generativi.] per l'interrogazione del modello scelto. Tale compatibilità ha permesso di interrogare il modello tramite librerie client standard, mantenendo il sistema indipendente dallo specifico motore di inferenza.\
L'esecuzione in locale è resa praticabile dalla quantizzazione dei modelli supportata da _Ollama_, tecnica che riduce la precisione numerica dei pesi della rete neurale abbassandone i requisiti di memori a e di calcolo, rendendo eseguibili modelli di grandi dimensioni anche su hardware non specialistico.

== C\#
#figure(
    caption: [Logo di C\#.],
    image("../images/Csharp-logo.png", alt: "Logo C#", width: 40%)
)
C\# è un linguaggio di programmazione orientato agli oggetti, fortemente tipizzato e multi-paradigma, sviluppato da Microsoft. Grazie alla sua sintassi chiara, al forte controllo dei tipi a tempo di compilazione e alla robusta gestione della memoria tramite garbage collection, rappresenta uno standard industriale per lo sviluppo di applicazioni enterprise. Nel contesto di questo progetto, C\# è stato adottato come linguaggio principale per lo sviluppo della logica di back-end, rivelandosi lo strumento ideale per la realizzazione del server MCP e per l'orchestrazione delle interazioni con i servizi preesistenti.

== Visual Basic .NET
Visual Basic .NET è un linguaggio orientato agli oggetti sviluppato da Microsoft che, al pari di C\#, viene compilato per essere eseguito sulla piattaforma .NET. Nel progetto è stato impiegato per realizzare il modulo di interfaccia integrato nel gestionale. La scelta non è stata discrezionale ma dettata da un vincolo di omogeneità con il sistema ospitante: l'applicazione _Agilis_, e in particolare il modulo di pianificazione del reparto _Delivery_ in cui il chatbot si innesta, sono interamente scritti in Visual Basic .NET. L'integrazione richide infatti di operare direttamente sugli oggetti dell'interfaccia esistente - leggere lo stato del pianificatore, applicare in anteprima le proposte e agganciarsi al flusso di salvataggio già presente - attività che impongono di sviluppare nello stesso linguaggio e nello stesso processo del modulo ospitante.

== .NET
#figure(
    caption: [Logo di .NET.],
    image("../images/DOTNET-logo.png", alt: "Logo DOTNET", width: 30%)
)
#linkfn("https://dotnet.microsoft.com/it-it/")[.NET] è la piattaforma di sviluppo ed esecuzione creata da Microsoft su cui vengono eseguiti i linguaggi C\# e Visual Basic .NET; fornisce un'estesa libreria di classi base (BCL) e gestisce l'esecuzione sicura del codice tramite _Common Language Runtime_ e _garbage collection_. Occorre però distinguere due famiglie:
- *.NET Framework*: storico e disponibile solo su Windows, la cui versione finale è la 4.8;
- *.NET moderno*: multipiattaforma e _open-source_, giunto alla versione 10.
Questa distinzione è centrale per il progetto, poiche le due famiglie non sono interoperabili all'interno dello stesso processo.
#v(0.5em)
Il gestionale _Agilis_, in cui il modello è innestato, è realizzato in Visual Basic .NET su .NET Framework 4.8; i nuovi componenti di intelligenza artificiale (server e client MCP) sono invece sviluppati in C\# su .NET 10, condizione necessaria per poter adottare le librerie più recenti dell'ecosistema, come l'SDK del Model Context Protocol, non disponibili sul Framework legacy.\
L'impossibilità di caricare assembly .NET 10 all'interno di un processo .NET Framework 4.8 ha reso la separazione in processi distinti non una semplice scelta di disaccoppiamento, ma una necessità tecnica: i due mondi, pur condividendo le radici comuni della piattaforma .NET, comunicano attraverso un canale di interoperabilità inter-processo, isolando così le rispettive dipendenze.

== Visual Studio 2026
#figure(
    caption: [Logo di Visual Studio 2026.],
    image("../images/vs-logo.png", alt: "Logo Visual Studio 2026.", width: 30%)
)
L'intero ciclo di produzione del software è stato orchestrato tramite #linkfn("https://visualstudio.microsoft.com/it/vs/")[Visual Studio 2026], l'ambiente di sviluppo integrato (IDE - Integrated Development Environment) principale impiegato per la stesura, il debugging e la compilazione del codice. Scelto per la sua profonda e nativa integrazione con l'ecosistema .NET e il linguaggio C\#, offre agli sviluppatori una piattaforma di prim'ordine che include strumenti avanzati di analisi statica, suggerimenti contestuali del codice e profilazione granulare delle prestazioni. L'utilizzo di questo IDE ha ottimizzato notevolmente i tempi di implementazione, fornendo uno spazio di lavoro centralizzato per la gestione dell'intero ciclo di vita del software, compresa l'interfaccia visuale per il versionamento. Questo accentramento delle funzioni in un unico applicativo consente allo sviluppatore di concentrarsi pienamente sulla scrittura e sul refactoring della logica di dominio senza doversi interfacciare costantemente con tool di terze parti.

== Git
#figure(
    caption: [Logo di Git.],
    image("../images/Git-logo.png", alt: "Logo Git", width: 40%)
)

Sviluppato da Linus Torvalds nel 2005, #linkfn("https://git-scm.com/")[Git] è un sistema di versionamento distribuito che permette di tenere traccia delle modifiche al codice sorgente e di collaborare con altri sviluppatori in modo efficiente. Grazie alla sua velocità, flessibilità e robustezza esso è diventato uno degli strumenti più popolari per la gestione del codice sorgente.\
I principali elementi che compongo l'archiettura e il flusso di lavoro di Git sono:
- *Working Directory*: la cartella locale in cui sono presenti i file del progetto su cui lo sviluppatore sta operando. Rappresenta una specifica versione estratta dal database, pronta per essere consultata o modificata.
- *Staging Area*: un'area di transizione in cui vengono "preparati" e registrati i file modificati. Questo livello intermedio permette di selezionare in modo granulare quali specifiche modifiche andranno a fasr parte del salvataggio successivo.
- *Commit*: l'unità fondamentale della cronolgoia di Git. Rappresenta uno _snapshot_ dello stato del progettoin un preciso istante. Ogni _commit_ è immutabile e contiene, oltre ai file, i metadati essenziali come l'autore, la data ed un messaggio descrittivo del lavoro svolto.
- *Branch*: un puntatore mobile a uno specifico commit. I _branch_ permettono di creare linee di sviluppo parallelel ed isolate, rendendo possibile lavorare su nuove funzionalità o correzioni senza intaccare il ramo principale del progetto.
- *Repository*: il database strutturato che contiene l'intero storico del progetto, tutti i _commit_ e i relativi _branch_. Il _repository *Locale*_ risiede sul dispositivo dello sviluppatore, mentre il _repository *Remoto*_ (ospitato su server dedicati o piattaforme di hosting) funge da punto di convergenza per sincronizzare il lavoro di tutto il team.
- *Merge*: sebbene sia un'operazione più che un componente strutturale, rappresenta il meccanismo fondamentale per unire le divergenze tra due _branch_ differenti, reintegrando le modifiche isolate all'interno del flusso di sviluppo principale.

Per mitigare la complessità operativa tipica delle interfacce a riga di comando ed ottimizzare i tempi di sviluppo, in azienda spesso si utilizzano software che incapsulino tutte le funzionalità di Git all'interno di unìinterfaccia grafica intuitiva. Nel caso specifico di Omega, la soluzione più comunemente utilizzata è l'area dedicata al versionamento integrata nativamente all'interno dell'ambiente di sviluppo Visual Studio 2026 (raffigurata in @fig:vs-git). Consente una gesioneisuale, integrata e centralizzata di tutte le operazioni di _staging_, tracciamento dei conflitti e sincronizzazione dei rami direttamente all'interno dell'IDE.

#figure(
    caption: [Sezione Visual Studio 2026 dedicata a versionamento.],
    image("../images/vs-git.png")
)<fig:vs-git>