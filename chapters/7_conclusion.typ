#import "data/requirements_list.typ": *
#import "../config/variables.typ": *
#pagebreak(to:"odd")

= Conclusioni<cap:conclusioni>
#text(style: "italic", [
    In questo capitolo traggo le conclusioni del lavoro: confronto il piano di lavoro con quanto effettivamente svolto, verifico il grado di raggiungimento degli obiettivi e di copertura dei requisiti, ripercorro i rischi occorsi con le relative mitigazioni e propongo possibili sviluppi futuri.
])
#v(1em)
== Consuntivo finale

Al fine di garantire una maggiore trasparenza e un tracciamento più puntuale delle attività effettivamente svolte, in fase di consuntivazione (@fig:tabella-calcolo-ore) si è scelto di disaggregare due delle macro-fasi originariamente accorpate nel Piano di Lavoro (@fig:tabella-ore-preventivate). Nello specifico, la mappatura tra i due prospetti è la seguente:
#v(1em)
- La voce preventiva *Formazione iniziale e studio del sistema* rimane invariata nel consuntivo.
- La voce preventiva *Analisi requisiti e progettazione* è stata esplosa in due fasi distinte: *Analisi dei requisiti* e *Progettazione del sistema*.
- La voce preventiva *Sviluppo del chatbot e integrazione con il pianificatore* rimane invariata nel consuntivo.
- La voce preventiva *Test funzionali e miglioramento del sistema* è stata esplosa in due fasi distinte: *Test funzionali* e *Miglioramento e ottimizzazione del sistema*.
- La voce preventiva *Documentazione tecnica e revisione finale* rimane invariata nel consuntivo.
#v(1em)

Il monte ore complessivo di 304 ore previsto per lo stage è stato rigorosamente rispettato; tuttavia, la distribuzione effettiva dell'impegno ha subito variazioni fisiologiche rispetto a quanto preventivato nel Piano di Lavoro iniziale. 

Come si evince dal confronto tra la @fig:tabella-ore-preventivate e la @fig:tabella-calcolo-ore, lo scostamento principale ha riguardato le fasi di sviluppo, test e ottimizzazione del sistema, che hanno richiesto un _effort_ congiunto superiore a quanto inizialmente stimato (212 ore effettive contro le 190 preventivate). Questa dilatazione dei tempi è direttamente imputabile alle sfide architetturali e inferenziali emerse in corso d'opera con il modello a 9 miliardi di parametri. 

Come analizzato nel sesto capitolo, la marcata tendenza del modello ad allucinare formati e valori durante la generazione di output JSON ha costretto ad abbandonare tale approccio in favore di una strategia basata su _tool-calling_ reattivo. Questa transizione ha comportato lo sviluppo imprevisto di tool compositi e di un _plugin_ di registrazione dedicato. Di conseguenza, la successiva fase di test è risultata più onerosa, concentrandosi in larga misura sulla profonda e iterativa ottimizzazione del _System Prompt_, operazione rivelatasi indispensabile per portare l'accuratezza delle risposte al 90%.

Di contro, una fase di formazione iniziale più snella e una stesura della documentazione tecnica più rapida del previsto hanno permesso di compensare l'assorbimento orario dello sviluppo, consentendo di chiudere il progetto esattamente nel tetto delle 304 ore stabilite.

#v(1em)
#set table(
  align: (center+horizon, center+horizon), 
)

#figure(
  caption: [Monte ore preventivato nel Piano di Lavoro.],
  table(
    columns: 2,
    table.header([*Fase Preventivata*], [*Ore*]),
    [Formazione iniziale e studio del sistema], [30],
    [Analisi requisiti e progettazione], [44],
    [Sviluppo del _chatbot_ e integrazione con il pianificatore], [140],
    [Test funzionali e miglioramento del sistema], [50],
    [Documentazione tecnica e revisione finale], [40],
    [*Totale*], [*304*]
  )
)<fig:tabella-ore-preventivate>

#v(2em)

#figure(
  caption: [Consuntivo orario effettivo a fine progetto.],
  table(
    columns: 2,
    table.header([*Fase Effettiva*], [*Ore*]),
    [Formazione iniziale e studio del sistema], [24],
    [Analisi dei requisiti], [16],
    [Progettazione del sistema], [28],
    [Sviluppo del _chatbot_ e integrazione con il pianificatore], [150],
    [Test funzionali], [22],
    [Miglioramento e ottimizzazione del sistema], [40],
    [Documentazione tecnica e revisione finale], [24],
    [*Totale*], [*304*]
  )
)<fig:tabella-calcolo-ore>
#v(1em)

