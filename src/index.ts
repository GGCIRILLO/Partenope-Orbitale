import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { bearerAuth } from "hono/bearer-auth";
import { queryApp } from "./routes/query.js";

const app = new Hono();

const tokenTifoso = "token-tifoso";
const tokenAllenatore = "token-allenatore";
const tokenPresidente = "token-presidente";

// Middleware GET (TIFOSO, ALLENATORE, PRESIDENTE)
app.on("GET", "/api/*", async (c, next) => {
  const bearer = bearerAuth({
    token: [tokenTifoso, tokenAllenatore, tokenPresidente],
    noAuthenticationHeaderMessage: () => ({
      error:
        "Accesso negato: fornisci un token per consultare i dati della missione.",
    }),
    invalidAuthenticationHeaderMessage: () => ({
      error: "Header di autenticazione non valido. Serve un Bearer token!",
    }),
    invalidTokenMessage: () => ({
      error:
        "Token non valido: il tuo ruolo non ha accesso a questa funzionalità.",
    }),
  });
  return bearer(c, next);
});

// Middleware POST/PUT (ALLENATORE, PRESIDENTE)
app.on(["POST", "PUT"], "/api/*", async (c, next) => {
  const bearer = bearerAuth({
    token: [tokenAllenatore, tokenPresidente],
    invalidTokenMessage: () => ({
      error:
        "Solo Allenatori Lunari e Presidenti Galattici possono modificare le missioni.",
    }),
  });
  return bearer(c, next);
});

// Middleware PATCH/DELETE (solo PRESIDENTE)
app.on(["PATCH", "DELETE"], "/api/*", async (c, next) => {
  const bearer = bearerAuth({
    token: tokenPresidente,
    invalidTokenMessage: () => ({
      error: "Solo il Presidente Galattico può compiere questa azione suprema.",
    }),
  });
  return bearer(c, next);
});
app.get("/", (c) => {
  return c.text("Hello Hono!");
});

// Esempio di endpoint
app.get("/api/missioni", (c) => {
  return c.json({ message: "Elenco missioni visibile a tutti i ruoli" });
});

app.post("/api/missioni", (c) => {
  return c.json({ message: "Missione creata da Allenatore o Presidente" });
});

app.delete("/api/missioni", (c) => {
  return c.json({ message: "Missione eliminata dal Presidente" });
});

app.route("/api/query", queryApp);

serve(
  {
    fetch: app.fetch,
    port: 3000,
  },
  (info) => {
    console.log(`Server is running on http://localhost:${info.port}`);
  }
);
