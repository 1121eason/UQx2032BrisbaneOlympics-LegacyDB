# Portfolio positioning for SQL / Database Developer and Data Analyst roles

## Core message

> I use SQL to build relational databases, integrate business data and develop analytical queries that support operational decisions. In this team project, my work focused on sustainability modelling, schema integration and six management-oriented SQL reports covering resource use, asset planning, workforce participation and post-Games transformation.

The project supplies technical evidence for this message. It uses an academic simulation of real-world business problems; it should be described as a portfolio/team project rather than professional employment or an official Olympic implementation.

## Two ways to present the same evidence

| Dimension | SQL / Database Developer emphasis | Data Analyst emphasis |
| --- | --- | --- |
| Starting problem | How should the business data be structured and connected? | What business decision needs a better evidence base? |
| Main evidence | DDL, data types, keys, junction/reference tables, views and cross-module integration | Question definition, joins, aggregation, time windows, ranking, percentages and interpretation |
| Quality reasoning | Prevent invalid relationships and check imported data | Check population, denominators, missing records and duplicate counting |
| Concrete demonstration | Build `olympicdb`, explain the meter/timestamp composite key and run integrity checks | Run Q1/Q3/Q4, explain a sample finding and propose a bounded next action |
| Best reading path | [SQL skills](sql-skills.md) → [schema](../database/01_schema.sql) → [checks](../checks/) | [Business cases](business-case-studies.md) → [queries](../queries/) → [interpretation](query-guide.md) |

The demonstrated database scope is SQL development and relational reporting. Production DBA operations, backup/recovery, replication and measured performance tuning need separate evidence. The Data Analyst evidence is SQL analysis and decision communication; the repository does not contain a deployed BI dashboard or causal-impact study.

## English project description

**UQx2032BrisbaneOlympics-LegacyDB — SQL Database Development & Business Analytics**

Developed within a UQ team project modelling Olympic Village operations and post-Games transformation. The project integrates 41 MySQL tables and 46 foreign-key relationships with six SQL reports for energy, waste, asset lifecycle, workforce participation and conversion oversight. My documented contributions include sustainability modelling, integrated schema reviews, management-question design, SQL query development and final SQL integration.

## Resume wording supported by the source project

### SQL / Database Developer version

- Contributed to the design and integration of a 41-table MySQL database covering village operations, sustainability and asset lifecycle, including sustainability modelling and cross-module ERD reviews.
- Developed six management-oriented SQL reports using reusable views, multi-table joins, CTEs, window functions and conditional aggregation; integrated reporting logic across operational and legacy-planning entities.

### Data Analyst version

- Translated operational and sustainability questions into six SQL reports covering energy demand, waste generation, asset disposal, local employment and building conversion.
- Used joins, CTEs, window functions and percentage calculations to summarise resource use, compare asset-disposal methods and analyse local participation, with explicit reporting periods and metric definitions.

These statements describe the original documented responsibilities. The 41-table/46-relationship figures are project-level scope, not a claim of sole authorship. The later repository validation passed MySQL 8, but the automated packaging, public identity replacement and validation tooling were prepared with AI assistance and should not be presented as independently authored original coursework.

## 中文介紹方式

> 我能使用 SQL 建立關聯式資料庫、串連不同業務資料，並將商業問題轉成可執行的分析查詢。在這個團隊專案中，我負責永續資料模型、整合 ERD 檢查、六組管理分析查詢與最終 SQL 整合，涵蓋能源、廢棄物、資產再利用、在地就業及賽後轉型。

若強調 DB 方向，接著展示主鍵／複合鍵、外鍵、參照表、View 和資料完整性；若強調 DA 方向，接著說明商業問題、指標分母、查詢結果、建議行動與分析限制。

## Interview walkthrough

1. **Explain the business setting.** A short-lived village operation must also plan the future use of buildings and equipment.
2. **Show how data is structured.** Open `energyreading`; explain why a meter/timestamp combination is a key and how readings connect to buildings.
3. **Run a business query.** Show Q1's period-based aggregation and ranking, or Q3's latest-record selection.
4. **Interpret rather than repeat numbers.** For the public demo, explain why 42 missing disposal records create a follow-up question, or why 80% local employment records is not automatically 80 unique people.
5. **Show verification and boundaries.** Open the passing MySQL run, distinguish execution from business validation, and identify the additional data needed before making an operational commitment.

Useful follow-up discussion includes index/plan measurement, migration practices, unique-person linkage and the effect of different reporting windows. Those are extensions to investigate, not completed features claimed by this repository.
