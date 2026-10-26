# Query guide and interpretation

The reporting logic in the six supplied `Q*.sql` files is preserved. View definitions were extracted into `database/03_views.sql`; setup is run once before the reporting files. All windows use an inclusive start and exclusive end unless noted otherwise.

| File | Default period | Result sets | Interpretation |
| --- | --- | --- | --- |
| Q1 | 18–27 July 2032 | Highest building; highest village | Energy use and calculated carbon impact; all ties at rank one remain |
| Q2 | 18–27 July 2032 | Highest total-waste building; highest clinical-waste clinic | General and medical streams are kept distinct in the view, then aggregated |
| Q3 | September–November 2032 | Disposal-method summary | Latest disposal record **within the selected period** for each asset with such a record |
| Q4 | 10 July–15 August 2032 | Employment and hours summary | Employment IDs with activity records in the period, not all hired people |
| Q5 | September 2032–July 2033 | Observed completed outcomes; zero-inclusive target types | Latest completed conversion in the period per building, joined to current room stock |
| Q6 | Projects overlapping September 2032–July 2033 | Ranked projects | Illustrative weighted score over all projects with ranks one through ten |

## Q1: Energy and carbon

The `energyconsumptiondetail` view connects readings → meters → buildings → villages and energy sources. Carbon impact is `energyConsumedKwh * carbonIntensity` summed over readings. Its units are inherited from the source intensity field; the repository does not independently establish a kg/t conversion. The original query treats missing quantities or intensities as zero via `COALESCE`, which can understate totals. Energy quantity is treated as interval consumption, not a cumulative meter reading. Counts are data-coverage indicators rather than proof of comparable monitoring duration.

## Q2: Waste

`wastedetail` combines general and medical waste using `UNION ALL`. The general-waste result includes medical waste in the building total; the clinic result filters to medical waste. A category name is not necessarily a globally unique key across both streams, so `COUNT(DISTINCT wasteCategoryName)` may merge equally named categories. The reports flag hotspots; they do not implement regulated-waste chain-of-custody compliance.

## Q3: Asset disposal

The view uses a left join so unplanned assets can appear in detail, but the report CTE filters to non-null disposal IDs inside the date range. Consequently, the final output does **not** count every asset with no plan. `checks/02_quality_review.sql` includes a separate all-time no-disposal-record count; that count has a different scope from a missing-plan-in-period metric.

`ROW_NUMBER` chooses the latest date and disposal ID per asset **after** period filtering. This is not the same as finding the latest plan overall and then checking its period. The category label `Resell` preserves the original normalisation rules.

## Q4: Employment

The activity-date condition removes employment records without a matching in-period activity. Counts therefore describe employment records that participated in recorded activity. `employmentId` is not linked to a unique `personId`, so the alias `totalEmployedPeople` cannot prove unique individual headcount across multiple employment records. The default dates are during the Games even though the narrative discusses conversion work; change the dates deliberately for a post-Games analysis.

## Q5: Conversion outcomes

The first statement returns observed completed target uses; the second includes every target use recorded anywhere in `conversionproject`, with zero counts where none completed in the selected period. These are deliberate preserved alternatives, not separate business questions.

The room counts, capacity and accessibility come from the `room` table for a building with a selected completed project. They do not use `roomconversion` and do not prove each room was converted or inspected. In the source backup, `roomconversion` contains no demo rows. Percentages represent a share of totals across result categories; `accessibleRoomPercentage` in Q5 is a share of all counted accessible rooms, not the within-category accessibility rate.

## Q6: Composite score

The model uses these original assumptions:

| Dimension | Internal formula | Overall weight |
| --- | --- | --- |
| Sustainability | Mean of building energy-rating points and contractor sustainability-rating points | 35% |
| Room conversion | Status points × 50% + capacity normalised to the largest scoped project × 30% + accessibility rate × 20% | 35% |
| Local employment | Local employment-record percentage × 50% + local work-hour percentage × 50% | 30% |

Rating points are A+=100, A=90, B=75, C=60, otherwise 40. Status points are Completed=100, In Progress=65, Planned=35, Delayed=10, otherwise 20. These weights and mappings are illustrative assumptions. They are not official IOC criteria or measured carbon reductions.

The scope selects projects by overlapping project dates, while the view aggregates all recorded employment activities for each project; it does not restrict activity dates to the reporting window. Room stock is repeated per project for buildings with multiple projects and must not be summed across rows as unique converted capacity. `DENSE_RANK <= 10` retains ties: the packaged demo returns **70 rows** in the portable check, not ten. This behaviour is preserved and documented.

## Checking results

`evidence/*.csv` comes from the SQLite-adapted smoke check. Run `scripts/validate_mysql.py` against the MySQL demo database to verify actual MySQL execution. A successful execution is not by itself business validation of a metric, a model assumption, or a causal sustainability outcome.
