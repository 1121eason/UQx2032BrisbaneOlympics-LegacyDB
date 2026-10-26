# Known limitations and reconciliation

## Source inconsistencies preserved for traceability

| Finding | Packaging treatment | Remaining implication |
| --- | --- | --- |
| Original backup has 42 tables including `untitled spreadsheet - role` | Excluded that import residue from the execution copy; original backup retained privately | Curated model has 41 domain tables |
| Both Workbench models have 40 tables and omit `roomconversion` | Preserved both structural versions; removed author identifiers; executable DDL and dictionary follow the backup | Workbench model is not an exact reverse-engineering of the execution schema |
| `roomconversion` has no demo rows | Preserved the empty table | No room-level transition evidence is available in this dataset |
| Backup views use a `root@localhost` definer | New setup creates views with `SQL SECURITY INVOKER` | Importing the original backup still retains its original assumptions |
| Standalone Q5 reports conversion outcomes; the report’s Q5 section shows dashboard SQL also used for Q6 | Used standalone query files for executable reporting; original PDF retained privately | Original PDF and runnable Q5 differ; do not present them as fully reconciled |
| Report cover spells the team Purple Chase; filenames use PurpleChess | Documented both | Preserve attribution without inventing a new team identity |
| Source report contains embedded cleaning SQL but some raw input tables/files are absent | Source archive and extraction retained privately; public processing summary supplied | A fully reproducible raw-to-clean pipeline cannot be claimed |

## Data and analytical assumptions

- The source report describes generated data and public reference information. It is not operational Brisbane 2032 data. Known personal/contact fields have been replaced in this public edition; all demonstration records remain non-operational.
- Referential integrity passed a portable check, but that does not establish business realism. For example, Q6 has many projects per building; joining room stock into every project repeats building-level capacity.
- Q3’s final result excludes assets without an in-period disposal record. Q4’s “people” counts are employment IDs with in-period activity. Q5 uses current building room stock. Q6’s scoring and tie handling are assumptions, not official standards. See the query guide.
- Datetimes are stored without a timezone attribute. The original export sets its session timezone to UTC, but that does not prove source event timestamps represent UTC. Agree a timezone and carbon-intensity unit before real deployment.
- Fields use free text for several categories and statuses. The schema does not enforce every normalisation, validation, security or workflow statement in the report.

## Operational work still required

A production implementation would need defined application access roles, consent and data-retention rules, clinical data separation, audited access, validation of quantities and date ranges, occupancy/overlap rules, tested backups, migrations, ingestion interfaces and monitoring. None is implied by storing the corresponding data in this prototype.

MySQL runtime checks and Docker startup could not be executed in the preparation environment. The included CI workflow has not yet run here. Verify it after pushing to GitHub before claiming a passing MySQL build.
