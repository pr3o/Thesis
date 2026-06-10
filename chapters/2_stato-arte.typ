#import "../config/thesis-config.typ": glpl, gl,
#import "../config/variables.typ": myTutor
#pagebreak(to:"odd")

= Stato dell'Arte e Tecnologie<cap:stato-arte-tecnologie>
#text(style: "italic", [
    In questo capitolo approfondisco l'organizzazione dello stage, il rapporto con l'azienda e svolgo l'analisi dei rischi.
])
#v(1em)

== L'evoluzione dei _Large Language Models_
Gli _LLMs_ hanno subito negli ultimi anni un'evoluzione radicale, ridefinendo i confini dell'ingegneria del software e dell'intelligenza artificiale applicata. Basati prevalentemente sull'architettura _Transformer_ introdotta da Vaswani _et al._ nel 2017, questi modelli vengono pre-addestrati su enormi volumi di testo non strutturato per apprendere le relazioni statistiche e semantiche tra i token. \
Inizialmente concepiti come predittori statistici di testo e generatori di prosa, i modelli più recenti hanno dimostrato capacità emergenti avanzate. Tra queste spiccano il ragionamento logico-deduttivo, la comprensione del contesto e la generazione di codice sorgente sintatticamente corretto. Tuttavia, l'architettura pura di un LLM presenta un limite intrinseco noto come _isolamento informativo_: il modello risponde basandosi esclusivamente sulla conoscenza cristallizzata al momento del suo _knowledge cutoff_, risultando cieco rispetto ai dati dinamici, in tempo reale o privati. Inoltre, i modelli puri soffrono del fenomeno delle "allucinazioni", ovvero la generazione di risposte palusibili ma fattualmente errate o prive di fondamento reale.

== Il paradigma del _Tool Use_ e della _Function Calling_
Per superare i limiti dell'isolamento informativo e ridurre l'incidenza delle allucinazioni, la ricerca si è orientata verso sistemi aumentati, evolvendo il ruolo dell'LLM da mero generatore di testo ad "agente" in grado di interagire con l'ambiente esterno. Questo cambiamento di paradigma è noto come #gl("tool-use") o _Function Calling_.\
Sotto questo modello, l'LLM non viene più interrogato per fornire direttamente la risposta finale a un problema complesso che richiede dati esterni. Al contrario, viene addestrato a riconoscere quando una richiesta dell'utente necessita di informazioni integrative o di un'azione applicativa. Invece di rispondere in linguaggio naturale, il modello interrompe la generazione e produce un output strutturato (tipicamente in formato JSON) che specifica il nome di una funzione esterna e i relativi parametri di invocazione.\
L'applicazione ospite (il client) intercetta questo output, esegue la funzione chiamando le #gl("api") o effettuando le query necessarie, e restituisce il risultato testuale al modello. L'LLM, infine, rielaboraquesto nuovo contesto per formulare la risposta finale. Questo meccanismo sposta il carico computazionale dell'elaborazione del dato dall'intelligenza artificiale al software deterministico, garantendo la precisione del risultato.

== Il Model Context Protocol
#figure(
    caption: [Logo di MCP.],
    image("../images/mcp-logo.png", alt: "Logo MCP", width: 30%)
)

Sebbene il paradigma della _Function Calling_ sia ampiamente supportato dai principali provider di modelli, la sua implementazione ha storicamente sofferto di una forte frammentazione. Ogni piattaforma _AI_ e ogni framework di sviluppo ha storicamente imposto schemi di definizione dei tool, formati di serializzazione e modelli di trasporto proprietari. Di conseguenza, integrare la stessa suite di strumenti aziendali con modelli differenti ha spesso richiesto la riscrittura di complessi layer di adattamento (_adapter_).\
Per risolvere questa problematica di interoperabilità, è stato introdotto il _Model Context Protocol_. Si tratta di un protocollo aperto e standardizzato che formalizza l'architettura di comunicazione tra le applicazioni client guidate dall'AI e le sorgenti di dati o strumenti esterni (i server MCP).\

L'architettura di MCP si basa su una chiara separazione dei ruoli tramite un pattern _Client-Server_:
- *MCP Server:* è un processo indipendente che espone in modo standardizzato tre tipi di risorse primitive:
    1. _Prompts:_ Modelli di istruzioni preconfigurati.
    2. _Resources:_ Dati testuali o binari in sola lettura (es. file log, documentazione)
    3. _Tools:_ Funzioni eseguibili ed eseguite dal server che possono modificare lo stato o interrogare sistemi esterni, descritte tramite schemi _JSON Schema_.
- *MCP Client:* è l'applicazione che mantiene la sessione con l'LLM. Il client interroga il server per scoprirne le capacità, inoltra gli schemi dei tool al modello e, quando il modello richiede l'invocazione di uno strumento, instrada la richiesta al server appropriato, restituendone la risposta all'LLM.

Il protocollo a livello di trasporto utilizza canali standard come flussi di input/output standard (`stdio`) per processi locali o connessioni persistenti (come i _Server Sent Events_ su HTTP) per l'architettura distribuita, sfruttando la serializzazione dei messaggi basata sullo standard _JSON-RPC 2.0._.
