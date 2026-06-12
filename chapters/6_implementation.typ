#import "../config/thesis-config.typ": glpl, gl,
#pagebreak(to:"odd")

= Implementazione <cap:implementazione>

#text(style: "italic", [
    In questo capitolo descrivo come sono state realizzate le scelte architetturali illustrate nel capitolo precedente, organizzando l'esposizione per problema affrontato e riportando i frammenti di codice più significativi; i listati estesi sono raccolti in appendice.
])
#v(1em)
== Il server MCP: bootstrap e tool
Il server MCP è costruito con `Host.CreateApplicationBuilder`. L'ordine delle fonti di configurazione è deliberato: le variabili d'ambiente devono prevalere su `appsettings.json`, perchè il token aggiornato arriva dall'host come variabile d'ambiente e non deve essere sovrascritto da un eventuale token di sviluppo, scaduto, presente nel file. In avvio vengono registrati il provider del token come _singleton_ e i tool che espongono le risorse del gestionale, mentre il trasporto è _stdio_.\

Ogni tool è una classe con un metodo annotato `[McpServerTool]` e `[Description(...)]`: riceve via _dependency injection_ il _resolver_ del client REST, costruisce i parametri opzionali, chiama l'endpoint `mcp/<Risorsa>` e formatta la risposta. I tool offerti all'LLM corrispondono alle risorse del dominio (appuntamenti, task, risorse, competenze, calendario lavorativo); fa eccezione il tool di _control-plane_ per l'aggiornamento del _bearer_, riservato all'host ed escluso dai tool visibili al modello. La tabella completa dei tool e degli endpoint corrispondenti è in Appendice B.

== Il client MCP: orchestrazione e catena di filtri
Il client MCP è l'host dell'LLM. In avvio crea il _Kernel_ di Semantic Kernel puntato all'endpoint remoto, avvia il server MCP ereditando le variabili d'ambiente di autenticazione, mappa i tool MCP in funzioni del _Kernel_ (escludendo il tool di _control-plane_) e registra i filtri di auto-invocazione. L'ordine di registrazione conta, perché il primo registrato è il più esterno della catena: un filtro anti-loop che termina l'esecuzione quando si supera un numero massimo di round di tool; un filtro di osservabilità che accoda nome, parametri e risultato di ogni invocazione in una coda concorrente per l'interfaccia; e un filtro di _refresh_ del token che, riconosciuto il segnale di token scaduto, ne richiede il rinnovo e ritenta l'operazione.