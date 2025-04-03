import Database from "better-sqlite3";
import fs from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const db = new Database("db.sqlite");
const seedSql1 = fs.readFileSync(join(__dirname, "seed-1.sql"), "utf-8");
const seedSql2 = fs.readFileSync(join(__dirname, "seed-2.sql"), "utf-8");

db.exec(seedSql1);
db.exec(seedSql2);

console.log("✅ Seeding SQL completato");
