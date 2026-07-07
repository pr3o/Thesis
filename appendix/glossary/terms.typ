#let glossary-terms = (
  (
    key: "agente",
    short: [Agente],
    long: [],
    description: [Un sistema basato su intelligenza artificiale capace di analizzare una richiesta, ragionare per pianificare una sequenza di operazioni e interagire attivamente con l'ambiente esterno tramite l'uso di strumenti. A differenza di un modello standard che si limita a generare testo, un agente prende decisioni e compie azioni (come chiamate API) per raggiungere l'obiettivo prefissato.]
  ),
  (
    key: "ai",
    short: [AI],
    long: [Artificial Intelligence],
    description: [Disciplina dell'informatica che studia i fondamenti teorici, le metodologie e le tecniche per la progettazione di sistemi in grado di simulare le capacità cognitive umane, come l'apprendimento, il ragionamento e la risoluzione di problemi.]
  ),
  (
    key: "api",
    short: [API],
    long: [Application Programming Interface],
    description: [Insieme di regole e protocolli che permettono a diverse applicazioni software di comunicare tra loro, consentendo l'accesso a funzionalità o dati specifici senza dover condividere l'intero codice sorgente.]
  ),
  (
    key: "backend",
    short: [Backend],
    long: [],
    description: [Il "dietro le quinte" di un'applicazione web. Gestisce la logica di funzionamento, l'elaborazione dei dati e la comunicazione con il database e altri servizi, rimanendo di fatto invisibile all'utente finale.]
  ),
  (
    key: "bearer",
    short: [Bearer Token],
    long: [],
    description: [_Token_ di autenticazione HTTP trasportato nell'_header Authorization_ con il prefisso `Bearer `, utilizzato per identificare l'utente nelle richieste REST.]
  ),
  (
    key: "chatbot",
    short: [Chatbot],
    long: [],
    description: [Software progettato per simulare una conversazione con un essere umano. Utilizza l'intelligenza artificiale per comprendere le richieste dell'utente espresse in linguaggio naturale e fornire risposte o compiere azioni pertinenti.]
  ),
  (
    key: "client",
    short: [Client],
    long: [],
    description: [Dispositivo o programma (come un browser web o l'interfaccia utente di un'app) che richiede servizi, dati o risorse a un altro computer (chiamato server) all'interno di una rete.]
  ),
  (
    key: "database",
    short: [Database],
    long: [],
    description: [Archivio informatico strutturato (spesso chiamato "base di dati") in cui le informazioni vengono memorizzate e organizzate in modo da poter essere facilmente ricercate, aggiornate e gestite in sicurezza dal _software_.]
  ),
  (
    key: "erp",
    short: [ERP],
    long: [Enterprise Resource Planning],
    description: [_Software_ di gestione aziendale che integra e coordina i principali processi operativi di un'organizzazione (come vendite, acquisti, gestione magazzino, contabilità) in un unico sistema centralizzato, garantendo la coerenza dei dati in tempo reale.]
  ),
  (
    key: "frontend",
    short: [Frontend],
    long: [],
    description: [La parte visibile di un _software_ o di un sito web, con cui l'utente può interagire direttamente tramite schermi, pulsanti e testi. È strettamente legata al concetto di Interfaccia Utente (UI).]
  ),
  (
    key: "ide",
    short: [IDE],
    long: [Integrated Development Environment],
    description: [Ambiente di sviluppo integrato che fornisce agli sviluppatori un insieme completo di strumenti per scrivere, testare e debuggare il codice, spesso includendo un editor di testo, un compilatore, un debugger e funzionalità di gestione del progetto.]
  ),
  (
    key: "it",
    short: [IT],
    long: [Information Technology],
    description: [L'insieme delle tecnologie, dei sistemi e dei metodi utilizzati per l'elaborazione, la gestione, l'archiviazione e la trasmissione delle informazioni, ambito che comprende infrastrutture di rete, hardware e software.]
  ),
  (
    key: "json",
    short: [JSON],
    long: [JavaScript Object Notation],
    description: [Formato di testo leggero e semplice da leggere, utilizzato per scambiare dati tra sistemi informatici. È lo standard principale per la comunicazione tra le moderne applicazioni web.]
  ),
  (
    key: "jwt",
    short: [JWT],
    long: [JSON Web Token],
    description: [Standard di sicurezza utilizzato per trasmettere in modo affidabile informazioni tra due parti. Nel progetto è impiegato per verificare l'identità dell'utente al momento dell'accesso e mantenere la sua sessione sicura nel tempo.]
  ),
  (
    key: "knowledge-cutoff",
    short: [Knowledge Cutoff],
    long: [],
    description: [Indica la data esatta in cui si interrompe la raccolta dei dati utilizzati per l'addestramento di un modello di intelligenza artificiale (come un LLM). Il modello non possiede alcuna conoscenza intrinseca di eventi, scoperte o informazioni emerse successivamente a tale data.]
  ),
  (
    key: "llm",
    short: [LLM],
    long: [Large Language Model],
    description: [Modello di intelligenza artificiale avanzato, addestrato su enormi quantità di dati testuali, capace di comprendere, elaborare e generare linguaggio naturale con un livello di fluidità e coerenza molto simile a quello umano.]
  ),
  (
    key: "mcp",
    short: [MCP],
    long: [Model Context Protocol],
    description: [Protocollo standardizzato progettato per facilitare e mettere in sicurezza la comunicazione tra i modelli di intelligenza artificiale (come gli LLM) e fonti di dati o strumenti esterni (Tool), permettendo all'assistente di recuperare informazioni di contesto specifiche e in tempo reale.]
  ),
  (
    key: "memento",
    short: [Memento],
    long: [],
    description: [_Pattern_ comportamentale che cattura e esternalizza lo stato interno di un oggetto senza violare l'incapsulamento, permettendone il ripristino successivo.]
  ),
  (
    key: "adapter",
    short: [Adapter],
    long: [],
    description: [_Pattern_ strutturale che converte l'interfaccia di una classe in un'altra attesa dai client, consentendo a classi altrimenti incompatibili di collaborare.]
  ),
  (
    key: "decorator",
    short: [Decorator],
    long: [],
    description: [_Pattern_ strutturale che aggiunge responsabilità a un oggetto in modo dinamico, avvolgendolo in un componente con la stessa interfaccia.]
  ),
  (
    key: "chain-of-responsibility",
    short: [Chain of Responsibility],
    long: [],
    description: [_Pattern_ comportamentale in cui una richiesta attraversa una catena di gestori, ciascuno dei quali può processarla, modificarla o inoltrarla al successivo.]
  ),
  (
    key: "macchina-a-stati",
    short: [Macchina a stati],
    long: [State machine],
    description: [Modello comportamentale che rappresenta il comportamento di un sistema come un insieme di stati finiti e delle transizioni tra essi, attivate da eventi o condizioni.]
  ),
  (
    key: "mes",
    short: [MES],
    long: [Manufacturing Execution System],
    description: [Sistema informatizzato utilizzato nel settore manifatturiero per gestire, monitorare e ottimizzare l'esecuzione delle attività in fabbrica, collegando i sistemi gestionali (come l'ERP) con le macchine operative in produzione.]
  ),
  (
    key: "prompt",
    short: [Prompt],
    long: [],
    description: [Il testo, la domanda o il comando che un utente inserisce per dare un'istruzione a un sistema di intelligenza artificiale. Determina il contesto e l'obiettivo della risposta che il modello andrà a generare.]
  ),
  (
    key: "quantizzazione",
    short: [Quantizzazione],
    long: [],
    description: [Tecnica di compressione che riduce la precisione numerica dei pesi di una rete neurale (es: da `float32` a `int8`), riducendo memoria e latenza a costo di leggera perdita di accuratezza.]
  ),
  (
    key: "rest",
    short: [REST],
    long: [Representational State Transfer],
    description: [Stile architetturale per la progettazione di servizi web, che utilizza metodi HTTP standard (come GET, POST, PUT, DELETE) per operare su risorse rappresentate in formati come JSON o XML, favorendo l'interoperabilità e la scalabilità.]
  ),
  (
    key: "sdk",
    short: [SDK],
    long: [Software Development Kit],
    description: [Pacchetto di strumenti di sviluppo che fornisce a programmatori e sviluppatori librerie, interfacce (API), documentazione e strumenti di debug necessari per creare applicazioni su una specifica piattaforma, semplificando e accelerando il processo di scrittura del codice.]
  ),
  (
    key: "sentinel",
    short: [Sentinel Value],
    long: [],
    description: [Valore speciale usato come segnale o marcatore per comunicare una condizione particolare al programma (es: `__AUTH_EXPIRED` per indicare che il _token_ di accesso è scaduto).]
  ),
  (
    key: "server",
    short: [Server],
    long: [],
    description: [Computer o sistema informatico potente che fornisce dati, servizi o risorse ad altri computer (i client) attraverso una rete. Nel contesto web, elabora le richieste degli utenti e ospita il cuore delle applicazioni.]
  ),
  (
    key: "sistemi-aumentati",
    short: [Sistemi Aumentati],
    long: [],
    description: [Architetture di intelligenza artificiale in cui un modello linguistico non opera in isolamento, ma viene potenziato integrandolo con l'accesso a basi di dati, strumenti (tool) o interfacce di programmazione (API) esterne. Questo approccio permette all'LLM di superare i limiti della propria memoria interna e di recuperare informazioni aggiornate o private.]
  ),
  (
    key: "sse",
    short: [SSE],
    long: [Server Sent Events],
    description: [Protocollo di comunicazione _one-way_ dal server al client basato su HTTP, utilizzato per lo _streaming_ di dati in tempo reale.]
  ),
  (
    key: "tool",
    short: [Tool],
    long: [],
    description: [Strumento, applicativo o utilità software progettata per eseguire una funzione specifica, assistere un utente in un'attività tecnica o permettere a un sistema AI di interagire con ambienti esterni ed eseguire azioni.]
  ),
  (
    key: "tool-use",
    short: [Tool Use],
    long: [],
    description: [Pratica di utilizzare strumenti esterni per estendere le capacità di un modello di intelligenza artificiale, permettendogli di accedere a dati, eseguire operazioni o interagire con sistemi esterni in modo sicuro ed efficiente.]
  ),
  (
    key: "ui",
    short: [UI],
    long: [User Interface],
    description: [Interfaccia Utente, ovvero l'ambiente visivo e interattivo composto da schermate, pulsanti, testi e menu attraverso il quale una persona comunica e interagisce in modo intuitivo con un software.]
  ),
  (
    key: "ux",
    short: [UX],
    long: [User Experience],
    description: [Esperienza Utente, ovvero l'insieme di percezioni, emozioni e risposte che una persona prova quando interagisce con un software. A differenza della UI (che si occupa dell'aspetto visivo), la UX si concentra su quanto il sistema sia facile, intuitivo, utile e soddisfacente da usare nel lavoro quotidiano.]
  ),
  (
    key: "wms",
    short: [WMS],
    long: [Warehouse Management System],
    description: [Software gestionale dedicato al supporto e all'ottimizzazione delle operazioni quotidiane di magazzino, che coordina attività come la ricezione delle merci, lo stoccaggio, il prelievo (_picking_) e la spedizione.]
  ),
  (
    key: "allucinazione",
    short: [Allucinazioni],
    long: [],
    description: [Fenomeno in cui un'intelligenza artificiale genera informazioni false, inesatte o del tutto inventate, presentandole però con un tono sicuro, logico e convincente come se fossero reali e verificate.]
  ),
  (
    key: "cloud",
    short: [Cloud],
    long: [Cloud Computing],
    description: [L'erogazione di servizi informatici (come server, archiviazione dati o _software_) tramite Internet. Nel progetto, si contrappone all'esecuzione "in locale", dove invece i programmi (come l'LLM) girano direttamente sui computer fisici dell'azienda, garantendo maggiore privacy.]
  ),
  (
    key: "endpoint",
    short: [Endpoint],
    long: [],
    description: [L'indirizzo web specifico o il punto di contatto esatto attraverso cui due _software_ comunicano tra loro (ad esempio, un indirizzo a cui il chatbot invia una richiesta per ottenere la lista degli appuntamenti dal gestionale).]
  ),
  (
    key: "framework",
    short: [Framework],
    long: [],
    description: [Una struttura _software_ di base, simile a un'impalcatura pre-costruita, che fornisce agli sviluppatori un insieme di strumenti, librerie e regole per costruire applicazioni complesse più velocemente e in modo standardizzato, senza dover partire da zero.]
  ),
  (
    key: "open-source",
    short: [Open-Source],
    long: [],
    description: [Modello di sviluppo in cui il codice sorgente di un _software_ è reso pubblico, permettendo a chiunque di studiarlo, modificarlo, migliorarlo e distribuirlo liberamente.]
  ),
  (
    key: "plugin",
    short: [Plugin],
    long: [],
    description: [Un piccolo programma aggiuntivo (spesso chiamato anche estensione o modulo) che si "aggancia" a un software principale per aggiungergli nuove funzionalità specifiche, senza la necessità di modificare il codice del programma di base.]
  ),
  (
    key: "token-ai",
    short: [Token (AI)],
    long: [],
    description: [In ambito intelligenza artificiale, un _token_ è l'unità di base in cui viene suddiviso il testo (può essere una parola intera, una sillaba o una singola lettera). I modelli leggono e generano testo "un _token_ alla volta". Da non confondere con il _Token_ di sicurezza (vedi JWT) usato per l'autenticazione.]
  ),
)