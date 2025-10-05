# Week 6 – PostgreSQL DevContainer Demo

A reproducible Postgres + Python dev environment using VS Code Dev Containers. It seeds a sample `restaurants` table, lets you query via CLI/GUI, and includes per‑question SQL files (`Q1.sql` …) for grading.

---

## Components

* **Dev container** with Python 3.11, `psql`, and env vars preconfigured
* **Postgres 16** running in Docker with a persistent volume
* **Auto‑seed** on first boot via `init.sql`
* **Three ways to query**: `psql`, VS Code PostgreSQL Explorer, and Python (`psycopg2`)
* **Per‑question SQL files**: `Q1.sql` … `Q6.sql` for easy review

---

## Repo structure

```
.
├─ .devcontainer/
│  ├─ devcontainer.json          # VS Code container settings
│  ├─ docker-compose.yml         # Defines services: dev + db
│  └─ .env                       # DB name/user/password (demo)
├─ init.sql                      # Schema + seed data (runs on fresh volume)
├─ requirements.txt              # Python deps (psycopg2-binary, python-dotenv)
├─ scripts/
│  └─ query.py                   # Sample Python client
├─ Q1.sql … Q6.sql               # Week 6 practice queries (one file per question)
└─ README.md                     # This file
```

> **Note:** `init.sql` only runs when the Postgres data volume is empty. Use the reset command below to re‑seed.

---

## Quick start

1. **Install prerequisites**

   * Docker Desktop
   * VS Code + Dev Containers extension
   * (Optional) PostgreSQL extension for VS Code

2. **Open in a dev container**

   * VS Code → Command Palette → `Dev Containers: Reopen in Container`
   * First boot installs `psql` and Python deps and exports env vars to the shell (`PGHOST=db`, `PGUSER=vscode`, etc.)

3. **Confirm DB is up**

```bash
psql -h db -U vscode -d duke_restaurants -c "\dt"
```

You should see the `restaurants` table.

---

## Run the demo script (Python)

```bash
python scripts/query.py
```

It will:

* Print top‑rated places (SELECT)
* Insert a row (INSERT)
* Update a rating (UPDATE)
* Delete the current lowest‑rated row (DELETE)

---

## VS Code PostgreSQL Explorer (GUI)

* Install the “PostgreSQL” extension **inside** the container (Dev Containers → Install Local Extensions in Container)
* Add a new connection:

  * **Host:** `db`
  * **Port:** `5432`
  * **User:** `vscode`
  * **Password:** `vscode`
  * **Database:** `duke_restaurants`
  * **SSL:** Disabled or Prefer
* Browse **Schemas → public → tables → restaurants** and **View Data**

---

## Week 6 SQL practice files

Each question (Q1-6) has its own `.sql` file at repo root for easy grading.

> You can execute any file with:

```bash
psql -h db -U vscode -d duke_restaurants -f Q1.sql
```

To capture output to a file:

```bash
psql -h db -U vscode -d duke_restaurants -f Q1.sql -o results/Q1_output.txt
```

(Create a `results/` folder first.)

---

## Useful commands

**Start/stop containers**

```bash
# From repo root
docker compose -f .devcontainer/docker-compose.yml up -d
docker compose -f .devcontainer/docker-compose.yml down
```

**Reset database (wipe + re‑seed on next up)**

```bash
docker compose -f .devcontainer/docker-compose.yml down -v
```

**Inside `psql`**

```
\dt                      -- list tables
SELECT count(*) FROM restaurants;
\q                       -- quit
```

---

## Troubleshooting

**Can’t connect to DB**

* Make sure you’re **inside** the dev container
* Use `PGHOST=db` (not `localhost`)

**`init.sql` didn’t run**

* You likely reused an old volume; reset with `down -v` (see above) and bring it back up

**Extensions missing in container**

* Install them **in** the container: Dev Containers → *Install Local Extensions in Container*

**Git identity missing in container**

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

---

## Why this setup works (mental model)

* **Two containers:** `db` (Postgres) and `dev` (your workstation)
* **Same network:** the dev box reaches Postgres at host **`db`**
* **Persistence:** named volume keeps your data between restarts
* **Reproducible:** `init.sql` seeds the same data on fresh start
* **Portable:** everyone gets the same toolchain and env via Dev Containers

---

## Appendix: Example commands for grading

Run all practice queries and save outputs in one go:

```bash
mkdir -p results
psql -h db -U vscode -d duke_restaurants -f Q1.sql -o results/Q1.txt
psql -h db -U vscode -d duke_restaurants -f Q2.sql -o results/Q2.txt
psql -h db -U vscode -d duke_restaurants -f Q3.sql -o results/Q3.txt
psql -h db -U vscode -d duke_restaurants -f Q4.sql -o results/Q4.txt
```

That’s all! Open this folder in VS Code, `Reopen in Container`, and you’re ready to query :)


---

## Author
Freddy Platinus  
Master of Engineering in Financial Technology, Duke University
