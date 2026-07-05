#import "../config/thesis-config.typ": glpl, gl
#import "data/requirements_list.typ": *
#import "data/patterns_decisions.typ": *

#pagebreak(to:"odd")
= Requisiti completi e decisioni di progetto<cap:A-appendice>

#text(style: "italic", [
    Questa appendice raccoglie il materiale di dettaglio richiamato dai capitoli 3 e 5 e tenuto fuori dal corpo per non appesantirlo, come indicato dal relatore.
])
#v(1em)

== Lista delle user stories<cap:lista-user-stories>
#[
#set heading(
  numbering: (..numbers) => {
    let level = numbers.pos().len()
    if (level == 4) {
      return numbering("US1", numbers.pos().at(level - 1))
    }
  }
)
#set heading(supplement: none)
#let d = [*Descrizione: *]
#let ac = [#v(0.5em) *Acceptance criteria: *]

#heading(numbering: none, level: 3)[Epic 1. Gestione del contesto]
==== Allegare un file di specifica task<us:file>
#d Come operatore del reparto _Delivery_, voglio poter allegare un file contenente le informazioni dei task da pianificare, in modo da fornire al chatbot il contesto necessario per elaborare proposte di pianificazione.\
#ac
1. L'operatore può selezionare un file tramite la funzionalità di aggiunta allegato.
2. In alternativa, l'operatore può trascinare il file nell'area dedicata alla chat.
3. Il file viene aggiunto correttamente al contesto a disposizione del modello.

==== Allegare una conversazione Outlook<us:outlook>
#d Come operatore del reparto _Delivery_, voglio poter allegare una conversazione email proveniente da Outlook, in modo da includere nel contesto del chatbot le informazioni contenute nella conversazione e nei relativi allegati.
#ac
1. L'operatore può trascinare la conversazione Outlook nell'area dedicata alla chat.
2. La conversazione e gli eventuali allegati vengono aggiunti correttamente al contesto del modello.

#heading(numbering: none, level: 3)[Epic 2. Pianificazione dei task]
==== Interrogare le informazioni a schermo<us:onscreen-info>
#d Come operatore del reparto _Delivery_, voglio poter porre domande al chatbot riguardo alle informazioni attualmente visualizzate nel pianificatore, in modo da ottenere chiarimenti o analisi senza dover navigare manualmente tra i dati.\
#ac
1. L'operatore può inserire in chat una domanda relativa ai task o agli appuntamenti visibili a schermo.
2. Il chatbot risponde in modo coerente con le informazioni visualizzate.

==== Specificare la priorità dei task<us:task-priority>
#d Come operatore del reparto _Delivery_, voglio poter indicare esplicitamente il livello di priorità dei task da pianificare, in modo da orientare il chatbot verso proposte che rispettino l'ordine di importanza da me definito.\
#ac
1. L'operatore può specificare le priorità dei task tramite testo nel messaggio oppure tramite file allegato.
2. Le informazioni di priorità vengono incluse nel contesto del modello e considerate nella generazione delle proposte.

==== Indicare la strategia di pianificazione<us:strategy>
#d Come operatore del reparto _Delivery_, voglio poter specificare la strategia da adottare nella pianificazione dei task, in modo da ottenere proposte allineate alle esigenze operative del momento.\
#ac
1. L'operatore può descrivere nel prompt la strategia di pianificazione desiderata.
2. La strategia viene inclusa nel contesto del modello e applicata nella generazione delle proposte.

==== Richiedere la pianificazione dei task<us:pianification>
#d Come operatore del reparto _Delivery_, voglio poter richiedere al chatbot una proposta di pianificazione per i task forniti, in modo da ricevere suggerimenti di allocazione temporale senza doverli elaborare manualmente.\
#ac
1. L'operatore può fornire i task tramite file allegato o descrizione testuale nel messaggio.
2. L'operatore può opzionalmente specificare priorità e strategia di pianificazione.
3. Il chatbot genera e visualizza in chat una o più proposte di pianificazione.

