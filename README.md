```
> [!NOTE]
> 🇮🇹 Questa repository contiene la **tesi di laurea finale** di Leonardo Preo, sviluppata con Typst.

# 📚 Titolo della tesi
**“Intelligenza Artificiale Generativa per la Programmazione Assistita: un approccio basato su Modelli di Contesto”**

# ✍️ Autore e relatore
- **Autore:** Leonardo Preo
- **Relatore:** Prof. Francesco Ranzato
- **Azienda di stage:** Omega S.r.l.

# 🗂️ Ambito e descrizione
La tesi affronta l’utilizzo di grandi modelli di lingua (LLM) per assistere lo sviluppo software, con focus su:
- integrazione di modelli di contesto (Model Context Protocol) nei workflow di programmazione;
- valutazione di framework come **Semantic Kernel**, **LangChain** e **Qwen**;
- progettazione di interfacce che permettono al programmatore di sfruttare le capacità generative per completare, refactoring e documentare codice;
- analisi di performance e conformità a standard accademici (PDF/A‑3B).

Il lavoro è strutturato in capitoli teorici, studio di casi reali (progetti svolti in Omega S.r.l.) e un prototipo funzionale.

# 📁 Struttura del repository
```
📦 thesis-template/
├─ 📂 appendix/          # Appendici e materiale supplementare
│   └─ 📂 bibliography/   # Bibliografia in YAML
├─ 📂 config/            # Variabili e costanti di configurazione
├─ 📂 docs/              # Documenti di esempio e guide
├─ 📂 src/               # Codice Typst della tesi (capitoli .typ)
│   ├─ 1_introduzione.typ
│   ├─ 2_stato-arte.typ
│   ├─ 3_metodologia.typ
│   ├─ 4_risultati.typ
│   ├─ 5_conclusioni.typ
│   └─ thesis.typ        # Entry point per la compilazione
├─ .github/workflows/    # GitHub Actions per CI/CD
└─ 📄 README.md          # Questo file
```

# 🛠️ Compilazione
Genera il PDF conforme a PDF/A‑3B:
```sh
typst c thesis.typ --pdf-standard a-3b
```
Attiva la **watch mode** per ricompilare ad ogni salvataggio:
```sh
typst w thesis.typ
```
```