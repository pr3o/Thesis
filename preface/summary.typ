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

/ #link(<cap:introduzione>)[Il primo capitolo]: introduce l'azienda, il progetto e le motivazioni che mi hanno portato a sceglierlo;
/ #link(<cap:descrizione-stage>)[Il secondo capitolo]: descrive l'azienda, il progetto e l'organizzazione del lavoro, definendo gli obiettivi e analizzando i rischi;
/ #link(<cap:analisi-requisiti>)[Il terzo capitolo]: analizza gli utenti, sviluppa le user stories e compone la lista dei requisiti dividendo per tipologia e necessità;
/ #link(<cap:tecnologie-utilizzate>)[Il quarto capitolo]: descrive le tecnologie utilizzate, le descrive e spiega le ragioni che mi hanno portato a sceglierle;
/ #link(<cap:progettazione>)[Il quinto capitolo]: descrive l'architettura del sistema, i componenti principali e le interazioni tra di essi;
/ #link(<cap:implementazione>)[Il sesto capitolo]: descrive l'implementazione del sistema, illustrando le scelte tecniche adottate e le sfide affrontate;
/ #link(<cap:conclusioni>)[Il settimo capitolo]: riassume i risultati ottenuti, livello di raggiungimento degli obiettivi, conoscenze acquisite e propone possibili sviluppi futuri del progetto.

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
