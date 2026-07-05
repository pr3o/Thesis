
# Tesi di Laurea in Informatica - Università degli Studi di Padova

**Titolo:** Sviluppo di un chatbot basato su Model Context Protocol per il supporto alla pianificazione delle attività aziendali  
**Candidato:** Leonardo Preo  
**Azienda Ospitante:** Omega Gruppo 

## Descrizione del Progetto
Questo repository contiene il codice sorgente del documento di tesi, redatto interamente in Typst. 
Il lavoro illustra la progettazione e l'implementazione di un assistente virtuale integrato nell'ecosistema aziendale, progettato per supportare gli utenti nella pianificazione delle attività. Il cuore del sistema sfrutta i Large Language Models (LLM) e il **Model Context Protocol (MCP)**, permettendo all'intelligenza artificiale di interagire in modo sicuro, deterministico e contestualizzato con le API aziendali (come Symposium e Agilis), mitigando attattivamente il rischio di allucinazioni tramite delega deterministica e interazione "human-in-the-loop".

## Struttura del Documento
La tesi è organizzata nei seguenti capitoli:

1. **Introduzione**: Contesto aziendale, definizione del problema e obiettivi del progetto.
2. **Stato dell'Arte**: Evoluzione degli LLM, paradigma del Tool Use (Function Calling) e introduzione architetturale al Model Context Protocol.
3. **Analisi dei requisiti**: Analisi degli utenti, formulazione delle user stories ed estrazione dei macro-requisiti.
4. **Tecnologie utilizzate**: Panoramica su .NET, C#, Microsoft Semantic Kernel, SDK MCP e motori LLM (Ollama).
5. **Progettazione**: Architettura di distribuzione a tre nodi, ciclo di vita dei token, flussi end-to-end e pattern architetturali adottati per garantire isolamento e sicurezza.
6. **Implementazione**: Sviluppo effettivo del Server MCP, orchestrazione lato Client, catena di filtri e integrazione del modulo chatbot nell'interfaccia utente.
7. **Conclusioni**: Consuntivo finale sul raggiungimento degli obiettivi, rischi mitigati e possibili sviluppi futuri.
- **Appendici**: Elenco completo delle user stories, tracciamento dei requisiti, listati di codice essenziali e Glossario.

## Tecnologie del Progetto Software
- **Core & Orchestrazione**: C#, .NET, Microsoft Semantic Kernel
- **Protocolli**: Model Context Protocol (MCP)
- **Modelli AI**: Ollama / G LLM
- **Typesetting Tesi**: Typst

---

## Compilazione del Documento (Typst)

Questo documento utilizza [Typst](https://typst.app/) per la composizione tipografica. 

### Prerequisiti
Assicurati di aver installato la CLI di Typst sul tuo sistema. 

### Comandi di compilazione
Eseguire questi comandi nella root del progetto.

Genera il PDF conforme a PDF/A‑3B:
```sh
typst c thesis.typ --pdf-standard a-3b
```
Attiva la **watch mode** per ricompilare ad ogni salvataggio:
```sh
typst w thesis.typ
```