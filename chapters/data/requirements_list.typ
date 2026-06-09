// Functional
#let getFR(getLen: bool) = {
  let FR = ()
  let m = "FMR"
  let d = "FDR"
  let o = "FOR"
  let mandatory = 0
  let desirable = 0
  let optional = 0
  
  // US1 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di allegare file contenenti informazioni sui task da pianificare, sia tramite selezione che trascinamento nell'area chat.], [@us:file]))

  // US2 (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di allegare conversazioni Outlook, includendo nel contesto anche gli eventuali allegati.], [@us:outlook]))

  // US3 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di interrogare il chatbot sulle informazioni attualmente visualizzate nel pianificatore.], [@us:onscreen-info]))

  // US4 (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di specificare il livello di priorità dei task, tramite testo o file allegato.], [@us:task-priority]))

  // US5 (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di indicare la strategia di pianificazione da adottare.], [@us:strategy]))

  // US6 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve generare e visualizzare in chat una o più proposte di pianificazione a partire dai task e dai parametri forniti dall'operatore.], [@us:pianification]))

  // US7 (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di affinare una proposta di pianificazione già generata, fornendo indicazioni aggiuntive in linguaggio naturale.], [@us:affine]))

  // US8 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di approvare una proposta di pianificazione e inserire gli appuntamenti risultanti nel gestionale e nel database.], [@us:approve]))

  // US9a (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve presentare le proposte alternative come elementi distinti e selezionabili, ciascuno corredato dei relativi punti di forza e compromessi.], [@us:compare]))

  // US9b (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di selezionare una proposta alternativa per visualizzarne nel dettaglio le operazioni previste.], [@us:compare]))

  // US10 (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve mostrare in anteprima nel pianificatore le operazioni di una proposta selezionata, senza salvarle nel gestionale.], [@us:preview]))

  // US11a (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di visualizzare l'elenco delle operazioni che compongono una proposta (creazioni, spostamenti, eliminazioni).], [@us:accept-reject]))

  // US11b (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di accettare o escludere individualmente le singole operazioni di una proposta prima della loro applicazione.], [@us:accept-reject]))

  // US12 (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di annullare un'anteprima attiva, ripristinando lo stato del pianificatore precedente alla sua applicazione.], [@us:cancel-preview]))

  // US13a (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve guidare l'operatore nella creazione di un nuovo appuntamento a partire da una descrizione in linguaggio naturale, inserendolo nel gestionale e nel database.], [@us:guided-creation]))

  // US13b (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve notificare l'operatore in caso di conflitto rilevato durante la creazione di un appuntamento.], [@us:guided-creation]))

  // US13c (D)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve consentire all'operatore di scegliere come procedere a fronte di un conflitto in fase di creazione: proseguire, modificare le informazioni o annullare l'operazione.], [@us:guided-creation]))

  // US14 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve generare proposte di riorganizzazione delle agende in seguito alla segnalazione di un evento imprevisto da parte dell'operatore.], [@us:reorganize]))

  // US15 (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve illustrare l'effetto di modifiche ipotetiche alla pianificazione, segnalando le eventuali criticità rilevate (sovrapposizioni o vincoli temporali a rischio).], [@us:simulate]))

  // US16 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di approvare una proposta di riorganizzazione e applicare le modifiche al gestionale e al database.], [@us:approve-reorg]))

  // US17 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve segnalare all'operatore, in linguaggio chiaro e comprensibile, le criticità o i conflitti che non è in grado di risolvere nel rispetto di tutti i vincoli, esponendone la natura per consentire un intervento manuale informato.], [@us:conflict-notify]))

  // US18 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve rispondere a richieste di informazioni generiche riguardanti risorse, task, appuntamenti e competenze.], [@us:generic-info]))

  // US23a (O)
  optional += 1
  FR.push(((o + str(optional)), [Il sistema deve permettere all'operatore di richiedere l'apertura dell'agenda di una specifica risorsa, aprendo nel gestionale la sezione corrispondente.], [@us:open-agenda]))

  // US23b (O)
  optional += 1
  FR.push(((o + str(optional)), [Il sistema deve richiedere una disambiguazione quando la risorsa indicata per l'apertura dell'agenda non è identificabile univocamente.], [@us:open-agenda]))

  // US19a (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve mostrare, in un canale dedicato, il ragionamento seguito durante l'elaborazione.], [@us:explainability]))

  // US19b (D)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve indicare gli strumenti invocati e i relativi parametri, rendendo tracciabile la provenienza dei dati.], [@us:explainability]))

  // US20 (O)
  desirable += 1
  FR.push(((d + str(desirable)), [Il sistema deve permettere all'operatore di interrompere un'elaborazione in corso, tornando disponibile per una nuova richiesta.], [@us:interrupt]))

  // US21 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve permettere all'operatore di avviare una nuova conversazione, azzerando il contesto conversazionale precedente.], [@us:new-conversation]))

  // US22 (M)
  mandatory += 1
  FR.push(((m + str(mandatory)), [Il sistema deve mantenere il contesto della conversazione corrente e tenerne conto nelle risposte successive.], [@us:follow-up]))

  mandatory +=1
  FR.push(((m + str(mandatory)), [Il sistema deve mettere a disposizione del chatbot una base di conoscenza interna (istruzioni operative e FAQ sull'utilizzo del gestionale) consultabile durante l'elaborazione, affinchè possa interpretare correttamente i dati ed eseguire le operazioni richieste.], [Piano di lavoro.]))
  
  if getLen == true {
    return (mandatory, desirable, optional)
  }
  return FR
}

// Qualitative
#let getQR(getLen: bool) = {
  let QR = ()  
  let m = "QMR"
  let d = "QDR"
  let o = "QOR"
  let mandatory = 0
  let desirable = 0
  let optional = 0
  
  mandatory += 1
  QR.push(((m + str(mandatory)), [Le risposte del chatbot devono essere coerenti con il contesto fornito dall'operatore e con le informazioni presenti nel gestionale.], [Piano di lavoro.]))

  mandatory += 1
  QR.push(((m + str(mandatory)), [Il sistema deve notificare l'operatore in modo chiaro e comprensibile in caso di conflitti o situazioni anomale, senza ricorrere a linguaggio tecnico.], [Piano di lavoro.]))

  mandatory += 1
  QR.push(((m + str(mandatory)), [Le operazioni approvate dall'operatore devono essere riportate in modo consistente sia nel gestionale sia nel database.], [@us:approve]))

  mandatory += 1
  QR.push(((m + str(mandatory)), [L'interfaccia del chatbot deve essere integrata nel gestionale Agilis in modo visivamente coerente con lo stile grafico esistente.], [Piano di lavoro.]))

  desirable += 1
  QR.push(((d + str(desirable)), [Il sistema deve rispondere alle richieste dell'operatore in tempi ragionevoli, senza introdurre latenze significative nel flusso di lavoro.], [Piano di lavoro.]))

  desirable += 1
  QR.push(((d + str(desirable)), [Gli appuntamenti mostrati in anteprima devono essere visivamente distinguibili da quelli già presenti nel pianificatore.], [@us:preview]))

  desirable += 1
  QR.push(((d + str(desirable)), [Il sistema deve garantire la tracciabilità delle proprie elaborazioni, rendendo evidente all'operatore l'origine delle informazioni utilizzate.], [@us:explainability]))

  
  if getLen == true {
    return (mandatory, desirable, optional)
  }
  return QR
}

// Constraint
#let getCR(getLen: bool) = {
  let CR = ()  
  let m = "CMR"
  let d = "CDR"
  let o = "COR"
  let mandatory = 0
  let desirable = 0
  let optional = 0
  
  mandatory+=1
  CR.push((
    (m + str(mandatory)), [Il sistema deve essere sviluppato utilizzando il framework .NET, garantendo la piena compatibilità con il gestionale Agilis.],[Riunione col tutor.]
  ))

  mandatory+=1
  CR.push((
    (m + str(mandatory)), [Il sistema deve integrarsi con Symposium per l'esposizione delle API e la consultazione dei dati nel database.],[Riunione col tutor.]
  ))

  mandatory+=1
  CR.push((
    (m + str(mandatory)), [Il chatbot non deve mai eseguire modifiche alla pianificazione in modo autonomo: ogni operazione deve essere esplicitamente approvata dall'operatore.],[Piano di Lavoro.]
  ))

  mandatory+=1
  CR.push((
    (m + str(mandatory)), [Il sistema deve essere sviluppato con un'architettura modulare, facilmente estendibile e manutenibile.],[Riunione col tutor.]
  ))
  
  if getLen == true {
    return (mandatory, desirable, optional)
  }
  return CR
}
