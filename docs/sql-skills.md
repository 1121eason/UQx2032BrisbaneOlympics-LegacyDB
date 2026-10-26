# SQL skills and implementation evidence

This guide connects SQL database-development and analytical skills to the actual files in the repository. The project is collaborative: Eason Li's documented original contributions include sustainability modelling, schema integration/review and the six management-oriented reporting queries. The full schema is a team deliverable.

## 1. Create a database and its relational structure

[database/01_schema.sql](../database/01_schema.sql) creates `olympicdb` and 41 domain tables. It defines column types, nullability, primary keys, composite keys, unique constraints, indexes and foreign-key relationships.

The following is an excerpt of the actual `energyreading` definition:

```sql
CREATE TABLE `energyreading` (
  `readingTimestamp` datetime NOT NULL,
  `energyMeterId` int NOT NULL,
  `energyConsumedKwh` decimal(12,2) DEFAULT NULL,
  `carbonIntensity` decimal(8,4) DEFAULT NULL,
  PRIMARY KEY (`readingTimestamp`,`energyMeterId`),
  KEY `fk_energyreading_energymeter` (`energyMeterId`),
  CONSTRAINT `fk_energyreading_energymeter`
    FOREIGN KEY (`energyMeterId`) REFERENCES `energymeter` (`energyMeterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Business reasoning:** a measurement belongs to a particular meter at a particular time. The composite primary key prevents two rows using the same meter/timestamp combination. The foreign key ties a reading to a registered meter, which connects it to a building and source. This protects the meaning of downstream energy totals.

## 2. Represent relationships and reduce repeated reference data

| Design choice | Actual examples | What it supports |
| --- | --- | --- |
| Reference entities | `energysource`, `watersource`, `wastetype`, `medicalspecialty`, `country` | Reuse consistent category/source definitions rather than repeat them on every event |
| Parent-child relationships | `village` → `building` → `room` | Locate operational records consistently within the village structure |
| Junction tables | `clinicservice`, `encounterservice`, `encounterstaff` | Represent multiple services/staff associated with a clinic or encounter |
| Composite keys | Meter/time readings and clinic/service pairs | Encode a meaningful combination rather than rely only on an artificial row ID |
| Cross-module links | Building-linked assets and conversion projects | Connect operational activity with post-Games outcomes |

The [generated data dictionary](data-dictionary.md) records the actual implemented constraints. Design separation supports normalisation; it does not imply that every business rule or all report claims are enforced by the schema.

## 3. Load demonstration data and prepare reusable reporting views

[database/02_demo_data.sql](../database/02_demo_data.sql) loads 3,681 demonstration records. Known person/contact fields have been replaced for the public version. [database/03_views.sql](../database/03_views.sql) defines five reusable reporting views.

| View | Data combined |
| --- | --- |
| `energyconsumptiondetail` | Energy readings, meters, sources, buildings and villages |
| `wastedetail` | General waste and medical waste, linked to locations and categories |
| `assetdisposaldetail` | Assets, suppliers, categories, locations and disposal records |
| `localemployabilitydetail` | Employment records, activities, conversion projects and contractors |
| `legacyimpactdashboard` | Project context, building room stock and pre-aggregated employment measures |

These views provide reusable query logic. Their names describe SQL views, not a deployed graphical dashboard. Setup uses `SQL SECURITY INVOKER` and does not carry over the original backup's `root@localhost` definer.

## 4. Write analytical SQL

| SQL technique | Concrete use | Code reference |
| --- | --- | --- |
| Multi-table `JOIN` | Connect events to their business context | [View definitions](../database/03_views.sql) |
| `LEFT JOIN` | Keep assets even when no disposal record matches in the detail view | Asset disposal view; [Q3](../queries/03_asset_disposal.sql) |
| `WITH` / CTEs | Separate filtering, aggregation, scoring and ranking into readable steps | [Q1](../queries/01_energy_consumption.sql), [Q6](../queries/06_legacy_impact_ranking.sql) |
| `SUM`, `COUNT`, `GROUP BY` | Calculate energy, waste, headcount-proxy and work-hour measures | [Q1–Q6](../queries/) |
| `CASE WHEN` | Separate local/non-local participation and waste streams | [Q2](../queries/02_waste_compliance.sql), [Q4](../queries/04_local_employment.sql) |
| `UNION ALL` | Combine two waste streams without silently removing equal-valued events | [Waste view](../database/03_views.sql) |
| `ROW_NUMBER` | Select the latest in-period asset plan or completed building conversion | [Q3](../queries/03_asset_disposal.sql), [Q5](../queries/05_conversion_outcomes.sql) |
| `DENSE_RANK` | Rank totals/scores while preserving ties | [Q1](../queries/01_energy_consumption.sql), [Q6](../queries/06_legacy_impact_ranking.sql) |
| Windowed totals | Calculate disposal-method shares over the result population | [Q3](../queries/03_asset_disposal.sql) |
| Half-open date windows | Include a start date and exclude the next period's first timestamp | [Reporting SQL](../queries/) |
| `COALESCE` / `NULLIF` | Handle missing values and protect percentage calculations from zero denominators | [Q4](../queries/04_local_employment.sql), [Q5](../queries/05_conversion_outcomes.sql) |
| `NOT EXISTS` | Find assets without a disposal record and orphan foreign-key references | [Quality checks](../checks/02_quality_review.sql), [foreign-key checks](../checks/01_foreign_keys.sql) |

Selecting a latest record is not just a syntax exercise. Q3 partitions by `assetId` and orders by disposal date and ID. Filtering dates before that window function means “latest record within this period,” not necessarily “latest record overall.” The distinction changes the business question.

## 5. Validate relationships and review data quality

The bootstrap temporarily disables foreign-key checking to handle dependencies during import and restores its session setting afterwards. A successful import alone does not establish that pre-existing data is valid. The repository therefore runs explicit orphan-reference checks after loading.

- [checks/01_foreign_keys.sql](../checks/01_foreign_keys.sql) checks all 46 foreign-key relationships.
- [checks/02_quality_review.sql](../checks/02_quality_review.sql) reviews missing disposal records, invalid quantities/flags and date ordering.
- [scripts/validate_mysql.py](../scripts/validate_mysql.py) checks expected row counts, referential integrity and execution of all six query files.

The recorded [MySQL 8 integration run](https://github.com/1121eason/UQx2032BrisbaneOlympics-LegacyDB/actions/runs/40268596494) passed. Its result demonstrates execution and tested integrity, while [business interpretation](business-case-studies.md) establishes what each metric can support.

## 6. Explain the boundaries of the evidence

The DDL includes indexes associated with relationships; the repository does not contain a measured performance-tuning study. It also does not demonstrate backup/recovery drills, replication, production availability management or a deployed BI interface. The strongest demonstrated scope is **SQL database development, relational integration, analytical reporting and data-quality reasoning**.
