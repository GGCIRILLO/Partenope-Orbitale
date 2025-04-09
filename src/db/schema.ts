import {
  sqliteTable,
  integer,
  real,
  text,
  sqliteView,
  primaryKey,
  index,
  uniqueIndex,
} from "drizzle-orm/sqlite-core";
import { eq, desc, sql, asc } from "drizzle-orm";




// ------------- TABELLE ------------------

export const missioni = sqliteTable(
  "MISSIONI",
  {
    id: integer("ID").primaryKey({ autoIncrement: true }).unique(),
    obiettivo: text("Obiettivo", { length: 100 }).notNull(),
    dataInizio: text("DataInizio").notNull(), // SQLite usa TEXT per le DATE
    dataFine: text("DataFine"),
    stato: text("Stato", {
      enum: ["pianificata", "in_corso", "completata", "annullata"],
    }).notNull(),
  },
  (table) => [index("IDX_MISSIONI_STATO").on(table.stato)]
);

export const membriEquipaggio = sqliteTable(
  "MEMBRI_EQUIPAGGIO",
  {
    id: integer("ID").primaryKey({ autoIncrement: true }),
    nome: text("Nome", { length: 50 }).notNull(),
    cognome: text("Cognome", { length: 50 }).notNull(),
    ruolo: text("Ruolo", { length: 30 }).notNull(),
  },
  (table) => [index("IDX_MEMBRI_RUOLO").on(table.ruolo)]
);

export const sensori = sqliteTable(
  "SENSORI",
  {
    id: integer("ID").primaryKey({ autoIncrement: true }),
    tipo: text("Tipo", {
      enum: ["temperatura", "pressione", "gas", "radiazioni", "geologia"],
    }).notNull(),
    latitudine: real("Latitudine").notNull(),
    longitudine: real("Longitudine").notNull(),
    altitudine: real("Altitudine").notNull(),
    dataInstallazione: text("DataInstallazione").notNull(),
    dataUltimoControllo: text("DataUltimoControllo"),
    stato: text("Stato", {
      enum: ["attivo", "standby", "manutenzione", "malfunzionante"],
    }).notNull(),
  },
  (table) => [index("IDX_SENSORI_TIPO").on(table.tipo)]
);

export const robot = sqliteTable("ROBOT", {
  id: integer("ID").primaryKey({ autoIncrement: true }),
  tipo: text("Tipo", {
    enum: ["esplorazione", "manutenzione", "raccolta_risorse"],
  }).notNull(),
});

export const rilevazioni = sqliteTable(
  "RILEVAZIONI",
  {
    id: integer("ID").primaryKey({ autoIncrement: true }),
    timestamp: text("Timestamp").notNull(),
    valore: real("Valore").notNull(),
    sensoreId: integer("SensoreID")
      .notNull()
      .references(() => sensori.id),
  },
  (table) => [
    index("IDX_RILEVAZIONI_SENSORI_TIMESTAMP").on(
      table.sensoreId,
      table.timestamp
    ),
  ]
);

export const anomalie = sqliteTable(
  "ANOMALIE",
  {
    id: integer("ID").primaryKey({ autoIncrement: true }),
    timestamp: text("Timestamp").notNull(),
    livello: text("Livello", {
      enum: ["bassa", "media", "alta", "critica"],
    }).notNull(),
    causa: text("Causa", { length: 100 }).notNull(),
    sensoreId: integer("SensoreID")
      .notNull()
      .references(() => sensori.id),
  },
  (table) => [index("IDX_ANOMALIE_LIVELLO").on(table.livello)]
);

export const interventi = sqliteTable("INTERVENTI", {
  id: integer("ID").primaryKey({ autoIncrement: true }),
  descrizione: text("Descrizione", { length: 100 }).notNull(),
  dataEsecuzione: text("DataEsecuzione").notNull(),
  esito: text("Esito", { length: 30 }),
});

