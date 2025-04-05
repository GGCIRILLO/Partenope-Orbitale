import { sqliteView } from "drizzle-orm/sqlite-core";
import { eq, desc, sql, asc } from "drizzle-orm";
import {
  missioni,
  anomalie,
  membriEquipaggio,
  partecipazioni,
  coinvolgimenti,
  interventi,
  risoluzioni,
  sensori,
  rilevazioni,
  redazione,
  report,
} from "../db/schema.js";