==== Affinare una proposta di pianificazione<us:affine>
#d Come operatore del reparto _Delivery_, voglio poter richiedere al chatbot di affinare una proposta già generata fornendo indicazioni aggiuntive, in modo da ottenere una soluzione più aderente alle mie esigenze specifiche.\
#ac
1. L'operatore può inserire nel prompt indicazioni correttive o preferenze aggiuntive rispetto a una proposta precedente.
2. Il chatbot genera una nuova proposta tenendo conto delle indicazioni fornite.

==== Approvare e inserire la pianificazione proposta<us:approve>
#d Come operatore del reparto _Delivery_, voglio poter approvare una proposta di pianificazione generata dal chatbot e inserirla direttamente nel gestionale, in modo da evitare l'inserimento manuale degli appuntamenti.\
#ac
1. L'operatore può selezionare la funzionalità di inserimento appuntamenti a partire da una proposta approvata.
2. Gli appuntamenti vengono creati correttamente nel gestionale e nel database.

==== Confrontare le alternative proposte<us:compare>
#d Come operatore del reparto _Delivery_, voglio poter confrontare le diverse alternative di pianificazione generate dal chatbot, in modo da scegliere quella più adatta alle mie esigenze.\
#ac
1. Il chatbot presenta le alternative come elementi distinti e selezionabili, ciascuno con i relativi punti di forza e compromessi.
2. L'operatore può selezionare un'alternativa per visualizzarne nel dettaglio le operazioni previste.

==== Visualizzare l'anteprima di una proposta nel pianificatore<us:preview>
#d Come operatore del reparto _Delivery_, voglio poter visualizzare l'anteprima di una proposta direttamente nel pianificatore prima di confermarla, in modo da valutarne l'effetto sull'agenda.\
#ac
1. Selezionando una proposta, le operazioni vengono mostrate in anteprima nel pianificatore *senza* essere salvate nel gestionale.
2. Gli appuntamenti coinvolti sono distinguibili visivamente come proposti dal chatbot.

==== Accettare o escludere singole operazioni di una proposta<us:accept-reject>
#d Come operatore del reparto _Delivery_, voglio poter accettare o escludere le singole operazioni che compongono una proposta, in modo da applicare solo le modifiche che ritengo corrette.\
#ac
1. L'operatore può visualizzare l'elenco delle operazioni della proposta (creazioni, spostamenti, eliminazioni).
2. L'operatore può accettare o rifiutare ciascuna operazione individualmente prima dell'applicazione.

==== Annullare l'anteprima di una proposta<us:cancel-preview>
#d Come operatore del reparto _Delivery_, voglio poter annullare l'anteprima di una proposta applicata al pianificatore, in modo da ripristinare lo stato precedente senza conseguenze.\
#ac
1. L'operatore può annullare un'anteprima attiva.
2. Il pianificatore ripristina lo stato esistente prima dell'applicazione dell'anteprima.

#heading(numbering: none, level: 3)[Epic 3. Creazione guidata degli appuntamenti]
==== Creare un appuntamento in modo guidato<us:guided-creation>
#d Come operatore del reparto _Delivery_, voglio poter richiedere al chatbot la creazione di un nuovo appuntamento fornendo le informazioni necessarie in linguaggio naturale, in modo da velocizzare l'inserimento senza dover compilare manualmente i campi del gestionale.\
#ac
1. L'operatore può descrivere in chat l'appuntamento da creare, specificando le informazioni rilevanti.
2. Il sistema inserisce l'appuntamento nel gestionale e nel database.
3. In caso di conflitto (cliente già impegnato o risorsa non disponibile), il sistema notifica l'operatore.
4. L'operatore può scegliere se procedere comunque, modificare le informazioni o annullare l'operazione.

#heading(numbering: none, level: 3)[Epic 4. Riorganizzazione delle agende]
==== Richiedere la riorganizzazione delle agende<us:reorganize>
#d Come operatore del reparto _Delivery_, voglio poter segnalare al chatbot il verificarsi di un evento imprevisto e richiedere una proposta di riorganizzazione degli appuntamenti, in modo da adattare rapidamente la pianificazione alla nuova situazione.\
#ac
1. L'operatore può descrivere in chat l'evento imprevisto (risorsa indisponibile, attività urgente, modifica della durata di un task).
2. Il chatbot genera e visualizza in chat una o più proposte di riorganizzazione degli appuntamenti.

