import { Hono } from "hono";
import { sql, eq, gt, desc, asc } from "drizzle-orm";
import { db } from "../db/index.js";
import {
  membriEquipaggio,
  partecipazioni,
  coinvolgimenti,
  interventi,
  risoluzioni,
  anomalie,
  sensori,
  rilevazioni,
} from "../db/schema.js";

export const queryApp = new Hono();

queryApp.get("/", (c) => {
  return c.text("Query API");
});

queryApp.get("/query1", async (c) => {
  const result = await db
    .select({
      id: membriEquipaggio.id,
      nome: membriEquipaggio.nome,
      cognome: membriEquipaggio.cognome,
      numeroMissioni: sql`count(*)`.as("numeroMissioni"),
    })
    .from(membriEquipaggio)
    .innerJoin(partecipazioni, eq(membriEquipaggio.id, partecipazioni.membroId))
    .groupBy(
      membriEquipaggio.id,
      membriEquipaggio.nome,
      membriEquipaggio.cognome
    )
    .orderBy(desc(sql`numeroMissioni`));

  return c.json(result);
});

queryApp.get("/query4", async (c) => {
  const result = await db
    .selectDistinct({
      id: membriEquipaggio.id,
      nome: membriEquipaggio.nome,
      cognome: membriEquipaggio.cognome,
    })
    .from(membriEquipaggio)
    .innerJoin(coinvolgimenti, eq(membriEquipaggio.id, coinvolgimenti.membroId))
    .innerJoin(interventi, eq(coinvolgimenti.interventoId, interventi.id))
    .innerJoin(risoluzioni, eq(interventi.id, risoluzioni.interventoId))
    .innerJoin(anomalie, eq(risoluzioni.anomaliaId, anomalie.id))
    .innerJoin(sensori, eq(anomalie.sensoreId, sensori.id))
    .where(eq(sensori.stato, "malfunzionante"))
    .orderBy(asc(membriEquipaggio.id));

  return c.json(result);
});

queryApp.get("/query7", async (c) => {
  const result = await db
    .select({
      sensoreId: rilevazioni.sensoreId,
      tipo: sensori.tipo,
      mediaValori: sql`AVG(${rilevazioni.valore})`.as("mediaValori"),
    })
    .from(rilevazioni)
    .innerJoin(sensori, eq(rilevazioni.sensoreId, sensori.id))
    .groupBy(rilevazioni.sensoreId, sensori.tipo)
    .having(gt(sql`AVG(${rilevazioni.valore})`, 60))
    .orderBy(desc(sql`AVG(${rilevazioni.valore})`));

  return c.json(result);
});
