# Business problems, SQL analysis and decisions

The project uses an academic simulation of Olympic Village operations. The business problems also occur in property/facilities management, asset-intensive operations and workforce reporting. No real client implementation, financial saving or environmental improvement is claimed.

Each case distinguishes the question, metric, SQL approach, observed sample result, proposed action and limitations. Numerical examples come from the repository's labelled SQLite-adapted CSVs unless explicitly linked to the MySQL validation record. The MySQL run separately confirms successful import, row counts, referential integrity and execution of the six original reports.

## Case 1 — Prioritise an energy-use investigation

**Business situation.** A facilities manager has several sites and limited time for energy reviews. A useful first step is to identify where recorded demand is highest and then investigate why.

**Question and metric.** Which building and village recorded the highest total consumption during 18–27 July 2032? Sum interval energy consumption in kWh by building/village, with a separate quantity × carbon-intensity calculation. Do not assume a kg/t carbon unit beyond the source definition.

**SQL approach.** [The energy view](../database/03_views.sql) links readings to meters, sources and locations. [Q1](../queries/01_energy_consumption.sql) uses an inclusive-start/exclusive-end date filter, CTEs, `SUM`, `GROUP BY` and `DENSE_RANK` to retain all highest-ranked ties.

| Sample finding | Evidence |
| --- | --- |
| Building B in Gold Coast Athletes Village has the highest building total: **3,029.41 kWh** | [Building output](../evidence/01_energy_consumption_result_1.csv) |
| Gold Coast Athletes Village has the highest village total: **5,777.04 kWh** | [Village output](../evidence/01_energy_consumption_result_2.csv) |

**Proposed decision.** Prioritise these locations for a meter/operations review. Check occupancy, operating hours, floor area, service mix and reading coverage before attributing the total to inefficient equipment or behaviour.

**Analytical judgement.** Highest consumption is not the same as lowest efficiency. A larger or more heavily used site may legitimately consume more. The existing query identifies investigation candidates; it does not calculate energy intensity or prove the cause of consumption.

**Transferable application.** A similar data pattern can support energy-review prioritisation across an office, accommodation, campus or retail portfolio after the relevant denominators and operating context are supplied.

## Case 2 — Expose asset-planning gaps before disposal

**Business situation.** An operations or procurement manager needs to prepare assets for their next use. A chart of recycling/donation/resale proportions can look complete even when some assets have no recorded destination.

**Question and metrics.** How are assets with in-period plans distributed across disposal methods, and what share of all assets has no disposal record at all? These are different populations and should be reported separately.

**SQL approach.** [Q3](../queries/03_asset_disposal.sql) uses a left-joined detail view, category standardisation and `ROW_NUMBER` to choose the latest in-period record per asset. The separate `NOT EXISTS` check in [quality review SQL](../checks/02_quality_review.sql) finds assets with no matching disposal row across all dates.

| Metric | Sample result | Scope / evidence |
| --- | --- | --- |
| Asset inventory | **100 assets** | [Recorded asset count](../evidence/portable-validation.json) |
| Assets with no disposal record | **42 assets** | All-time absence; [MySQL quality result](../evidence/mysql-validation.json) |
| Record-coverage gap | **42 / 100 × 100 = 42%** | Derived from the inventory and all-time absence count |
| Assets with at least one disposal record | **100 − 42 = 58 assets** | All-time record coverage; not proof of plan approval/completion |
| Latest in-period method summary | Recycling **21**; resale **19**; donation **18** | September–November 2032; [Q3 output](../evidence/03_asset_disposal_result_1.csv) |

**Proposed decision.** Create a follow-up queue for the 42 assets, confirm the responsible business owner and intended destination, and coordinate the next actions with procurement or logistics. This is a proposed workflow; the repository does not implement task assignment.

**Analytical judgement.** Q3's final summary excludes assets without an in-period plan. The separate all-time absence check exposes a gap that percentages within the planned population cannot reveal. In this sample, the in-period method counts also sum to 58; that numerical agreement does not make in-period coverage and all-time coverage interchangeable in general. A recorded disposal event also does not establish legal approval, collection or completed recycling.

**Transferable application.** The same SQL pattern can identify equipment without return arrangements, inventory without a recorded disposition, or records missing a required follow-up event after the business rules are defined.

## Case 3 — Report local workforce participation with a defensible denominator

**Business situation.** A programme manager needs evidence of local participation. Counting people and summing work hours answer related but different questions; repeated activity rows can inflate counts if the SQL grain is wrong.

**Question and metrics.** For 10 July–15 August 2032, what share of employment records with activity is local, and what share of recorded hours belongs to those local records?

**SQL approach.** [Q4](../queries/04_local_employment.sql) uses `COUNT(DISTINCT employmentId)` to avoid multiplying record counts across activity rows, `CASE` for local/non-local categories, `SUM` for hours and `NULLIF` for safe percentage denominators.

| Metric | Sample result |
| --- | --- |
| Active employment records / local records | **100 / 80** |
| Local record share | **80 / 100 × 100 = 80%** |
| Total recorded hours / local hours | **796.5 / 636.0 hours** |
| Local work-hour share | **636.0 / 796.5 × 100 = 79.85%** |

Source: [Q4 output](../evidence/04_local_employment_result_1.csv).

**Proposed decision.** Present both participation measures to programme management, agree a target before judging performance, and verify identity linkage and activity completeness before using them in a formal community-benefit report.

**Analytical judgement.** `employmentId` does not prove a unique individual across multiple employment records. Filtering on activity dates excludes employment records without in-period activity. The existing default window is during the Games; a conversion-phase question needs an explicitly chosen post-Games period. No local-benefit target, net new job count or causal impact is established by this query.

**Transferable application.** This distinction also matters in staffing, training and supplier-participation reports, where counts, hours and unique people must not be treated as the same measure.

## Additional decision-support questions

| Report | Business decision it can inform | What must be checked before acting |
| --- | --- | --- |
| [Q2 — Waste](../queries/02_waste_compliance.sql) | Review collection capacity and regulated-waste handling at high-volume sites | Waste definitions, reading/collection coverage and compliance evidence beyond weight totals |
| [Q5 — Conversion](../queries/05_conversion_outcomes.sql) | Review legacy-use distribution and request completion evidence | Counts use current room stock for selected building conversions, not verified room-level completion |
| [Q6 — Composite score](../queries/06_legacy_impact_ranking.sql) | Compare several dimensions in a project-review discussion | Weights are assumptions; test sensitivity, retain tied ranks deliberately and avoid summing repeated building capacity across projects |

The professional analytical contribution is the combination of **a relevant question, reproducible SQL, an explicit metric population and a decision proportionate to the evidence**. Implementation of the proposed actions and measurement of subsequent outcomes remain future work.