export const report = sqliteTable("REPORT", {
  id: integer("ID").primaryKey({ autoIncrement: true }),
  valutazione: text("Valutazione", { length: 100 }),
});

// Relazioni N:N o composite
export const utilizzoSensori = sqliteTable(
  "UTILIZZO_SENSORI",
  {
    missioneId: integer("MissioneID")
      .notNull()
      .references(() => missioni.id),
    sensoreId: integer("SensoreID")
      .notNull()
      .references(() => sensori.id),
  },
  (table) => [primaryKey({ columns: [table.missioneId, table.sensoreId] })]
);

export const utilizzoRobot = sqliteTable(
  "UTILIZZO_ROBOT",
  {
    missioneId: integer("MissioneID")
      .notNull()
      .references(() => missioni.id),
    robotId: integer("RobotID")
      .notNull()
      .references(() => robot.id),
  },
  (table) => [primaryKey({ columns: [table.missioneId, table.robotId] })]
);

export const partecipazioni = sqliteTable(
  "PARTECIPAZIONI",
  {
    missioneId: integer("MissioneID")
      .notNull()
      .references(() => missioni.id),
    membroId: integer("MembroID")
      .notNull()
      .references(() => membriEquipaggio.id),
  },
  (table) => [primaryKey({ columns: [table.missioneId, table.membroId] })]
);

export const coinvolgimenti = sqliteTable(
  "COINVOLGIMENTI",
  {
    interventoId: integer("InterventoID")
      .notNull()
      .references(() => interventi.id),
    membroId: integer("MembroID")
      .notNull()
      .references(() => membriEquipaggio.id),
  },
  (table) => [primaryKey({ columns: [table.interventoId, table.membroId] })]
);

export const interazioniTecniche = sqliteTable(
  "INTERAZIONI_TECNICHE",
  {
    membroId: integer("MembroID")
      .notNull()
      .references(() => membriEquipaggio.id),
    sensoreId: integer("SensoreID")
      .notNull()
      .references(() => sensori.id),
    timestamp: text("Timestamp").notNull(),
    tipo: text("Tipo", {
      enum: ["manutenzione", "riparazione", "verifica"],
    }).notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.membroId, table.sensoreId, table.timestamp] }),
  ]
);

export const risoluzioni = sqliteTable("RISOLUZIONI", {
  interventoId: integer("InterventoID")
    .references(() => interventi.id)
    .primaryKey(),
  anomaliaId: integer("AnomaliaID")
    .notNull()
    .references(() => anomalie.id),
  esito: text("Esito", { length: 20 }),
  dataEsecuzione: text("DataEsecuzione").notNull(),
});

export const redazione = sqliteTable(
  "REDAZIONE",
  {
    membroId: integer("MembroID")
      .notNull()
      .references(() => membriEquipaggio.id),
    missioneId: integer("MissioneID")
      .notNull()
      .references(() => missioni.id),
    reportId: integer("ReportID")
      .notNull()
      .references(() => report.id),
    data: text("Data").notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.membroId, table.missioneId] }),
    index("IDX_REPORT_DATA").on(table.data),
  ]
);

// ------------- VIEWS ------------------
// 1. ANDAMENTO MISSIONI
export const andamentoMissioni = sqliteView("ANDAMENTO_MISSIONI").as((qb) =>
  qb
    .select({
      idMissione: missioni.id,
      obiettivo: missioni.obiettivo,
      stato: missioni.stato,
      totaleAnomalie: sql`COUNT(${anomalie.id})`.as("totaleAnomalie"),
    })
    .from(missioni)
    .leftJoin(anomalie, eq(missioni.id, anomalie.sensoreId))
    .groupBy(missioni.id, missioni.obiettivo, missioni.stato)
    .orderBy(desc(sql`totaleAnomalie`))
);

