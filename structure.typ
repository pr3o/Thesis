/* Questo file serve per:
- Gestire i capitoli
- Gestire lo stile e la numerazione del conteggio delle pagine
*/

// Frontmatter
#include "preface/firstpage.typ"
#include "preface/copyright.typ"

#set page(numbering: "i")
#include "preface/dedication.typ"
#include "preface/acknowledgements.typ"
#include "preface/summary.typ"
#include "preface/table-of-contents.typ"

// Mainmatter
#counter(page).update(1)
#set page(numbering: "1.")
#include "chapters/1_introduzione.typ"
#include "chapters/2_stato-arte.typ"
#include "chapters/3_analisi.typ"
#include "chapters/4_technologies.typ"
#include "chapters/5_design.typ"
#include "chapters/6_implementation.typ"
#include "chapters/7_conclusion.typ"

#counter(heading).update(0)
#set heading(numbering: "A.1")
#include "chapters/A_appendice.typ"
#include "chapters/B_appendice.typ"

// Backmatter
#include "appendix/glossary/glossary.typ"
#include "appendix/bibliography/bibliography.typ"
