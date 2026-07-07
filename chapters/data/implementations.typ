// Endpoint REST del plugin MCP di Symposium
#let getEndpoints() = {
  let E = ()

  E.push(([GET], [`mcp/Appuntamenti`], [✔], [Appuntamenti del pianificatore (filtri per risorsa, date, stato, conto, lead, commessa, task).]))

  E.push(([GET], [`mcp/Tasks`], [✔], [Task di commessa (competenza, livello, cliente, scadenze, stato evasione).]))

  E.push(([GET], [`mcp/Risorse`], [✔], [Risorse interne con competenze associate.]))

  E.push(([GET], [`mcp/Competenze`], [✔], [Competenze censite, filtrabili per area.]))

  E.push(([GET], [`mcp/Competenze/aree`], [✔], [Macro-aree di competenza.]))

  E.push(([GET], [`mcp/TurniCalendario`], [✔], [Calendario lavorativo aziendale (regole, intervalli orari, validità).]))

  E.push(([GET], [`mcp/Documenti`], [✘], [Testate documenti di magazzino.]))

  E.push(([GET], [`mcp/Documenti/righe`], [✘], [Righe dei documenti.]))

  E.push(([GET], [`mcp/Documenti/analisi/per-cliente`], [✘], [Fatturato per cliente.]))
  
  E.push(([GET], [`mcp/Documenti/analisi/per-articolo`], [✘], [Vendite per articolo.]))

  E.push(([GET], [`mcp/Documenti/analisi/per-agente`], [✘], [Fatturato per agente.]))

  E.push(([GET], [`mcp/Ordini`], [✘], [Testate ordini.]))

  E.push(([GET], [`mcp/Ordini/righe`], [✘], [Righe ordini (con quantità evasa).]))

  E.push(([GET], [`mcp/Ordini/analisi/per-cliente`], [✘], [Analisi ordini per cliente.]))

  E.push(([GET], [`mcp/Ordini/analisi/per-articolo`], [✘], [Analisi ordini per articolo.]))

  E.push(([GET], [`mcp/Offerte`], [✘], [Testate offerte/preventivi.]))

  E.push(([GET], [`mcp/Offerte/righe`], [✘], [Righe offerte.]))

  E.push(([GET], [`mcp/Offerte/analisi/per-agente`], [✘], [Valore offerte per agente.]))
  
  E.push(([GET], [`mcp/Scadenze`], [✘], [Partite aperte/saldate.]))

  E.push(([GET], [`mcp/Scadenze/aperto/per-cliente`], [✘], [Esposizione aperta per cliente.]))

  E.push(([GET], [`mcp/Scadenze/prossime`], [✘], [Scadenze entro _N_ giorni.]))

  E.push(([GET], [`mcp/Anagrafica`], [✘], [Clienti e fornitori (tipo C/F).]))

  E.push(([GET], [`mcp/Leads`], [✘], [Lead/prospect.]))

  E.push(([GET], [`mcp/Articolo`], [✘], [Articoli di magazzino.]))

  E.push(([GET], [`mcp/ProgrammiMenu`], [✘], [Voci di menu del gestionale.]))

  E.push(([POST], [`mcp/CreaDocumento`], [✘], [Creazione documento di magazzino.]))

  E.push(([POST], [`mcp/CreaOfferta`], [✘], [Creazione offerta.]))

  E.push(([POST], [`mcp/CreaOfferta/modifica`], [✘], [Modifica/revisione offerta.]))


  return E
}

// Mappa tool MCP esposti --> fonti di dati
#let getTools() = {
  let T = ()

  T.push((table.cell(colspan: 3, [*Strumenti MCP*]),))

  T.push(([`get_appuntamenti`], [_pass-through_], [`mcp/Appuntamenti`]))

  T.push(([`get_tasks`], [_pass-through_], [`mcp/Tasks`]))

  T.push(([`get_risorse`], [_pass-through_], [`mcp/Risorse`]))

  T.push(([`get_comp`], [_pass-through_], [`mcp/Competenze`]))

  T.push(([`get_ar_co`], [_pass-through_], [`mcp/Competenze/aree`]))

  T.push(([`get_turni_calendario`], [_pass-through_], [`mcp/TurniCalendario`]))

  T.push(([`get_spazi_liberi`], [composito], [`DisponibilitaCore` (TurniCalendario + Appuntamenti)]))

  T.push(([`trova_risorsa_disponibile`], [composito], [`DisponibilitaCore` (TurniCalendario + Risorse + Appuntamenti)]))

  T.push(([`SetSymposiumToken`], [_control-plane_], [interno, non esposto al modello]))

  T.push((table.cell(colspan: 3, [*_Plugin_ Semantic Kernel*]),))

  T.push(([`pianifica_e_proponi`], [validazione], [`PianificaPlugin`]))

  return T
}