// 2. EROI DELLA LUNA
export const eroiDellaLuna = sqliteView("EROI_DELLA_LUNA").as((qb) =>
  qb
    .select({
      idMembro: membriEquipaggio.id,
      nome: membriEquipaggio.nome,
      cognome: membriEquipaggio.cognome,
      missioniPartecipate: sql`COUNT(DISTINCT ${partecipazioni.missioneId})`.as(
        "missioniPartecipate"
      ),
      interventiEffettuati:
        sql`COUNT(DISTINCT ${coinvolgimenti.interventoId})`.as(
          "interventiEffettuati"
        ),
    })
    .from(membriEquipaggio)
    .leftJoin(partecipazioni, eq(membriEquipaggio.id, partecipazioni.membroId))
    .leftJoin(coinvolgimenti, eq(membriEquipaggio.id, coinvolgimenti.membroId))
    .groupBy(
      membriEquipaggio.id,
      membriEquipaggio.nome,
      membriEquipaggio.cognome
    )
    .orderBy(desc(sql`interventiEffettuati`))
);

// 3. SENSORI SOTTO PRESSIONE
export const sensoriSottoPressione = sqliteView("SENSORI_SOTTO_PRESSIONE").as(
  (qb) =>
    qb
      .select({
        sensoreId: sensori.id,
        tipo: sensori.tipo,
        numeroAnomalie: sql`COUNT(${anomalie.id})`.as("numeroAnomalie"),
      })
      .from(sensori)
      .leftJoin(anomalie, eq(sensori.id, anomalie.sensoreId))
      .groupBy(sensori.id, sensori.tipo)
      .orderBy(desc(sql`numeroAnomalie`))
);

// 4. STATISTICHE RILEVAZIONI
export const statisticheRilevazioni = sqliteView("STATISTICHE_RILEVAZIONI").as(
  (qb) =>
    qb
      .select({
        sensoreId: sensori.id,
        tipo: sensori.tipo,
        mediaValore: sql`ROUND(AVG(${rilevazioni.valore}), 2)`.as(
          "mediaValore"
        ),
        valoreMassimo: sql`MAX(${rilevazioni.valore})`.as("valoreMassimo"),
        valoreMinimo: sql`MIN(${rilevazioni.valore})`.as("valoreMinimo"),
      })
      .from(sensori)
      .innerJoin(rilevazioni, eq(sensori.id, rilevazioni.sensoreId))
      .groupBy(sensori.id, sensori.tipo)
      .orderBy(sensori.tipo, desc(sql`mediaValore`))
);

// 5. CALENDARIO INTERVENTI
export const calendarioInterventi = sqliteView("CALENDARIO_INTERVENTI").as(
  (qb) =>
    qb
      .select({
        interventoId: interventi.id,
        descrizione: interventi.descrizione,
        dataEsecuzione: interventi.dataEsecuzione,
        anomaliaId: anomalie.id,
        livello: anomalie.livello,
        sensoreId: anomalie.sensoreId,
      })
      .from(interventi)
      .leftJoin(risoluzioni, eq(interventi.id, risoluzioni.interventoId))
      .leftJoin(anomalie, eq(risoluzioni.anomaliaId, anomalie.id))
      .orderBy(asc(interventi.dataEsecuzione))
);

// 6. REDAZIONE RECENTE
export const redazioneRecente = sqliteView("REDAZIONE_RECENTE").as((qb) =>
  qb
    .select({
      reportId: report.id,
      valutazione: report.valutazione,
      data: redazione.data,
      missione: missioni.obiettivo,
      autore:
        sql`${membriEquipaggio.nome} || ' ' || ${membriEquipaggio.cognome}`.as(
          "autore"
        ),
    })
    .from(report)
    .innerJoin(redazione, eq(report.id, redazione.reportId))
    .innerJoin(missioni, eq(redazione.missioneId, missioni.id))
    .innerJoin(membriEquipaggio, eq(redazione.membroId, membriEquipaggio.id))
    .orderBy(desc(redazione.data))
    .limit(10)
);
