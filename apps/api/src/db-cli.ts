import { readFile, readdir } from "node:fs/promises";
import { resolve } from "node:path";
import pg from "pg";
import { parseConfig } from "./config.js";

const mode = process.argv[2];
if (mode !== "migrate" && mode !== "seed") throw new Error("Usage: db-cli.ts migrate|seed");
const root = resolve(import.meta.dirname, "../../../");
const directory = resolve(root, mode === "migrate" ? "db/migrations" : "db/seeds");
const files = (await readdir(directory)).filter((file) => file.endsWith(".sql")).sort();
const pool = new pg.Pool({ connectionString: parseConfig(process.env).DATABASE_URL });
try {
  for (const file of files) { console.log(`${mode}: ${file}`); await pool.query(await readFile(resolve(directory, file), "utf8")); }
} finally { await pool.end(); }

