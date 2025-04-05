import { Hono } from "hono";
import { andamentoMissioni } from "../db/schema.js";
import { db } from "../db/index.js";

export const viewsApp = new Hono();

viewsApp.get("/andamento-missioni", async (c) => {
  const result = await db.select().from(andamentoMissioni);
  return c.json(result);
});
