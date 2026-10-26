# Validation evidence

Prepared on **26 October 2026 (Australia/Brisbane)**.

| Check | Result | Scope |
| --- | --- | --- |
| Provenance | Public transformation notes in `docs/provenance.md` | Original private sources are stored separately; known identity/contact fields replaced |
| Execution schema | 41 domain tables; 46 foreign-key constraints | Parsed from the MySQL backup, excluding one spreadsheet import residue table |
| Demo data import | 3,681 rows loaded | Adapted SQLite schema including primary keys, unique constraints and foreign keys |
| Referential integrity | Zero orphan foreign-key references | SQLite `PRAGMA foreign_key_check` after import |
| Reporting execution | Six SQL reporting files; nine result sets | Adapted SQLite execution |
| MySQL 8 runtime | **Passed on GitHub Actions** | Fresh import, expected counts for all 41 tables, zero orphan references and six reporting files executed |
| GitHub CI | **Success — run 40268596494** | Verified code/data commit `9eaaa728b09a13fda9ac74ab03ced4d88bf6b063` |

`portable-validation.json` stores exact table row counts, result-set sizes and dialect adaptations. The CSV files contain outputs from the **portable check**, not screenshots or exports of a MySQL run. Q6 has 70 returned rows because `DENSE_RANK <= 10` retains ties; this is not a 70-project cutoff.

The separate [MySQL validation record](mysql-validation.json) links to the [successful run](https://github.com/1121eason/UQx2032BrisbaneOlympics-LegacyDB/actions/runs/40268596494). Its job logs confirm the database initialized successfully, all six query files executed, and every referential-integrity check passed. The quality review found 42 demo assets with no disposal record; this is a planning-gap finding, not an orphan-reference failure. The remaining printed quality-review counts were zero.

## Reproduce the portable check

```bash
python3 scripts/validate_portable.py
```

Uses Python’s standard library. It creates an in-memory database and overwrites only the generated evidence JSON/CSV outputs. MySQL session variables are substituted with their date literals, MySQL-specific DDL/index syntax is adapted, `CONCAT` is registered, and medical-waste date casting uses SQLite `datetime`. Collation, numeric rounding, strict SQL modes, privilege behaviour and query plans can differ from MySQL.

## Run the actual MySQL check

Follow the root README’s MySQL setup and run `python3 scripts/validate_mysql.py --docker` or configure the MySQL client environment and omit `--docker`. This checks the expected row counts, all generated orphan-reference tests, execution of the six reporting files, and prints quality-review counts. It does not establish that the query assumptions are appropriate for a real Olympic programme.
