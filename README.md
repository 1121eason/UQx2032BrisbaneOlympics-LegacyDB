# UQx2032BrisbaneOlympics-LegacyDB

**SQL Database Development & Business Analytics**

Building relational databases and using SQL to answer operational, sustainability and asset-management questions.

[繁體中文](README.zh-TW.md) · [SQL skills and code evidence](docs/sql-skills.md) · [Business case studies](docs/business-case-studies.md) · [DB / Data Analyst positioning](docs/career-positioning.md)

This portfolio demonstrates how I use SQL to structure business data, integrate related entities and turn management questions into analytical queries. Developed as a UQ BISM7206 team project, it models Brisbane 2032 Olympic Village operations and post-Games transformation. The scenario and dataset are academic simulations of real-world business problems.

**41 domain tables · 46 foreign-key constraints · 5 reporting views · 6 analytical query files · 3,681 demo records**

My documented contributions focus on the sustainability data model, integrated ERD reviews, six management questions and SQL reports, and final SQL integration. The wider schema is a team deliverable. [Contribution details](docs/contributions.md) distinguish original team work from later AI-assisted portfolio preparation.

## Skills demonstrated

| Capability | Implementation | Evidence |
| --- | --- | --- |
| Build a relational database with SQL | `CREATE DATABASE`, `CREATE TABLE`, data types, primary/composite keys, foreign keys and unique constraints | [Schema SQL](database/01_schema.sql), [data model](docs/data-model.md) |
| Integrate business data | Related people, infrastructure, medical, environmental, asset and conversion entities; reference and junction tables | [Data dictionary](docs/data-dictionary.md), [Workbench models](models/) |
| Prepare reporting datasets | Five views combining records across modules, with explicit reporting dates and grain | [View definitions](database/03_views.sql) |
| Write analytical SQL | Multi-table joins, CTEs, conditional aggregation, `UNION ALL`, `ROW_NUMBER`, `DENSE_RANK`, percentages and protected division | [Six SQL reports](queries/), [SQL walkthrough](docs/sql-skills.md) |
| Check data integrity and metric definitions | Orphan-reference checks, row-count checks, date/quantity review, denominator and duplicate-counting interpretation | [Checks](checks/), [query guide](docs/query-guide.md) |
| Connect analysis to business decisions | Resource-demand prioritisation, asset planning gaps, workforce participation and conversion oversight | [Business case studies](docs/business-case-studies.md) |

**For SQL / Database Developer reviewers:** start with the [schema](database/01_schema.sql), [design walkthrough](docs/sql-skills.md) and [integrity checks](checks/01_foreign_keys.sql).

**For Data Analyst reviewers:** start with the [business cases](docs/business-case-studies.md), [six reports](queries/) and [metric interpretation](docs/query-guide.md).

## Business problems addressed with SQL

| Business problem | SQL approach | Decision the output can inform |
| --- | --- | --- |
| Which buildings and villages should receive an energy-use review first? | Join readings, meters, sources and locations; aggregate by reporting period and rank totals | Prioritise investigation of high-demand sites, then check occupancy and usage context — [Q1](queries/01_energy_consumption.sql) |
| Where are waste-handling requirements concentrated? | Combine general and medical streams with `UNION ALL`, then aggregate and rank | Review collection capacity and specialist handling at hotspots — [Q2](queries/02_waste_compliance.sql) |
| How are assets planned for reuse, and where are disposal records missing? | Select the latest in-period disposal record per asset; separately check missing records with `NOT EXISTS` | Assign follow-up for missing plans and coordinate recycling, donation and resale — [Q3](queries/03_asset_disposal.sql), [gap check](checks/02_quality_review.sql) |
| What share of recorded work is associated with local employment? | Distinct employment-record counts, conditional work-hour sums and protected percentages | Support community-benefit reporting with an explicit denominator — [Q4](queries/04_local_employment.sql) |
| Which completed building conversions are associated with each legacy use? | Select the latest completed conversion per building and aggregate associated room stock | Review target-use distribution and request room-level completion evidence — [Q5](queries/05_conversion_outcomes.sql) |
| How can several legacy indicators be compared together? | Pre-aggregate measures, apply illustrative weights and rank projects | Provide a discussion aid for project review and sensitivity analysis — [Q6](queries/06_legacy_impact_ranking.sql) |

