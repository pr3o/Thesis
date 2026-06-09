#import "../config/thesis-config.typ": glpl, gl,
#import "../config/variables.typ": myTutor
#pagebreak(to:"odd")

= Descrizione stage<cap:descrizione-stage>
#text(style: "italic", [
    In questo capitolo approfondisco l'organizzazione dello stage, il rapporto con l'azienda e svolgo l'analisi dei rischi.
])
#v(1em)

== Competenze da apprendere
Lo stage curricolare ha lo scopo di formare lo studente e prepararlo al mondo del lavoro, permettendogli di applicare le nozioni teoriche in un contesto aziendale. Per questo motivo, entro la fine del progetto, l'obiettivo è quello di acquisire o consolidare le seguenti competenze:
- *Comprensione ed integrazione del software:* capacità di analizzare un'applicazione preeesistente e di progettarne l'estensione tramite l'integraazione di nuovi moduli indipendenti.
- *Sistemi di integrazione AI:* studio, implementazione e configurazione di architetture client-server basate sul MCP per l'interazione avanzata con i LLM.
- *Progettazione architetturale e deployment:* analisi dei vincoli infrastrutturali e definizione delle migliori startegie di rilascio, valutando il bilanciamento dei carichi e l'allocazione dei processi.
- *Applicazione dell'AI per il supporto decisionale:* integrazione di modelli linguistici all'interno di processi aziendali per assistere gli operatori nella pianificazione delle attività e nell'analisi dei vincoli operativi.
- *Progettazione UX/UI:* studio e realizzazione di interfacce utente intuitive, specificatamente pensate per l'interaazione conversazionale all'interno di un gestionale.
- *Redazione tecnica:* capacità di produrre documentazione tecnica strutturata e di presentare in modo chiaro e professionale i risultati e le scelte architetturali adottate.

== Vincoli
Data la natura del progetto, incentrato sull'integrazione di un chatbot in un gestionale preesistente, è necessario considerare alcuni vincoli tecnici:
- Il prodotto deve essere sviluppato usando il framework .NET, permettendo la perfetta integraazione nel sistema esistente.
- Il prodotto deve integrarsi ed interrogare il sistema _Symposium_, utilizzato per esposizione delle #gl("api") per la consultazione dei dati nel database.
- Il prodotto deve essere sviluppato in modo da poter essere facilmente esteso e mantenuto, con un'architettura modulare e ben documentata.
- Il prodotto deve presentare una UI intuitiva e _user-friendly_, rispettante lo stile grafico del gestionale e perfettamente integrata con esso.

== Pianificazione
Durante la discussione con il tutor aziendale, abbiamo definito una pianificazione dettagliata delle attività da svolgere durante le 8 settimane di stage, con l'obiettivo di garantire un progresso costante e un completamento efficace del progetto. Di seguito è riportato il piano settimanale.\ 
L'orario è di 40 ore settimanali, meno eventuali festività o giorni di assenza concordati con il tutor aziendale.
#v(1em)
- *Prima Settimana*
    - Introduzione al sistema di pianificazione e ai processi del reparto _Delivery_.
    - Inizio analisi dei requisiti funzionali del chatbot e identificazione dei principali casi d’uso.
- *Seconda Settimana*
    - Completamento analisi dei requisiti.
    - Progettazione dell’architettura del sistema e definizione delle modalità di integrazione con il pianificatore.
    - Avvio sviluppo.
- *Terza Settimana*
    - Sviluppo delle funzionalità di base del chatbot.
- *Quarta Settimana*
    - Sviluppo delle funzionalità di base del chatbot.
- *Quinta Settimana*
    - Implementazione delle logiche di interrogazione e gestione delle richieste utente.
- *Sesta Settimana*
    - Fine implementazione delle logiche di interrogazione e gestione delle richieste utente.
    - Test funzionali e gestione dei casi di errore.
- *Settima Settimana*
    - Fine test funzionali e gestione dei casi di errore.
    - Ottimizzazione delle funzionalità e miglioramento dell’usabilità.
    - Inizio documentazione tecnica del sistema sviluppato.
- *Ottava Settimana*
    - Documentazione tecnica e revisione finale del progetto.

== Organizzazione del lavoro

== Analisi dei rischi
L'analisi dei rischi è un processo fondamentale nello svolgimento di un progetto, in quanto permette di identificare potenziali problemi che potrebbero ostacolare il raggiungimento degli obiettivi prefissati o rallentare il lavoro.\
L'analisi sviluppati durante i primi giorni di stage, in collaborazione con il tutor aziendale, ha portato all'identificazione dei seguenti rischi principali:
- *R1* - Ritardi nella comprensione del sistema esistente: data la complessità del gestionale e dei processi aziendali, potrebbe essere necessario più tempo del previsto per acquisire una comprensione abbastanza approfondita del sistema e dei suoi flussi di lavoro, rallentando l'inizio dello sviluppo.
- *R2* - Difficoltà nell'integrazione con il sistema esistente: l'integrazione del chatbot con il gestionale potrebbe presentare sfide tecniche impreviste, come problemi di compatibilità o difficoltà nell'accesso ai dati necessari, che potrebbero richiedere più tempo per essere risolti.
- *R3* - Limitazioni tecniche del chatbot: potrebbero emergere limitazioni nelle capacità del chatbot, come difficoltà nel comprendere richieste complesse o gestire casi d'uso specifici, che potrebbero richiedere modifiche al design o alla funzionalità del sistema.
- *R4* - Problemi di usabilità: se l'interfaccia utente del chatbot non è sufficientemente intuitiva o _user-friendly_, potrebbe essere necessario rivedere il design e apportare modifiche per migliorare l'esperienza dell'utente, con conseguente ritardo nella consegna del progetto.
- *R5* - Difficoltà nella scelta del LLM: la selezione del modello linguistico più adatto alle esigenze del progetto potrebbe essere complicata, considerando le diverse opzioni disponibili e le specifiche esigenze di performance, costo e funzionalità.
- *R6* - 

Per mitigare questi rischi, l'azienda, i colleghi ed il Tutor aziendale #myTutor hanno assicurato un supporto continuo durante tutto il periodo di stage, rimanendo disponibili per fornire chiarimenti, risorse e assistenza tecnica quando necessario. Inoltre, è stato concordata una comunicazione regolare settimanale per monitorare i progressi, discutere eventuali problemi e adattare la pianificazione se necessario.