== Raggiungimento degli obiettivi

Con riferimento agli obiettivi prefissati in fase di avvio e formalizzati nel Piano di Lavoro, è possibile confermare il pieno soddisfacimento di tutti i traguardi obbligatori e il conseguimento parziale dell'obiettivo facoltativo. Occorre precisare che tali traguardi definiscono le finalità formative e macro-architetturali del progetto nel suo complesso, distinguendosi pertanto dai requisiti software di dettaglio analizzati nella @cap:analisi.

La @fig:tabella-obiettivi riassume lo stato di completamento per ciascun obiettivo identificato.

#v(1em)
#figure(
  caption: [Riepilogo del raggiungimento degli obiettivi di progetto.],
  table(
    columns: (auto, 1fr, auto),
    table.header([*Codice*], [*Obiettivo*], [*Esito*]),
    [O01], [Comprendere parte dell'architettura del gestionale Agilis], [Soddisfatto],
    [O02], [Progettare e sviluppare un server MCP funzionante], [Soddisfatto],
    [O03], [Implementare la comunicazione con il sistema LLM], [Soddisfatto],
    [O04], [Realizzare funzionalità di accesso ai dati del gestionale], [Soddisfatto],
    [O05], [Documentare il sistema sviluppato], [Soddisfatto],
    [O06], [Implementare logiche di analisi dei dati e suggerimento di azioni], [SSoddisfattoì],
    [O07], [Strutturare il codice secondo buone pratiche di sviluppo], [Soddisfatto],
    [F01], [Estendere il sistema a nuovi casi d'uso applicativi], [Soddisfatto parzialmente]
  )
)<fig:tabella-obiettivi>
#v(1em)

Sul piano implementativo, gli obiettivi legati alla comprensione dell'infrastruttura (*O01*) e all'accesso ai dati (*O04*) si sono tradotti nella proficua integrazione con il modulo `XSPMPRIS` e nello sviluppo del nuovo strato di API REST all'interno di Symposium. Parallelamente, l'esigenza di stabilire un canale di comunicazione sicuro e isolato con il modello linguistico (*O03*) è stata soddisfatta attraverso la realizzazione del server Model Context Protocol (*O02*) e l'adozione del framework Microsoft Semantic Kernel come motore di orchestrazione. 

Il requisito relativo all'implementazione di logiche di supporto decisionale (*O06*) è stato assolto delegando le criticità deterministiche al software circostante: l'impiego di tool ad alta granularità e il meccanismo transazionale di anteprima in memoria prevengono infatti alla radice l'insorgenza di conflitti e allucinazioni in fase di pianificazione. Inoltre, l'intero ciclo di vita del software è stato guidato da rigorosi principi architetturali (*O07*), impiegando design pattern consolidati (quali _Adapter_, _Memento_, _Decorator_ e _Chain of Responsibility_) per disaccoppiare nativamente i nuovi moduli dalla base di codice _legacy_; il percorso analitico e progettuale è stato infine documentato in dettaglio all'interno di un elaborato lasciato a disposizione dell'azienda per un possibile futuro sviluppo. (*O05*).

L'unico traguardo considerato raggiunto in maniera "Parziale" è l'estensione del sistema a nuovi casi d'uso (*F01*). Come anticipato nel sesto capitolo, l'infrastruttura di back-end necessaria per estendere l'operatività del chatbot ad altre aree del gestionale (ad esempio ordini, fatturazione o anagrafica clienti) è stata interamente predisposta, pubblicando i relativi _endpoint_ in Symposium. Tuttavia, i limiti cognitivi e la sensibilità al rumore informativo del modello quantizzato a 9 miliardi di parametri hanno sconsigliato l'inclusione massiva di tali strumenti all'interno del _System Prompt_ nell'attuale iterazione del prototipo. La piena applicazione di questo traguardo è pertanto rimandata a un futuro potenziamento dell'infrastruttura hardware, che renderà sostenibile l'esecuzione in produzione del più robusto e flessibile modello da 27B.

== Requisiti soddisfatti
La @tab:requisiti-soddisfatti riassume il grado di copertura dei requisiti al termine del progetto. Tutti i *25 requisiti mandatory* --- 17 funzionali, 4 qualitativi e 4 di vincolo — sono stati integralmente soddisfatti, a conferma che il nucleo irrinunciabile del sistema è stato realizzato in ogni sua parte.
#v(1em)
Sul fronte funzionale, il bilancio dei requisiti *desirable* è parziale (7 su 11). Sono soddisfatti l'anteprima non distruttiva nel pianificatore con _rollback_ via pattern _Memento_ (`XspmprisChangesetApplier`, `FDR4`), la visualizzazione dell'elenco delle operazioni previste (`FDR5`), l'accettazione o il rifiuto selettivo delle singole operazioni prima dell'applicazione (`FDR6`), l'annullamento dell'anteprima con ripristino dello stato precedente (`FDR7`), e i due requisiti di trasparenza: il canale di _thinking_ che espone il ragionamento in tempo reale (`FDR9`) e il `ToolCaptureFilter` che registra nome, parametri ed esito di ogni strumento invocato (`FDR10`). È inoltre soddisfatta l'interruzione dell'elaborazione in corso (`FDR11`), realizzata tramite cancellazione cooperativa end-to-end: `ChatbotPanelViewModel.Annulla()` invia un messaggio `kind="cancel"` sulla _pipe_, il `PipeServer` cancella il `CancellationTokenSource` del turno corrente, e `StreamTurnAsync` propaga l'`OperationCanceledException` producendo l'evento "Turno annullato".
#v(1em)
Quattro requisiti *desirable* non sono stati soddisfatti nell'attuale iterazione del prototipo. `FDR1` (estrazione dei contenuti dagli allegati incorporati nelle email) non è implementato: il `MsgAttachmentExtractor` elenca i nomi degli allegati ma non ne estrae il contenuto testuale, limitandosi a includere il corpo dell'email e i nomi dei file allegati nel contesto del modello. `FDR2` (generazione di più alternative di pianificazione) e `FDR3` (confronto e selezione tra alternative) non sono soddisfatti perché il `PianificaPlugin` produce esattamente una proposta per turno: il metodo `ProposteCapturePlugin.Imposta()` rimpiazza la lista anziché accodare, e il costruttore della risposta in `PianificaPlugin` crea una singola `AlternativaPayload`. Senza alternative multiple, anche la selezione (`FDR3`) è degenere: l'operatore può solo accettare o rifiutare l'unica proposta generata, al massimo scegliendo quali operazioni applicare. `FDR8` (simulazione degli effetti di modifiche ipotetiche alla pianificazione) non è stato implementato. La ragione è architetturale, non omissiva: la strategia anti-allucinazione (@sez:strategia-anti-allucinazione) affida ogni operazione di pianificazione al tool deterministico `pianifica_e_proponi`, che produce *sempre* un _changeset_ reale, convalidato contro i conflitti in agenda e pronto per l'anteprima. Non esiste un tool separato per scenari ipotetici, né il _plugin_ di proposta supporta una modalità "sola analisi". Questa scelta è coerente con il principio per cui l'LLM non deve mai ragionare su dati che non siano stati verificati dal software deterministico: una simulazione senza effetti sarebbe un ragionamento puramente statistico del modello, esposto al rischio di allucinazioni che l'architettura mira a prevenire.
#v(1em)
I due requisiti funzionali *optional* --- `FOR1` e `FOR2`, relativi all'apertura dell'agenda di una risorsa tramite comando in chat e alla relativa disambiguazione --- non sono stati implementati. L'infrastruttura di base (invocazione di programmi Agilis via _named pipe_) è predisposta, ma il caso d'uso specifico di apertura dell'agenda non è stato attivato nell'attuale iterazione del prototipo.
#v(1em)
Sul fronte qualitativo, tutti e quattro i requisiti *mandatory* e due dei tre *desirable* sono soddisfatti. L'unico requisito qualitativo non coperto è `QDR2`, che prescrive la distinguibilità visiva degli appuntamenti proposti dal _chatbot_ rispetto a quelli già presenti nel pianificatore. La proprietà `IsProposedByChatbot` esiste come flag dati sulla classe `TimelineItem` ed è correttamente impostata dal `XspmprisChangesetApplier` durante l'anteprima, ma non è agganciata ad alcun converter XAML o stile grafico: il `AppointmentItemBorderConverter`, unico converter che agisce sull'aspetto degli appuntamenti nello _scheduler_, verifica esclusivamente la proprietà `DataVincolata`. L'effetto visivo dell'anteprima è limitato alla comparsa e scomparsa degli elementi creati o eliminati; gli appuntamenti modificati non presentano alcuna differenziazione cromatica o grafica rispetto a quelli non toccati dalla proposta.
#v(1em)
Tutti e 4 i *constraint* sono pienamente rispettati: lo sviluppo in .NET (`CMR1`) è attestato dai progetti .NET 10 di client e server MCP e dal progetto Visual Basic .NET del modulo `XSPMPRIS.Chatbot`; l'integrazione con Symposium (`CMR2`) è realizzata dal _plugin_ REST `OmegaGruppo.Plugins.MCP`; il divieto di modifiche autonome alla pianificazione (`CMR3`) è garantito dal modello ad anteprima e conferma, in cui l'AI propone un _changeset_ applicato solo in memoria e l'operatore dispone il salvataggio; l'architettura modulare (`CMR4`) è conseguita tramite l'isolamento in tre processi separati, l'uso di interfacce per disaccoppiare il pannello _chatbot_ dal _ViewModel_ dello _scheduler_, e la catena di filtri (`MaxToolRoundsFilter`, `ToolCaptureFilter`, `SymposiumAuthRefreshFilter`) per le responsabilità trasversali.
#v(1em)
Complessivamente, il sistema copre *34 requisiti su 41* individuati in fase di analisi, con una copertura completa dei mandatory e un tasso di soddisfacimento dei desirable pari al 64%.
#v(1em)
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto, auto),
    table.header([*Tipo*], [*Mandatory*], [*Desirable*],[*Optional*], [*Somma*]),
    [Functional], [17/#getFR(getLen: true).at(0)], [7/#getFR(getLen: true).at(1)], [0/#getFR(getLen: true).at(2)], [24/#getFR(getLen: true).sum()],
    [Qualitative], [4/#getQR(getLen: true).at(0)], [2/#getQR(getLen: true).at(1)], [0/#getQR(getLen: true).at(2)], [6/#getQR(getLen: true).sum()],
    [Constraint], [4/#getCR(getLen: true).at(0)], [0/#getCR(getLen: true).at(1)], [0/#getCR(getLen: true).at(2)], [4/#getCR(getLen: true).sum()],
    [*Totale*],
      [*25/#{getFR(getLen: true).at(0)+getQR(getLen: true).at(0)+getCR(getLen: true).at(0)}*],
      [*9/#{getFR(getLen: true).at(1)+getQR(getLen: true).at(1)+getCR(getLen: true).at(1)}*],
      [*0/#{getFR(getLen: true).at(2)+getQR(getLen: true).at(2)+getCR(getLen: true).at(2)}*],
      [*34/#{getFR(getLen: true).sum()+getQR(getLen: true).sum()+getCR(getLen: true).sum()}*],
    align: (center+horizon)
  ),
  caption: "Riepilogo dei requisiti soddisfatti."
)<tab:requisiti-soddisfatti>
== Rischi occorsi e mitigati
I rischi emersi durante lo stage sono riportati in @fig:rischi-occorsi.\
#v(1em)
#figure(
  caption: [Rischi occorsi con la loro mitigazione.],
  table(
    columns: 2,
    table.header([*Descrizione*],[*Mitigazione*]),
    [*R1* -- Complessità architettura _legacy_ di Agilis e difficoltà di orientamento nel dominio applicativo.],[Confronti periodici con i colleghi per approfondire i flussi logici e il patrimonio informativo aziendale.],
    [*R2* -- Difficoltà di apprendimento nell'implementazione delle nuove tecnologie (MCP, Semantic Kernel, .NET 10).],[Supporto del tutor, ricerca documentale autonoma e utilizzo mirato dell'IA per l'analisi dei punti critici.],
    [*R3* -- Imprevisti medici e difficoltà logistiche negli spostamenti verso la sede aziendale.],[Rimodulazione delle presenze in accordo con l'azienda e attivazione dello smart working parziale per rispettare le scadenze.]
  )
)<fig:rischi-occorsi>
#v(1em)

== Sviluppi futuri e messa in produzione
Il lavoro svolto ha dimostrato l'efficacia di un'architettura ad agenti integrata nel gestionale Agilis.
Grazie all'ottimizzazione estrema dei tool e del contesto, il sistema riesce a operare con un modello quantizzato a 9 miliardi di parametri mantenendo un tasso di allucinazioni estremamente contenuto. Tuttavia, permane un margine fisiologico di errore intrinseco alla taglia del modello.
Il principale sviluppo futuro in vista di un rilascio in produzione consiste nell'adeguamento dell'infrastruttura hardware (Nodo B), al fine di ospitare definitivamente il modello Qwen 3.6 a 27 miliardi di parametri, il quale, a seguito delle ottimizzazioni, ha offerto un'accuratezza totale del 100% nelle prove svolte.

Un ulteriore sviluppo previsto è l'applicazione di questo assistente anche in altre pagine del gestionale Agilis, come ad esempio quelle relative agli ordini o ai rapporti con i clienti. A tal fine, su precisa indicazione del tutor aziendale in previsione di espansioni future, sono già stati sviluppati all'interno di Symposium numerosi _endpoint_ dedicati, che attualmente giacciono inutilizzati nell'architettura.

La limitazione attuale all'implementazione di queste nuove funzionalità è data dal fatto che il modello da 9B non è in grado di destreggiarsi agilmente con un numero così elevato di strumenti. Come emerso durante i test, affinché il modello interpreti 
correttamente i tool, necessita di istruzioni precise e dettagliate all'interno del _System Prompt_. L'aggiunta di nuovi strumenti renderebbe la dimensione del prompt troppo grande, impedendo a un modello di piccola taglia di muoversi e rispondere in maniera rapida e corretta. L'adozione del modello da 27B risulta pertanto la condizione tecnica necessaria non solo per garantire l'affidabilità, ma anche per permettere l'espansione operativa del sistema.

== Valutazione personale

L'attività di stage si è rivelata estremamente formativa per la mia crescita personale e professionale, consentendomi di acquisire competenze in ambiti che il percorso accademico aveva solo parzialmente toccato, come l'ingegneria dei sistemi a linguaggio naturale, l'orchestrazione di agenti AI e l'integrazione di protocolli emergenti in contesti enterprise consolidati.

L'approfondimento del Model Context Protocol e del framework Semantic Kernel ha rappresentato una sfida stimolante: ho dovuto confrontarmi con tecnologie di frontiera in un ecosistema .NET caratterizzato da una forte eterogeneità di runtime (.NET Framework 4.8 _legacy_ e .NET 10 moderno), imparando a gestire il disaccoppiamento architetturale attraverso processi isolati e canali di comunicazione inter-processo. La necessità di progettare un sistema robusto nonostante i vincoli imposti da un gestionale maturo, con il suo patrimonio informativo storicizzato e le sue logiche di business consolidate, mi ha insegnato l'importanza di un approccio pragmatico che bilanci innovazione e stabilità operativa.

Particolarmente significativa è stata la progettazione delle strategie anti-allucinazione: spostare la complessità deterministica dall'LLM al software circostante, attraverso tool ad alta granularità e validatori esterni, ha trasformato il mio modo di intendere il ruolo dell'intelligenza artificiale in un sistema produttivo. Non più un oracolo da interrogare, ma un agente specializzato le cui decisioni sono guidate e verificate da strati software deterministici, in un modello di interazione in cui l'AI propone e l'operatore dispone. Questa visione ha richiesto un'attenzione meticolosa alla progettazione delle interfacce e alla gestione degli stati, affinché la trasparenza del ragionamento e la tracciabilità degli strumenti invocati fossero sempre accessibili all'utente finale.

La collaborazione con il team aziendale e il tutor Marco Ortali è stata parte integrante del percorso: il confronto continuo sulle scelte architetturali - dalla separazione dei processi alla gestione del ciclo di vita del _token_, dalla limitazione del contesto alla viewport alla validazione esterna delle proposte - mi ha permesso di comprendere come le decisioni tecniche siano sempre il frutto di compromessi tra esigenze funzionali, vincoli infrastrutturali e requisiti di sicurezza. L'azienda mi ha concesso ampia autonomia organizzativa e libertà di sperimentazione, pur fornendo un supporto costante e puntuale, elemento che ha reso l'esperienza particolarmente arricchente.

Il progetto rappresenta per me un ponte tra la teoria accademica e la pratica professionale: ho potuto applicare nozioni di progettazione software, pattern architetturali e gestione della sicurezza a un caso d'uso concreto, con ripercussioni operative in un ambiente di produzione reale. L'approccio alla mitigazione delle allucinazioni tramite delega deterministica e il modello di anteprima-conferma per la pianificazione sono esempi di come si possano coniugare le potenzialità dell'AI con l'affidabilità richiesta da un gestionale aziendale.

Quanto appreso --- dal funzionamento interno dei modelli linguistici alle tecniche di orchestrazione, dalla gestione dei _token_ di autenticazione alla normalizzazione dello streaming --- costituisce una solida base per il mio futuro professionale, in un settore, l'_AI engineering_, in rapidissima evoluzione e di grande interesse per possibili sviluppi accademici e lavorativi. Questa esperienza ha affinato il mio metodo di studio e la mia capacità di affrontare progetti complessi, rafforzando in me la consapevolezza che la vera innovazione sta spesso nel saper integrare tecnologie nuove in contesti consolidati, con un'attenzione costante alla sicurezza, all'affidabilità e all'esperienza dell'utente finale.