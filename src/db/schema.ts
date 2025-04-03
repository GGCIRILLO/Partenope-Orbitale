import {
  sqliteTable,
  integer,
  real,
  text,
} from "drizzle-orm/sqlite-core";

// Esempio: Missioni
export const missioni = sqliteTable("MISSIONI", {
  id: integer("ID").primaryKey({ autoIncrement: true }).unique(),
  obiettivo: text("Obiettivo", { length: 100 }).notNull(),
  dataInizio: text("DataInizio").notNull(), // SQLite usa TEXT per le DATE
  dataFine: text("DataFine"),
  stato: text("Stato", { enum: ['pianificata', 'in_corso', 'completata', 'annullata'] }).notNull(),
});

export const membriEquipaggio = sqliteTable("MEMBRI_EQUIPAGGIO", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  nome: text("Nome", { length: 50 }).notNull(),
  cognome: text("Cognome", { length: 50 }).notNull(),
  ruolo: text("Ruolo", { length: 30 }).notNull(),
});

export const sensori = sqliteTable("SENSORI", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  tipo: text("Tipo", { enum: ['temperatura', 'pressione', 'gas', 'radiazioni', 'geologia'] }).notNull(),
  latitudine: real("Latitudine").notNull(),
  longitudine: real("Longitudine").notNull(),
  altitudine: real("Altitudine").notNull(),
  dataInstallazione: text("DataInstallazione").notNull(),
  dataUltimoControllo: text("DataUltimoControllo"),
  stato: text("Stato", { enum: ['attivo', 'standby', 'manutenzione', 'malfunzionante'] }).notNull(),
});

export const robot = sqliteTable("ROBOT", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  tipo: text("Tipo", { enum: ['esplorazione', 'manutenzione', 'raccolta_risorse'] }).notNull(),
});

export const rilevazioni = sqliteTable("RILEVAZIONI", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  timestamp: text("Timestamp").notNull(),
  valore: real("Valore").notNull(),
  sensoreId: integer("SensoreID").notNull().references(() => sensori.id),
});

export const anomalie = sqliteTable("ANOMALIE", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  timestamp: text("Timestamp").notNull(),
  livello: text("Livello", { enum: ['bassa', 'media', 'alta', 'critica'] }).notNull(),
  causa: text("Causa", { length: 100 }).notNull(),
  sensoreId: integer("SensoreID").notNull().references(() => sensori.id),
});

export const interventi = sqliteTable("INTERVENTI", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  descrizione: text("Descrizione", { length: 100 }).notNull(),
  dataEsecuzione: text("DataEsecuzione").notNull(),
  esito: text("Esito", { length: 30 }),
});

export const report = sqliteTable("REPORT", {
  id: integer("ID").primaryKey({ autoIncrement: true}),
  valutazione: text("Valutazione", { length: 100 }),
});

// Relazioni N:N o composite
export const utilizzoSensori = sqliteTable("UTILIZZO_SENSORI", {
  missioneId: integer("MissioneID").notNull().references(() => missioni.id),
  sensoreId: integer("SensoreID").notNull().references(() => sensori.id),
});

export const utilizzoRobot = sqliteTable("UTILIZZO_ROBOT", {
  missioneId: integer("MissioneID").notNull().references(() => missioni.id),
  robotId: integer("RobotID").notNull().references(() => robot.id),
});

export const partecipazioni = sqliteTable("PARTECIPAZIONI", {
  missioneId: integer("MissioneID").notNull().references(() => missioni.id),
  membroId: integer("MembroID").notNull().references(() => membriEquipaggio.id),
});

export const coinvolgimenti = sqliteTable("COINVOLGIMENTI", {
  interventoId: integer("InterventoID").notNull().references(() => interventi.id),
  membroId: integer("MembroID").notNull().references(() => membriEquipaggio.id),
});

export const interazioniTecniche = sqliteTable("INTERAZIONI_TECNICHE", {
  membroId: integer("MembroID").notNull().references(() => membriEquipaggio.id),
  sensoreId: integer("SensoreID").notNull().references(() => sensori.id),
  timestamp: text("Timestamp").notNull(),
  tipo: text("Tipo", { enum: ['manutenzione', 'riparazione', 'verifica'] }).notNull(),
});

export const risoluzioni = sqliteTable("RISOLUZIONI", {
  interventoId: integer("InterventoID").references(() => interventi.id),
  anomaliaId: integer("AnomaliaID").notNull().references(() => anomalie.id),
  esito: text("Esito", { length: 20 }),
  dataEsecuzione: text("DataEsecuzione").notNull(),
});

export const redazione = sqliteTable("REDAZIONE", {
  membroId: integer("MembroID").notNull().references(() => membriEquipaggio.id),
  missioneId: integer("MissioneID").notNull().references(() => missioni.id),
  reportId: integer("ReportID").notNull().references(() => report.id),
  data: text("Data").notNull(),
});
