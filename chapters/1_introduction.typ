#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "../config/thesis-config.typ": gl, glpl, glossary-style, linkfn

= Introduzione <cap:introduzione>
#text(style: "italic", [
    In questo capitolo descrivo l'azienda, introduco il progetto, e spiego le motivazioni che mi hanno portato a sceglierlo.
])
#v(1em)

== Il contesto aziendale e l'ambito del progetto
#figure(
    caption: [Logo di Omega S.r.l.],
    image("../images/omega-logo.png", alt: "Logo Omega S.r.l.", width: 80%)
)
Il presente lavoro di tesi nasce all'interno dell'esperienza di tirocinio curricolare svolta presso #linkfn("https://www.omegagruppo.it/")[Omega Gruppo], realtà informatica specializzata nello sviluppo di soluzioni software gestionali ed #gl("erp") per l'ottimizzazione dei processi aziendali. In un mercato competitivo in cui l'efficienza operativa rappresenta un fattore critico di successo, la digitalizzazione e l'automazione dei flussi di lavoro sono diventate leve strategiche imprescindibili. \
Tra le soluzioni _core_ dell'azienda figura _Agilis_, un sistema gestionale strutturato per la  pianificazione e il monitoraggio delle risorse aziendali. In particolare, il modulo dedicato alla gestione della _delivery_ e della pianificazione delle attività (denominato internamento _XSPMPRIS_) costituisce uno degli strumenti più critici per gli operatori aziendali. Attraverso questo modulo, i responsabili della pianificazione coordinano l'assegnazione dei task, la gestione dei carichi di lavoro e la schedulazione delle commesse, interfacciandosi costantemente con un'architettura complessa e con un patrimonio informativo di grandi dimensioni, storicizzato su database relazionali e mediato da un ecosistema di servizi #gl("rest") (denominato _Symposium_).

== Definizione del problema e motivazioni
La definizione delle attività all'interno di un contesto aziendale moderno è un compito ad alto carico cognitivo. Gli operatori si trovano spesso a dover donsultare simultaneamente molteplici schermate, verificare la disponibilità delle risorse umane, incrociare scadenze stringenti e rispettare vincoli di competenze tecniche. Questo processo, sebbene supportato dalle interfacce grafiche tradizionali dell'#gl("erp"), risulta intrinsecamente rigido: ogni operazione richiede una sequenza precisa di interazioni manuali (clic, inserimento dati, navigazione tra menu) e una profonda conoscenza pregressa delle convenzioni software. \
Negli ultimi anni, l'avvento dei #glpl("llm") ha rivoluzionato il paradigma di interazione uomo-macchina, introducendo la possibilità di elaborare e comprendere il linguaggio naturale con un livello di flessibilità senza precedenti. Tuttavia, l'adozione di queste tecnologie in contesti _Enterprise_ sbatte spesso contro due barriere fondamentali:

1. *L'isolamento informativo:* i modelli commerciali o _open-source_ nascono privi di conoscenza rispetto ai dati in tempo reale residenti all'interno dei sistemi gestionali privati.
2. *L'affidabilità e la sicurezza dei dati:* permettere a un agente basato su intelligenza artificiale di scrivere direttamente o modificare in autonomia record sensibili su un database di produzione introduce rischi inaccettabili in termini di consistenza e conformità software.

La sfida centrale di questo progetto risiede quindi nel superare la rigidità delle interfacce tradizionali senza compromettere la sicurezza del sistema informativo preesistente, offrendo agli utenti uno strumento in grado di tradurre l'intento espresso in linguaggio naturale in azioni concrete e verificate.

== Obiettivi del progetto e contributi originali
L'obiettivo principale di questo lavoro è la progettazione e lo sviluppo di un assistente conversazionale intelligente, integrato nativamente nell'interfaccia utente del modulo di pianificazione di _Agilis_. Per garantire un'integrazione flessibile, standardizzata e disaccoppiata tra l'applicazione client e i modelli di intelligenza artificiale, si è scelto di adottare il _Model Context Protocol_ o #gl("mcp"), un protocollo emergente aperto che standardizza il modo in cui i modelli #gl("ai") si connettono a sorgenti di dati e strumenti esterni. \

Il perimetro del lavoro si inserisce in un ecosistema in cui il gestionale client _Agilis_, lo strato di servizi backend _Symposium_ e il database erano già consolidati e preesistenti. Il contributo originale di questa tesi si concentra interamente sul *livello di integrazione conversazionale* e sull'architettura di orchestrazione. Nello specifico, l'attività di ricerca e sviluppo ha riguardato:
- La progettazione e l'implementazione della sezione chatbot direttamente all'interno dell'interfaccia utente di _Agilis_.
- Lo sviluppo di un'architettura client/server basata su protocollo MCP, in grado di esporre in sicurezza le funzionalità del gestionale sotto forma di "strumenti" (#glpl("tool")) invocabili dall'LLM.
- L'orchestrazione dei flussi di pensiero del modello e la gestione dello streaming della risposta in tempo reale.
- L'ideazione di un meccanismo transazionale di *anteprima in memoria*: il chatbot non effettua scritture dirette sul database, ma genera una proposta strutturata che l'operatore può valutare visivamente e confermare esplicitamente prima della persistenza definitiva.
- La gestione della sicurezza e del ciclo di vita dei _token_ di autenticazione lungo tutta la catena dei processi separati.

L'approccio proposto si configura come un sistema di supporto decisionale: l'intelligenza artificiale estende le capacità operative dell'utente, riducendo i tempi di inserimento e ricerca, ma l'ultima parola e il controllo sulla validità dell'operazione rimangono saldamente in mano all'operatore umano.