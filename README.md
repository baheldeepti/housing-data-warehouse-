# 🏡 Nashville Housing Data Warehouse

> Turning CSV chaos into a clean, story‑driven analytics platform.

---

## 📖 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Tech Stack](#tech-stack)
4. [Quick Start](#quick-start)
5. [Data Model](#data-model)
6. [Usage Examples](#usage-examples)
7. [Contributing](#contributing)
8. [License](#license)
9. [Acknowledgments](#acknowledgments)

---

## Project Overview

Nashville’s open‑data portal publishes property and housing records as ad‑hoc CSV exports.  Analysts had to wrestle with messy files, inconsistent headers, and missing keys before any insight work could begin.

This repository **automates the entire journey** from raw CSVs to a governed star‑schema warehouse, complete with CI tests and documentation.  The goal: *insight in minutes, not days.*

<p align="center">
  <img src="docs/img/etl_flow.png" width="650" alt="ETL Flow diagram"/>
</p>

---

## Architecture

```text
┌────────────┐   scrape + ingest   ┌──────────────┐
│  GitHub CI │ ───────────────────▶│   Object     │
│  Actions    │                    │   Storage    │
└────────────┘                    └──────────────┘
        │ build + push                        │
        ▼                                      ▼
┌────────────────────────────────────────────────────┐
│                    Docker Compose                 │
│  • Postgres  • pgAdmin  • dbt  • Data Ingester    │
└────────────────────────────────────────────────────┘
        │          transform + test
        ▼
┌──────────────┐     modeled tables     ┌────────────┐
│   Raw Schema │ ───────────────────────▶│ Analytics  │
└──────────────┘                        │  Schema    │
                                        └────────────┘
```

* **Ingestion**: Python ingester fetches weekly CSV drops and stages them in Postgres.
* **Transformation**: `dbt` builds incremental models, applies tests, and generates docs.
* **Orchestration**: GitHub Actions triggers CI on pull‑request; local dev via `docker‑compose`.

---

## Tech Stack

| Layer             | Tool / Lib        | Purpose                            |
| ----------------- | ----------------- | ---------------------------------- |
| **Storage**       | Postgres 16       | Column‑friendly OLTP/OLAP hybrid   |
| **Transform**     | dbt Core v1.10    | SQL‑centric modeling & testing     |
| **Compute**       | Docker Compose    | Reproducible local dev environment |
| **Orchestration** | GitHub Actions    | CI/CD, linting, model tests        |
| **Visualization** | Power BI (sample) | Dashboards on star schema          |

---

## Quick Start

```bash
# 1️⃣  Clone
$ git clone https://github.com/<your-org>/nashville-data-warehouse.git
$ cd nashville-data-warehouse

# 2️⃣  Spin up the stack (detached)
$ docker compose up -d

# 3️⃣  Seed sample CSVs
$ docker compose exec ingester python ingest.py --run-once

# 4️⃣  Run dbt models + tests
$ docker compose exec dbt_runner dbt build --targets dev

# 5️⃣  Open pgAdmin → explore 🏡
```

ℹ️  *Default credentials: `postgres / postgres` (change in `.env`).*

---

## Data Model

The warehouse follows a **star schema** centered on property sales.

```text
             dim_date
                ↑
 dim_property ← fct_property_sale → dim_owner
                ↓
            dim_location
```

See [`models/core/`](models/core/) for the SQL that builds each table.

---

## Usage Examples

```sql
-- Total sales volume by year
SELECT d.year,
       SUM(f.sale_price) AS total_sales
FROM fct_property_sale f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;
```

More examples live in [`analysis/queries/`](analysis/queries).

---

## Contributing

1. **Fork** the repo & create a feature branch.
2. Run `pre-commit` hooks (`black`, `sqlfmt`).
3. Open a PR; GitHub Actions will run unit & model tests.
4. After review, squash & merge.

---


## Acknowledgments

* 🗺 Original CSV dataset from [Nashville Open Data Portal](https://data.nashville.gov/).
* 🎨 Diagram style inspired by [dbdiagram.io](https://dbdiagram.io/).
* 🙏 Hat tip to the **dbt**, **Postgres**, and **Docker** communities for rock‑solid tooling.

---

<p align="center">
  <sub>Made with ❤️  by Deepti Bahel & contributors</sub>
</p>
# housing-data-warehouse-
