#let glossary-terms = (
  (
    key: "it",
    short: [IT],
    long: [Information Technology],
    description: [L'insieme delle tecnologie, dei sistemi e dei metodi utilizzati per l'elaborazione, la gestione, l'archiviazione e la trasmissione delle informazioni, ambito che comprende infrastrutture di rete, hardware e software.]
  ),
  (
    key: "erp",
    short: [ERP],
    long: [Enterprise Resource Planning],
    description: [Software di gestione aziendale che integra e coordina i principali processi operativi di un'organizzazione (come vendite, acquisti, gestione magazzino, contabilità) in un unico sistema centralizzato, garantendo la coerenza dei dati in tempo reale.]
  ),
  (
    key: "mes",
    short: [MES],
    long: [Manufacturing Execution System],
    description: [Sistema informatizzato utilizzato nel settore manifatturiero per gestire, monitorare e ottimizzare l'esecuzione delle attività in fabbrica, collegando i sistemi gestionali (come l'ERP) con le macchine operative in produzione.]
  ),
  (
    key: "wms",
    short: [WMS],
    long: [Warehouse Management System],
    description: [Software gestionale dedicato al supporto e all'ottimizzazione delle operazioni quotidiane di magazzino, che coordina attività come la ricezione delle merci, lo stoccaggio, il prelievo (picking) e la spedizione.]
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
    key: "ai",
    short: [AI],
    long: [Artificial Intelligence],
    description: [Disciplina dell'informatica che studia i fondamenti teorici, le metodologie e le tecniche per la progettazione di sistemi in grado di simulare le capacità cognitive umane, come l'apprendimento, il ragionamento e la risoluzione di problemi.]
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
    key: "api",
    short: [API],
    long: [Application Programming Interface],
    description: [Insieme di regole e protocolli che permettono a diverse applicazioni software di comunicare tra loro, consentendo l'accesso a funzionalità o dati specifici senza dover condividere l'intero codice sorgente.]
  ),
  (
    key: "rest",
    short: [REST],
    long: [Representational State Transfer],
    description: [Stile architetturale per la progettazione di servizi web, che utilizza metodi HTTP standard (come GET, POST, PUT, DELETE) per operare su risorse rappresentate in formati come JSON o XML, favorendo l'interoperabilità e la scalabilità.]
  ),
  (
    key: "ide",
    short: [IDE],
    long: [Integrated Development Environment],
    description: [Ambiente di sviluppo integrato che fornisce agli sviluppatori un insieme completo di strumenti per scrivere, testare e debugare il codice, spesso includendo un editor di testo, un compilatore, un debugger e funzionalità di gestione del progetto.]
  ),
  (
    key: "knowledge-cutoff",
    short: [Knowledge Cutoff],
    long: [],
    description: [Indica la data esatta in cui si interrompe la raccolta dei dati utilizzati per l'addestramento di un modello di intelligenza artificiale (come un LLM). Il modello non possiede alcuna conoscenza intrinseca di eventi, scoperte o informazioni emerse successivamente a tale data.]
  ),
  (
  key: "sistemi-aumentati",
  short: [Sistemi Aumentati],
  long: [],
  description: [Architetture di intelligenza artificiale in cui un modello linguistico non opera in isolamento, ma viene potenziato integrandolo con l'accesso a basi di dati, strumenti (tool) o interfacce di programmazione (API) esterne. Questo approccio permette all'LLM di superare i limiti della propria memoria interna e di recuperare informazioni aggiornate o private.]
  ),
  (
  key: "agente",
  short: [Agente],
  long: [],
  description: [Un sistema basato su intelligenza artificiale capace di analizzare una richiesta, ragionare per pianificare una sequenza di operazioni e interagire attivamente con l'ambiente esterno tramite l'uso di strumenti. A differenza di un modello standard che si limita a generare testo, un agente prende decisioni e compie azioni (come chiamate API) per raggiungere l'obiettivo prefissato.]
  ),
  (
    key: "sdk",
    short: [SDK],
    long: [Software Development Kit],
    description: [Pacchetto di strumenti di sviluppo che fornisce a programmatori e sviluppatori librerie, interfacce (API), documentazione e strumenti di debug necessari per creare applicazioni su una specifica piattaforma, semplificando e accelerando il processo di scrittura del codice.]
  ),
  (
    key: "memento",
    short: [Memento],
    long: [],
    description: [_Pattern_ comportamentale che cattura e esternalizza lo stato interno di un oggetto senza violare l'incapsulamento, permettendone il ripristino successivo.]
  ),
  (
    key: "bearer",
    short: [Bearer Token],
    long: [],
    description: [_Token_ di autenticazione HTTP trasportato nell'_header Authorization_ con il prefisso `Bearer `, utilizzato per identificare l'utente nelle richieste REST.]
  ),
  (
    key: "sentinel",
    short: [Sentinel Value],
    long: [],
    description: [Valore speciale usato come segnale o marcatore per comunicare una condizione speciale (es: `__AUTH_EXPIRED` per indicare che il _token_ JWT è scaduto).]
  ),
  (
    key: "sse",
    short: [SSE],
    long: [Server Sent Events],
    description: [Protocollo di comunicazione _one-way_ dal _server_ al _client_ basato su HTTP, utilizzato per lo _streaming_ di dati in tempo reale.]
  ),
  (
    key: "quantizzazione",
    short: [Quantizzazione],
    long: [],
    description: [Tecnica di compressione che riduce la precisione numerica dei pesi di una rete neurale (es: da `float32` a `int8`), riducendo memoria e latenza a costo di leggera perdita di accuratezza.]
  )
)
