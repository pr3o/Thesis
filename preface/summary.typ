#import "../config/constants.typ": abstract
#import "../config/variables.typ": *
#import "../config/thesis-config.typ": glossary-style
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#pagebreak(to: "odd")
#v(4em)

#text(24pt, weight: "semibold", abstract)

#v(1em)
Il presente documento descrive il lavoro svolto durante il periodo di stage curricolare, della durata di circa trecentoventi ore, dal laureando #text(myName) presso l'azienda #text(myCompany). Lo stage è stato condotto sotto la supervisione del tutor aziendale #myTutor, mentre il prof. #text(myProf) ha ricoperto il ruolo di tutor accademico.
\ \
Questa tesi tratta la progettazione e lo sviluppo di *Nome progetto*, un modulo chatbot integrato all'interno del gestionale Agilis, volto a supportare il reparto _Delivery_ nella pianificazione delle attività operative. L'obiettivo è quello di fornire uno strumento di supporto decisionale basato su intelligenza artificiale, in grado di interagire in linguaggio naturale con gli operatori, suggerendo soluzioni di pianificazione intelligente e segnalando eventuali conflitti o vincoli non rispettati.

#linebreak()
#text(24pt, weight: "semibold")[Organizzazione del testo]
#linebreak()
#v(1em)

/ #link(<cap:introduzione>)[Il primo capitolo]: presenta l'azienda, introduce il progetto e illustra le motivazioni che mi hanno portato a sceglierlo, definendone gli obiettivi e il contributo originale;
/ #link(<cap:stato-arte>)[Il secondo capitolo]: ripercorre lo stato dell'arte su cui poggia il lavoro: l'evoluzione dei _Large Language Models_, il paradigma del _tool use_ e della _function calling_, il _Model Context Protocol_ e i framework di orchestrazione;
/ #link(<cap:analisi>)[Il terzo capitolo]: analizza gli utenti e i casi d'uso del sistema e ne deriva i requisiti, distinti in funzionali, non funzionali e vincoli, rimandando all'#link(<cap:A-appendice>)[Appendice A] per la specifica completa;
/ #link(<cap:tecnologie-utilizzate>)[Il quarto capitolo]: descrive le tecnologie adottate, motivando le ragioni che ne hanno guidato la scelta;
/ #link(<cap:progettazione>)[Il quinto capitolo]: descrive la progettazione del sistema: l'architettura di distribuzione, i componenti principali e le loro interazioni, il modello di interazione uomo-AI e le principali decisioni architetturali;
/ #link(<cap:implementazione>)[Il sesto capitolo]: descrive l'implementazione, illustrando le scelte tecniche più significative e le sfide affrontate;
/ #link(<cap:conclusioni>)[Il settimo capitolo]: trae le conclusioni: il consuntivo tra piano di lavoro e lavoro effettivo, il grado di raggiungimento degli obiettivi, i rischi occorsi e i possibili sviluppi futuri.

#linebreak()
#text(24pt, weight: "semibold", "Convenzioni tipografiche")
#linebreak()
#v(1em)
Durante la stesura del testo ho scelto di adottare le seguenti convenzioni tipografiche:

//Preferenze personali modificabili a discrezione tua o del relatore
- Gli acronimi, le abbreviazioni e i termini di uso non comune menzionati vengono definiti nel #link(<glossary>)[glossario], situato alla fine del documento (#link(<glossary>)[p. #context counter(page).at(<glossary>).at(0)]);
- Per la prima occorrenza dei termini riportati nel glossario viene utilizzata la seguente nomenclatura: #glossary-style[termine]\;
- I termini in lingua straniera non di uso comune o facenti parti del gergo tecnico sono evidenziati con il carattere _corsivo_;
- I nomi di funzioni o variabili appartenenti ad un linguaggio di programmazione vengono scritte con un carattere `monospaziato`;
- Le citazioni ad un libro o ad una risorsa presente nella #link(<bibliography>)[bibliografia] (#link(<bibliography>)[p. #context counter(page).at(<bibliography>).at(0)]) saranno affiancate dal rispettivo numero identificativo, es. $[1]$;
- I blocchi di codice sono rappresentati nel seguente modo
#linebreak()
#figure(caption: "Codice d'esempio.")[
```cs
using System;

namespace EsempioTesi
{
    class Program
    {
        // Metodo principale di esecuzione
        static void Main(string[] args)
        {
            int risultato = CalcolaSomma(5, 7);
            Console.WriteLine($"Il risultato è: {risultato}");
        }

        /// <summary> Calcola la somma di due numeri interi.</summary>
        static int CalcolaSomma(int a, int b)
        {
            return a + b;
        }
    }
}
```
]