==== Simulare scenari di riorganizzazione<us:simulate>
#d Come operatore del reparto _Delivery_, voglio poter richiedere al chatbot di valutare l'effetto di modifiche alla pianificazione, in modo di farmi un'idea delle conseguenze prima di applicarle.\
#ac
1. L'operatore può descrivere in chat una o più modifiche ipotetiche alla pianificazione.
2. Il chatbot illustra l'effetto delle modifiche sulla pianificazione corrente e segnala le eventuali criticità che rileva (ad esempio sovrapposizioni o vincoli temporali a rischio).

==== Approvare ed eseguire la riorganizzazione<us:approve-reorg>
#d Come operatore del reparto _Delivery_, voglio poter approvare una proposta di riorganizzazione delle agende e applicarla al gestionale, in modo da rendere effettive le modifiche senza doverle inserire manualmente.\
#ac
1. L'operatore può selezionare la funzionalità di modifica delle agende a partire da una proposta di riorganizzazione approvata.
2. Gli appuntamenti vengono aggiornati correttamente nel gestionale e nel database.

==== Ricevere notifica di conflitto non risolvibile<us:conflict-notify>
#d Come operatore del reparto _Delivery_, voglio essere notificato dal chatbot quando viene rilevato un conflitto che non può essere risolto automaticamente, in modo da poter intervenire manualmente con le informazioni necessarie.\
#ac
1. Quando il chatbot rileva un conflitto non risolvibile, visualizza in chat un avviso esplicito.
2. L'avviso descrive la natura del conflitto in modo comprensibile, permettendo all'operatore di prendere una decisione informata.

#heading(numbering: none, level: 3)[Epic 5. Informazioni e supporto generale]
==== Richiedere informazioni generiche<us:generic-info>
#d Come operatore del reparto _Delivery_, voglio poter richiedere al chatbot informazioni su risorse, task, appuntamenti e competenze, in modo da accedere rapidamente ai dati di cui ho bisogno senza dover navigare manualmente nel gestionale.\
#ac
1. L'operatore può inserire in chat una domanda relativa a risorse, task, appuntamenti o competenze.
2. Il chatbot recupera e visualizza in chat le informazioni richieste in modo accurato e tempestivo.

==== Aprire l'agenda di una risorsa <us:open-agenda>
#d Come operatore del reparto _Delivery_, voglio poter chiedere al chatbot di aprire l'agenda di una specifica risorsa, in modo da visualizzarne direttamente la pianificazione nel gestionale senza doverla cercare manualmente.
#ac
1. L'operatore può richiedere in chat l'apertura dell'agenda indicando la risorsa di interesse.
2. Il sistema apre nel gestionale la sezione corrispondente all'agenda della risorsa indicata.
3. Qualora la risorsa non sia identificabile univocamente, il chatbot richiede una disambiguazione prima di procedere.

#heading(numbering: none, level: 3)[Epic 6. Interazione e trasparenza]
==== Comprendere il ragionamento e le fonti del chatbot<us:explainability>
#d Come operatore del reparto _Delivery_, voglio poter visualizzare il ragionamento seguito dal chatbot e gli strumenti che ha consultato, in modo da comprendere e fidarmi delle proposte generate.\
#ac
1. Il chatbot mostra, in un canale dedicato, il proprio ragionamento durante l'elaborazione.
2. Il chatbot indica quali strumenti ha invocato e con quali parametri, rendendo tracciabile la provenienza dei dati.

==== Interrompere l'elaborazione in corso<us:interrupt>
#d Come operatore del reparto _Delivery_, voglio poter interrompere un'elaborazione del chatbot già avviata, in modo da non dover attendere una risposta non più necessaria.\
#ac
1. Durante l'elaborazione l'operatore può richiedere l'annullamento del turno.
2. Il sistema interrompe la generazione e torna disponibile per una nuova richiesta.

