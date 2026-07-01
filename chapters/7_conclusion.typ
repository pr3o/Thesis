#import "data/requirements_list.typ": *
#import "../config/variables.typ": *
#pagebreak(to:"odd")

= Conclusioni<cap:conclusioni>
#text(style: "italic", [
    In questo capitolo traggo le conclusioni del lavoro: confronto il piano di lavoro con quanto effettivamente svolto, verifico il grado di raggiungimento degli obiettivi e di copertura dei requisiti, ripercorro i rischi occorsi con le relative mitigazioni e propongo possibili sviluppi futuri.
])
#v(1em)
== Consuntivo finale
Una volta terminato il progetto ho redatto il consuntivo orario finale nella @fig:tabella-calcolo-ore che suddivide in maniera approssimata le ore dedicate alle varie fasi.
#v(1em)
#set table(
  align: (center+horizon, center+horizon), 
)
#figure(
  caption: [Consuntivo orario finale.],
  table(
    columns: 2,
    table.header([*Fase*], [*Ore*]),
    [Formazione inziale e studio del sistema],[24],
    [Analisi dei requisiti],[16],
    [Progettazione del sistema], [28],
    [Sviluppo del _chatbot_ e integrazione con il pianificatore], [150],
    [Test funzionali], [22],
    [Miglioramento e ottimizzazione del sistema], [40],
    [Documentazione tecnica e revisione finale], [24],
    [*Totale*],[304]
  )
)<fig:tabella-calcolo-ore>
#v(1em)

== Raggiungimento degli obiettivi

== Requisiti soddisfatti
Arrivato alla fine del progetto ho implementato...
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
    [*R1* -- Complessità architettura legacy di Agilis e difficoltà di orientamento nel dominio applicativo.],[Confronti periodici con i colleghi per approfondire i flussi logici e il patrimonio informativo aziendale.],
    [*R2* -- Difficoltà di apprendimento nell'implementazione delle nuove tecnologie (MCP, Semantic Kernel, .NET 10).],[Supporto del tutor, ricerca documentale autonoma e utilizzo mirato dell'IA per l'analisi dei punti critici.],
    [*R3* -- Imprevisti medici e difficoltà logistiche negli spostamenti verso la sede aziendale.],[Rimodulazione delle presenze in accordo con l'azienda e attivazione dello smart working parziale per rispettare le scadenze.]
  )
)<fig:rischi-occorsi>
#v(1em)

== Sviluppi futuri e messa in produzione
Il lavoro svolto ha dimostrato l'efficacia di un'architettura ad agenti integrata nel gestionale Agilis.
Grazie all'ottimizzazione estrema dei _tool_ e del contesto, il sistema riesce a operare con un modello quantizzato a 9 miliardi di parametri mantenendo un tasso di allucinazioni estremamente contenuto. Tuttavia, permane un margine fisiologico di errore intrinseco alla taglia del modello. Il principale sviluppo futuro in vista di un rilascio in produzione consiste nell'adeguamento dell'infrastruttura hardware (Nodo B), al fine di ospitare definitivamente il modello Qwen 3.6 a 27 miliardi di parametri, che nelle prove svolte ha offerto l'aderenza ai dati più solida e costante rispetto alla variante 9B (cfr. `QMR1`).
== Valutazione personale
