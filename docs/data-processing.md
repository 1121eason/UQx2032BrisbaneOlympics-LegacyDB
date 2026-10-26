# Data processing history

The original report documents the cleaning of inconsistent text, dates, locations, reference data and cross-module IDs, plus test-data generation. This public package retains the database structure and a demonstration data copy with known identity/contact fields replaced. It does not reconstruct missing scripts or invent historical raw inputs.

| Module | Documented processing | Available evidence |
| --- | --- | --- |
| Infrastructure | Split location fields, trim text, standardise room capacity and accessibility, review postcodes and ratings | Report pages 39–40 and 71–76; final SQL tables |
| People/accreditation | Standardise text and gender labels, review dates and duplicates, handle missing NOC values | Report pages 76–78; final people/reference tables |
| Medical | Clean and normalise clinic/staff/encounter examples, align staff and service references, generate test rows | Report pages 35–38 and 42–60; final medical tables |
| Asset lifecycle | Generate supplementary supplier, asset and disposal test records | Report pages 60–71; final asset tables |
| Sustainability and integration | Align building/clinic references and populate monitoring records for query testing | Report’s cleaning narrative and final monitoring tables |

The report appendix contains SQL embedded in a PDF, including destructive development statements and references to staging tables. Its page-numbered text extraction is retained in the separate private source package. It is not a supported import script; extraction can alter symbols and whitespace.

The supplied `Polyclinic V1.xlsx` is retained in the private source package. The public database setup uses the prepared demonstration export instead of rerunning incomplete historical staging scripts.

For this public version, `scripts/anonymize_demo.py` replaced all person names and dates of birth, medical registration numbers, supplier/contractor names and contact email fields. It preserves foreign-key IDs, row counts and operational test metrics. It is specific to this schema and is not a universal anonymization tool. Reapplying it to a copy of the public demo data is deterministic.

For a future reproducible ETL pipeline, supply all original CSV/workbook inputs and original script files, define correction rules and units, and compare the regenerated tables with the final backup. Do not silently turn ad hoc source corrections into general business rules.
