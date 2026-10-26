# Source provenance and public transformations

The academic source package contained a 115-page team report, a MySQL 8 database backup, two Workbench models and six standalone query files. Duplicate PDFs/ZIPs and macOS metadata were de-duplicated during organization. The original report and charter are retained separately rather than published here.

| Public component | Source / transformation |
| --- | --- |
| `database/01_schema.sql` | 41 domain-table definitions from the submitted backup; excluded one spreadsheet import residue table |
| `database/02_demo_data.sql` | Final academic test data with known person/contact fields replaced; relationships and operational metrics retained |
| `database/03_views.sql` | Views from Q1, Q2, Q3, Q4 and Q6; moved into setup and set to `SQL SECURITY INVOKER` |
| `queries/01_*.sql`–`06_*.sql` | Original standalone reporting logic, with view definitions moved into setup |
| `models/*.mwb` | Historical structures; author identifiers removed and model lock entries excluded |
| `docs/images/original-erd.png` | Rendered diagram from the team report; historical structure, with no student cover information |
| `docs/data-dictionary.md` and `docs/schema-metadata.json` | Generated directly from the executable schema |
| `scripts/`, `checks/`, `compose.yaml` and CI | New portfolio preparation and validation support |

## Public demonstration identities

Person names are `DemoGiven<personId>` / `DemoFamily<personId>` and birth dates are artificial. Medical registration numbers use `DEMO-REG-<personId>`. Supplier/contractor names use `Demo Supplier` / `Demo Contractor`, and their emails use `example.com`.

These changes preserve table counts, key relationships and the analytical metrics used by the supplied queries. The dataset is for an academic fictional/test scenario and must not be described as actual Olympic operational, medical, financial or environmental records. Public NOC/country lookup data remains reference information.

No raw data-cleansing pipeline is claimed to be reproducible from the public repository: some original staging inputs and standalone historical scripts were not supplied. The final database and its six reports can be initialized and validated using the supplied setup.
