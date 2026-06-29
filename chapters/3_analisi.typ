#import "../config/thesis-config.typ": glpl, gl
#import "data/requirements_list.typ": *

#pagebreak(to:"odd")

= Analisi dei requisiti<cap:analisi>

#text(style: "italic", [
    In questo capitolo analizzo gli utenti e i casi d'uso del sistema e ne derivo i requisiti, distinti per tipologia in funzionali, non funzionali e vincoli; per non appesantire la trattazione, la specifica completa e le user stories sono riportate in #link(<cap:A-appendice>)[Appendice A].
])
#v(1em)


== Analisi degli utenti
Il prodotto è concepito per gli operatori del reparto _Delivery_ di un'azienda cliente del Gruppo Omega che adotta il gestionale Agilis: personale incaricato di gestire le consegne ai clienti, organizzare i turni di lavoro e coordinare le attività con le altre divisioni aziendali. L'obiettivo è fornire una soluzione concreta che incrementi l'efficienza e la produttività del reparto, automatizzando il supporto decisionale e liberando tempo da destinare ad attività collaterali altrimenti trascurate. Poiché il chatbot è integrato nel modulo di pianificazione di Agilis — un'area ad accesso ristretto agli operatori _Delivery_ — questi rappresentano l'unica tipologia di utenza del sistema, e ogni interazione avviene sempre in seguito all'autenticazione nel gestionale.

== Metodo: user stories e codifica dei requisiti
I requisiti funzionali sono stati raccolti tramite _user stories_, strumento dello sviluppo agile che esprime un requisito dal punto di vista dell'utente nella forma\
#v(0.5em)
#align(center, text(style: "italic", ["come [utente], voglio [obiettivo], in modo da [beneficio]"]))
#v(0.5em)
ed è corredato di _acceptance criteria_ verificabili. Le storie sono organizzate in _epic_, aggregazioni tematiche che facilitano la pianificazione. A ciascun requisito è poi associato un codice del tipo `(F/Q/C)(M/D/O)R`, che ne indica la tipologia - funzionale, qualitativo o di vincolo - e la necessità - _mandatory_, _desirable_ od _optional_. La lista integrale delle _user stories_, con i relativi _acceptance criteria_, e le tabelle di tracciamento requisito-fonte sono riportate in #link(<cap:A-appendice>)[Appendice A].

== Macro-requisiti
Le _user stories_ raccolte possono essere raggruppate in tre macro-aree funzionali, che definiscono l'architettura generale e fungono da linee guida per i requisiti di dettaglio.\
La prima riguarda la *comprensione del contesto operativo*: l'assistente deve estrarre specifiche entità --- quali operatori, commesse, date e tipologie di task --- da richieste destrutturate in lingua italiana, eventualmente arricchite da allegati.\
La seconda riguarda il *supporto decisionale non distruttivo*: il sistema formula piani di lavoro anche complessi senza alterare in autonomia il database di produzione, lasciando all'utente il controllo su ogni operazione.\
La terza riguarda la *trasparenza del flusso logico*: l'operatore deve poter ispezionare il processo di ragionamento del modello e gli strumenti utilizzati, così da poterne verificare e validare le proposte.

== Quadro dei requisiti
L'analisi ha prodotto *trenta requisiti funzionali*, *sette requisiti qualitativi* e *quattro vincoli*.\ 
I requisiti funzionali coprono l'intero ciclo d'uso: la gestione del contesto (allegati e conversazioni come fonte), l'interrogazione informativa sui dati del gestionale, la generazione di proposte di pianificazione e il loro affinamento iterativo, l'anteprima e l'applicazione selettiva delle operazioni, la creazione guidata di appuntamenti, la riorganizzazione delle agende a fronte di imprevisti e la gestione della conversazione.\
I requisiti qualitativi fissano le proprietà trasversali: coerenza delle risposte con il contesto, chiarezza delle notifiche, allineamento tra gestionale e database, integrazione visiva con Agilis, tempi di risposta ragionevoli e tracciabilità delle elaborazioni.\
I vincoli, infine, recepiscono le condizioni imposte dal contesto aziendale: sviluppo su framework .NET compatibile con Agilis, integrazione con Symposium, divieto di modifiche autonome alla pianificazione e architettura modulare.\

La @tab:riepilogo-requisiti ne riassume la distribuzione per tipologia e priorità; il tracciamento puntuale di ciascun requisito verso la _user story_ o la fonte di origine è in #link(<cap:A-appendice>)[Appendice A].

#v(1em)
#show figure: set block(breakable: false)
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto, auto),
    table.header([*Tipo*], [*Mandatory*], [*Desirable*],[*Optional*], [*Somma*]),
    [Functional], [#getFR(getLen: true).at(0)], [#getFR(getLen: true).at(1)], [#getFR(getLen: true).at(2)], [#getFR(getLen: true).sum()],
    [Qualitative], [#getQR(getLen: true).at(0)], [#getQR(getLen: true).at(1)], [#getQR(getLen: true).at(2)], [#getQR(getLen: true).sum()],
    [Constraint], [#getCR(getLen: true).at(0)], [#getCR(getLen: true).at(1)], [#getCR(getLen: true).at(2)], [#getCR(getLen: true).sum()],
    [*Totale*],
      [*#{getFR(getLen: true).at(0)+getQR(getLen: true).at(0)+getCR(getLen: true).at(0)}*],
      [*#{getFR(getLen: true).at(1)+getQR(getLen: true).at(1)+getCR(getLen: true).at(1)}*],
      [*#{getFR(getLen: true).at(2)+getQR(getLen: true).at(2)+getCR(getLen: true).at(2)}*],
      [*#{getFR(getLen: true).sum()+getQR(getLen: true).sum()+getCR(getLen: true).sum()}*],
    align: (center+horizon)
  ),
  caption: "Riepilogo dei requisiti."
)<tab:riepilogo-requisiti>