## Example findings and next decisions

All figures below describe the demonstration dataset. The numerical CSV examples come from the labelled SQLite-adapted check; the MySQL CI run separately verified import, counts, integrity and execution of all six reports.

| Example finding | Business interpretation | Proposed next action |
| --- | --- | --- |
| Building B has the highest energy total: **3,029.41 kWh** for 18–27 July 2032 | A site to investigate; total consumption alone does not establish inefficiency | Review operating hours, occupancy and meter coverage before proposing interventions |
| **42 of 100 assets have no disposal record**, an all-time record-coverage gap of **42%** | The disposal-method distribution alone does not describe planning completeness | Produce an asset follow-up list and confirm the intended destination and owner |
| Local employment records account for **80%** of active employment records and **79.85%** of recorded hours for 10 July–15 August 2032 | Participation is broadly aligned across record counts and work hours in the sample | Agree the reporting target and verify whether employment records represent unique people |

These are analytical findings and proposed actions, not measured cost savings, emissions reductions or implemented business outcomes. [Read the cases, calculations and limitations](docs/business-case-studies.md).

## Reproduce the database and queries

Use **MySQL 8.0+**. The SQL uses CTEs and window functions.

### MySQL Workbench

1. Use a dedicated, empty demo environment.
2. Execute [01_schema.sql](database/01_schema.sql), [02_demo_data.sql](database/02_demo_data.sql) and [03_views.sql](database/03_views.sql), in that order.
3. Open a file in [queries/](queries/) and execute its reporting statements.
4. Run the [foreign-key checks](checks/01_foreign_keys.sql) and review the [quality checks](checks/02_quality_review.sql).

The scripts create `olympicdb`; use an isolated demo environment rather than an existing operational database.

### Docker Compose

```bash
cp .env.example .env
# Replace the local password placeholder in .env before starting.
docker compose up -d --wait
python3 scripts/validate_mysql.py --docker
```

The first launch imports the three setup files into an empty persistent volume. Existing volumes are not automatically reinitialized. The SQL port binds to `127.0.0.1:3307` by default. For an existing MySQL client, configure `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER` and `MYSQL_PWD`, then run `python3 scripts/validate_mysql.py`.

## Validation evidence

**MySQL 8 integration passed on GitHub Actions on 26 October 2026.** A fresh database initialized successfully, the expected counts for all 41 tables matched, no orphan foreign-key references were found, and all six reporting files executed. [Passing run](https://github.com/1121eason/UQx2032BrisbaneOlympics-LegacyDB/actions/runs/40268596494) · [Machine-readable record](evidence/mysql-validation.json).

The separate portable check loaded 3,681 records and produced nine result sets. Its CSV files are labelled as SQLite-adapted outputs in [evidence/](evidence/README.md). Passing execution establishes technical reproducibility for the tested dataset; it does not establish the validity of every business assumption.

## Design, scope and attribution

[Data model](docs/data-model.md) · [Data dictionary](docs/data-dictionary.md) · [Processing history](docs/data-processing.md) · [Known limitations](docs/known-limitations.md) · [Source provenance](docs/provenance.md)

![Historical team EER diagram](docs/images/original-erd.png)

The historical diagram and both supplied Workbench models contain 40 tables and omit `roomconversion`, which is present in the 41-table execution schema. Q3's final disposal summary excludes assets with no in-period plan; Q4 counts employment records rather than proven unique individuals; Q5 uses building room stock; Q6 uses illustrative weights and retains tied ranks. These interpretations are documented in the [query guide](docs/query-guide.md).

Original team: **Purple Chase (T1G2)** — Chieh-Yu Liu, Yi-Cheng Lee, Ziqi Huang and Yi-Cong Zhu. Supplied source filenames use `PurpleChess`. The project is an academic prototype, with no official UQ/Olympic partnership implied. This evidence supports SQL database-development and analytical-reporting skills; production administration, recovery testing, performance benchmarks and a deployed BI/application interface are outside the delivered scope.

Known person/contact fields have been replaced with demo placeholders in this public edition. Original reports, the charter, raw workbooks and unmodified backups are kept separately. No new licence is granted for team-owned work. [Publication notes](docs/publication.md).
