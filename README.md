# 🚀 Partenope Orbitale

**Partenope Orbitale** è un progetto universitario per il corso di Basi di Dati, ispirato al mondo SSC Napoli... ma ambientato sulla Luna. Il sistema gestisce missioni di esplorazione lunare simulate, sensori, robot, anomalie, interventi tecnici e report scientifici — tutto condito con un tocco partenopeo.

## 🧠 Descrizione del progetto

L'obiettivo è progettare e implementare un database relazionale completo, dalla modellazione concettuale fino alla realizzazione pratica in SQL e interfaccia web.

Il sistema è stato arricchito con componenti extra non richiesti dalla traccia, per dimostrare estendibilità, modularità e modernità nello sviluppo software.

## 📦 Funzionalità principali

- ✅ Progettazione E-R e schema relazionale completo
- ✅ Script SQL per creazione tabelle, vincoli, trigger, viste e stored procedures
- ✅ Interfaccia grafica realizzata con **Oracle APEX**
- ✅ Sistema di ruoli e privilegi con accessi differenziati (Presidente, Allenatore, Tifoso)
- ✅ Stored procedures per gestione missioni, interventi e statistiche
- ✅ **Trigger intelligenti** per automatizzare controlli e aggiornamenti
- ✅ **Viste** per analisi aggregate e dashboard
- ✅ **Query avanzate** con `HAVING`, `NOT EXISTS`, subquery e funzioni di aggregazione

Percorso: 
Tabelle: `SeedingPartenopeOrbitale/table.sql`
Operazioni (Query, Procedures, etc): `SeedingPartenopeOrbitale/operazioni.sql`


## 🌐 Web API + ORM

Come estensione del progetto (non richiesta dalla traccia), è stata sviluppata una **Web API RESTful** in TypeScript utilizzando:

- ⚙️ **Drizzle ORM** – leggero, typesafe, con controllo esplicito dello schema
- 💾 **SQLite** – database integrato per sviluppo e prototipazione veloce

L'API consente l'accesso programmato ai dati del sistema, utile per frontend web/app o integrazioni future.

## 🌱 Seeding dei dati

Per facilitare i test e la dimostrazione delle funzionalità, è stato incluso uno script standalone in **Python** che genera automaticamente dati realistici per tutte le tabelle del database.

Lo script produce un file `.sql` contenente solo comandi `INSERT INTO`, pronto per essere eseguito in ambiente Oracle oppure adattato per SQLite.

### ✨ Caratteristiche del seeding:
- ✅ Dati coerenti e simulati: missioni, sensori, robot, anomalie, rilevazioni, interventi...
- 🔁 Quantità configurabili tramite variabili globali
- 🧠 Valori realistici con array predefiniti per ruoli, obiettivi, anomalie, valutazioni
- 📁 Output: `seed_partenope_orbitale.sql`

> Lo script è pensato per essere facilmente estendibile o adattabile ad altri DBMS.

Percorso:  
`/SeedingPartenopeOrbitale/seed_partenope_orbitale.py`
`/SeedingPartenopeOrbitale/seed_partenope_orbitale_2.py`

## 🗃️ Tecnologie utilizzate

| Componente       | Tecnologia          |
|------------------|---------------------|
| Database         | Oracle SQL / SQLite |
| ORM              | Drizzle ORM         |
| API REST         | TypeScript          |
| Interfaccia GUI  | Oracle APEX         |
| Script Seeding   | Python              |

## ✨ Autori

- Luigi Cirillo – [@luigicirillo](https://github.com/luigicirillo)
- Matteo Adaggio – [@matteoadaggio](https://github.com/matteoadaggio)

---

\> Progetto realizzato per il corso di **Basi di Dati**, Università Federico II, 2024/2025.  
Con un sogno: portare l’azzurro… anche sulla Luna. 🌕
