# UQx2032BrisbaneOlympics-LegacyDB

**SQL 資料庫開發 × 商業資料分析**

用 SQL 建立關聯式資料庫，將營運、永續與資產管理問題轉成分析查詢及決策資訊。

[English](README.md) · [SQL 技術與程式證據](docs/sql-skills.md) · [商業案例分析](docs/business-case-studies.md) · [DB／DA 求職定位](docs/career-positioning.md)

這個作品展示我如何用 SQL 組織商業資料、串連不同模組，並把管理問題轉成可執行的查詢。專案以 Brisbane 2032 奧運選手村與賽後轉型為情境，是 UQ BISM7206 的團隊學術專案，使用模擬資料處理具有實務意義的商業問題。

**41 張正式資料表｜46 個外鍵關係｜5 個 View｜6 組分析查詢｜3,681 筆示範資料**

我在原始專案中的貢獻包含永續模組、整合 ERD 檢查、六組管理問題與 SQL，以及最終 SQL 整合。完整資料模型屬於團隊成果；後續文件、執行包裝與驗證工具的 AI 協作也有另外標示。[查看貢獻說明](docs/contributions.md)。

## 這份作品展示的能力

| 能力 | 具體實作 | 可以查看的證據 |
| --- | --- | --- |
| 用 SQL 建立資料庫 | 建立資料庫與資料表，設定欄位型別、主鍵、複合鍵、外鍵及唯一限制 | [建表 SQL](database/01_schema.sql) |
| 設計與串連商業資料 | 整合人員、建築、醫療、能源、資產及轉型專案資料 | [資料模型](docs/data-model.md)、[資料字典](docs/data-dictionary.md) |
| 建立可重複使用的查詢入口 | 使用 View 整合跨表資料，定義分析的日期範圍與資料粒度 | [View SQL](database/03_views.sql) |
| 撰寫分析查詢 | JOIN、CTE、條件彙總、UNION ALL、ROW_NUMBER、DENSE_RANK 及比例計算 | [六組 SQL](queries/)、[技術解說](docs/sql-skills.md) |
| 檢查資料可信度 | 檢查孤立參照、資料筆數、日期順序、異常數值及統計分母 | [檢查 SQL](checks/)、[查詢解讀](docs/query-guide.md) |
| 用分析支援商業判斷 | 把查詢結果轉成問題定位、原因調查與行動建議 | [商業案例](docs/business-case-studies.md) |

**DB／SQL Developer 方向：**先看建表、資料關係、鍵值限制、View 與資料完整性。

**Data Analyst 方向：**先看問題定義、資料整合、指標計算、分析發現與決策建議。

## 用 SQL 處理的商業問題

| 商業問題 | SQL 處理方式 | 可以支援的決策 |
| --- | --- | --- |
| 哪些建築需要優先調查耗電？ | 串連讀數、電表與地點，依期間彙總和排名 | 排定能源調查優先順序；再結合入住率和營運時數判斷 — [Q1](queries/01_energy_consumption.sql) |
| 廢棄物處理需求集中在哪裡？ | 整合一般與醫療廢棄物，分類彙總與排名 | 檢視清運量能與專業處理需求 — [Q2](queries/02_waste_compliance.sql) |
| 資產準備如何再利用？哪些缺乏紀錄？ | 比較每個資產期間內最新處置安排，另外檢查缺少紀錄的資產 | 安排回收、捐贈、轉售及缺漏追蹤 — [Q3](queries/03_asset_disposal.sql) |
| 在地就業參與程度有多少？ | 分別計算有效活動中的聘用紀錄比例和工時比例 | 支援社區效益報告，並釐清統計分母 — [Q4](queries/04_local_employment.sql) |
| 建築轉型後對應哪些用途？ | 選出每棟建築期間內最新完成的轉型，彙總相關房間存量 | 檢視用途分布並要求房間層級驗收證據 — [Q5](queries/05_conversion_outcomes.sql) |
| 如何綜合比較轉型專案？ | 整合指標、套用示範權重並排名 | 提供專案討論依據，再測試不同權重 — [Q6](queries/06_legacy_impact_ranking.sql) |

## 具體分析發現

以下數字來自模擬資料。CSV 數值取自已標示的 SQLite 轉換檢查；MySQL 8 另已通過建庫、筆數、外鍵與六組查詢的執行驗證。

- **能源管理：**2032/7/18–7/27，Building B 的用電總量最高，為 **3,029.41 kWh**。這能協助排定調查順序；判斷是否浪費能源，仍需入住率、面積或營運時數。
- **資產規劃：**100 個資產中有 **42 個沒有任何處置紀錄，缺漏比例為 42%**。這個全期間檢查能找出規劃缺口；後續可確認負責人與資產去向。
- **在地就業：**2032/7/10–8/15，有活動紀錄的聘用資料中，在地紀錄占 **80%**，在地工時占 **79.85%**。這是紀錄與工時的分析，不能直接當成不重複的真實人數。

這些是分析結果與建議，沒有宣稱已替企業節省成本或降低排放。完整的「商業問題 → 指標 → SQL → 發現 → 建議 → 限制」見 [商業案例文件](docs/business-case-studies.md)。

## 如何操作

使用 **MySQL 8.0 以上與 MySQL Workbench**，在獨立、空白的示範環境依序執行：

1. [01_schema.sql](database/01_schema.sql)：建立資料庫與資料表。
2. [02_demo_data.sql](database/02_demo_data.sql)：匯入示範資料。
3. [03_views.sql](database/03_views.sql)：建立分析 View。
4. 開啟 [queries/](queries/) 的 SQL 執行查詢，再執行 [checks/](checks/) 檢查。

如果有 Docker，可先複製 `.env.example` 為 `.env`，設定自己的本機密碼，再執行：

```bash
docker compose up -d --wait
python3 scripts/validate_mysql.py --docker
```

首次啟動會匯入示範資料，已有資料的 volume 不會自動重建；預設連線位置是本機 `127.0.0.1:3307`。資料庫名稱為 `olympicdb`。

## 已驗證與仍需注意的地方

**2026/10/26 已通過 GitHub Actions 的 MySQL 8 驗證：**空白建庫、41 張表筆數、外鍵參照及六組 SQL 執行均成功。[查看通過紀錄](https://github.com/1121eason/UQx2032BrisbaneOlympics-LegacyDB/actions/runs/40268596494) · [驗證文件](evidence/README.md)。

兩版歷史 Workbench 模型有 40 張表，缺少執行版本中的 `roomconversion`。Q5 的房間數來自建築房間存量，不能直接當成逐間改建完成；Q6 是示範評分，同分時會多於十筆。這些限制已寫入 [查詢解讀](docs/query-guide.md) 與 [限制說明](docs/known-limitations.md)。

原始團隊為 **Purple Chase（T1G2）**：Chieh-Yu Liu、Yi-Cheng Lee、Ziqi Huang、Yi-Cong Zhu。這是課程作品，沒有 UQ／奧運官方合作的含意。作品展示 SQL 資料庫開發與分析能力；正式維運、備份還原演練、效能基準及 BI／應用程式介面不在目前交付範圍。

公開版本已替換已辨識到的身分與聯絡欄位，原始報告、Team Charter、工作簿與未處理備份另行保留。[來源說明](docs/provenance.md) · [資料字典](docs/data-dictionary.md) · [公開範圍](docs/publication.md)。