==== Avviare una nuova conversazione<us:new-conversation>
#d Come operatore del reparto _Delivery_, voglio poter azzerare la conversazione corrente, in modo da iniziare una nuova richiesta senza l'influenza del contesto precedente.\
#ac
1. L'operatore può avviare una nuova conversazione.
2. Il contesto conversazionale precedente viene azzerato.

==== Porre domande di _follow-up_ mantenendo il contesto<us:follow-up>
#d Come operatore del reparto _Delivery_, voglio poter porre domande di _follow-up_ mantenendo il contesto della conversazione, in modo da affinare richieste o proposte senza ripetere le informazioni già fornite.\
#ac
1. Il chatbot mantiene memoria dei messaggi e delle proposte precedenti nella stessa conversazione.
2. Le risposte successive tengono conto del contesto già stabilito.
]

== Tracciamento dei requisiti
Ad ogni requisito è associato un codice costruito in base alle sue caratteristiche:
#v(1em)
#align(center)[*(F/Q/C)(M/D/O)R*]
#v(1em)
#[
#set list(marker: none)
- F (_Functional_): definisce una funzione di un sistema o dei suoi componenti;
- Q (_Qualitative_): rappresentano come il sistema deve essere per soddisfare i requisiti dello stakeholder;
- C (_Constraint_): rappresentano dei vincoli o dei limiti che il sistema deve rispettare;
#v(0.5em)
- M (_Mandatory_): irrinunciabili per qualcuno degli stakeholder;
- D (_Desirable_): non strettamente necessari ma a valore aggiunto riconoscibile;
- O (_Optional_): relativamente utili oppure contrattabili anche in fasi avanzate del progetto;
#v(0.3em)
- R (_Requirement_): requisito
#v(1em)
]
In @tab:requisiti-funzionali, @tab:requisiti-qualitativi e @tab:requisiti-vincolo sono riassunti i requisiti e il loro tracciamento con gli use case delineati in fase di analisi.

La colonna "Fonti" indica da quale artefatto il requisito è stato derivato:

- US (User Story): requisiti funzionali estratti dalle user story raccolte durante l'analisi

- Piano di lavoro: requisiti non funzionali e di qualità definiti nel documento di project management

- Riunione col tutor: vincoli tecnici e architetturali emersi dalle riunioni di supervisione

Un requisito può avere più fonti, indicando che più stakeholder convergevano sulla stessa esigenza.
#[
#show figure: set block(breakable: true)
#set table(
  align: (center+horizon, left+horizon, center+horizon),
  columns: (auto, 5fr, 1.5fr),
)
#v(1em)
#figure(
    table(
        table.header([*Codice*], [*Descrizione*], [*Fonti*]),
        ..getFR().flatten()
    ),
    caption: "Tracciamento dei requisti funzionali.",
)
<tab:requisiti-funzionali>

#v(2em)
#figure(
    table(
      align: (center+horizon, left+horizon, center+horizon),
      table.header([*Codice*], [*Descrizione*], [*Fonti*]),
      ..getQR().flatten()
    ),
    caption: "Tracciamento dei requisti di qualità.",
)
<tab:requisiti-qualitativi>

#v(2em)
#figure(
    table(
      align: (center+horizon, left+horizon, center+horizon),
      table.header([*Codice*], [*Descrizione*], [*Fonti*]),
      ..getCR().flatten()
    ),
    caption: "Tracciamento dei requisti di vincolo.",
)
<tab:requisiti-vincolo>


== Catalogo dei pattern architetturali
#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    align: (center + horizon, left + horizon, left + horizon),
    table.header([*Pattern*], [*Dove*], [*Problema risolto*]),
    ..getPatterns().flatten()
  ),
  caption: [Catalogo dei pattern architetturali.],
)<tab:pattern>

== Decisioni architetturali e trade-off
#figure(
  table(
    columns: (1fr, 1.5fr, 2fr),
    align: (left + horizon, left + horizon, left + horizon),
    table.header([*Decisione*], [*Motivazione*], [*Alternativa scartata*]),
    ..getDecisions().flatten()
  ),
  caption: [Decisioni architetturali e relativi compromessi.],
)<tab:decisioni>
]