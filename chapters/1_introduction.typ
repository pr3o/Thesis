#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "../config/thesis-config.typ": gl, glpl, glossary-style, linkfn

= Introduzione <cap:introduzione>
#text(style: "italic", [
    In questo capitolo descrivo l'azienda, introduco il progetto, e spiego le motivazioni che mi hanno portato a sceglierlo.
])
#v(1em)

== Omega
#figure(
    caption: [Logo di Omega S.r.l.],
    image("../images/omega-logo.png", alt: "Logo Omega S.r.l.", width: 80%)
    )
#linkfn("https://www.omegagruppo.it/")[Omega] è un Digital Transformation Partner che affianca le imprese nell'innovazione dei processi e nel raggiungimento dei propri obiettivi di business. Nata nel 1998 con sede principale a Quarto d'Altino (Venezia), l'azienda ha conosciuto una rapida e solida espansione, arrivando attualmente a contare 6 sedi distribuite sul territorio, 152 professionisti e un bacino di 1.056 clienti.\ 
L'azienda propone soluzioni #gl("it") per supportare l'intera catena del valore aziendale, promuovendo una trasformazione digitale dei processi delle imprese, con un forte accento sulla sostenibilità, l'ottimizzazione energetica e l'impiego dell'Intelligenza Artificiale.\ 
Tra le competenze principali spiccano l'implementazione e lo sviluppo di software gestionali ed #gl("erp"), sistemi #gl("mes") per il controllo della produzione, applicativi di _Supply Chain Management_ per la pianificazione predittiva e piattaforme di logistica e #gl("wms").

== Il progetto
Il gestionale proprietario _Agilis_ dispone di un modulo dedicato alla pianificazione delle attività operative, impiegato dal reparto _Delivery_ per l'organizzazione dei piani di lavoro e l'allocazione delle risorse. Tale processo decisionale risulta particolarmente complesso, poiché richiede la gestione simultanea di molteplici vincoli operativi: dalle competenze specifiche e la disponibilità temporale delle risorse, fino al rispetto delle scadenze e delle priorità di esecuzione.\

In questo contesto, l'obiettivo del progetto di tirocinio consiste nello sviluppo e nell'integrazione di un assistente virtuale basato sul #gl("mcp") e sull'utilizzo di #gl("llm"). Il chatbot si configurerà come uno strumento di supporto decisionale all'interno del modulo di pianificazione, in grado di interagire in linguaggio naturale con gli operatori. Nello specifico, il sistema permetterà di interrogare i piani di lavoro, suggerire assegnazioni compatibili con le agende e le competenze degli operatori, segnalare proattivamente eventuali conflitti o vincoli non rispettati e, infine, assistere l'utente nelle operazioni di modifica della pianificazione.

== Scelta del progetto
Le motivazioni che mi hanno portato a scegliere di affrontare il tirocinio in Omega sono state molteplici:
- *Realtà ben strutturata e in forte crescita:* Omega Gruppo rappresenta un ambiente dinamico, giovane e stimolante, in costante espansione, che offre ampie opportunità di crescita professionale e personale. Inoltre gode di una solida reputazione nel settore, con un portafoglio clienti diversificato e in continua espansione, che testimonia la qualità dei servizi offerti e la capacità di adattarsi alle esigenze del mercato.
- *Opportunità di apprendimento:* il progetto proposto rappresenta un'opportunità unica per approfondire le mie competenze in ambito di intelligenza artificiale, in particolare nell'applicazione di LLM e MCP in contesti aziendali reali. L'utilizzo di linguaggio e framework non studiati, come C\#, Visual Basic .NET e .NET, mi ha permesso di ampliare le mie competenze tecniche e di acquisire nuove _skills_, arricchendo il mio curriculum. 
- *Allineamento con i miei interessi:* l'utilizzo di tecnologie all'avanguardia e l'integrazione di soluzioni di intelligenza artificiale rappresentano un ambito di grande interesse per me. L'integrazione di un assistente virtuale in un gestionale è una nuova esperienza che mi ha permesso di esplorare nuove frontiere dell'#gl("ai"), con un focus particolare sull'elaborazione tramite #glpl("tool") MCP e la standardizzazione delle risposte da parte del LLM. 
- *Impatto concreto:* il progetto nasce da un bisogno reale della stessa Omega, che vuole testare le potenzialità di queste tecnologie, con l'obiettivo di vendere questa funzionalità ai propri clienti. Il lavoro svolto durante il tirocinio avrà quindi un impatto diretto sull'azienda, contribuendo a migliorare i processi interni e a fornire un valore aggiunto ai clienti finali.