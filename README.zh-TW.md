# UQx2032BrisbaneOlympics-LegacyDB

**2032 Brisbane 奧運選手村與賽後轉型資料庫**

[English](README.md) · [專案介紹](docs/project-overview.md) · [資料模型](docs/data-model.md) · [資料字典](docs/data-dictionary.md) · [查詢說明](docs/query-guide.md)

這個專案以 **2032 Brisbane 奧運選手村**為情境，用關聯式資料庫串連「賽事期間的營運」與「賽後的永續轉型」。它是 UQ BISM7206 的團隊學術原型；案例經過教學簡化，並非奧運官方系統。

**41 張正式資料表｜46 個外鍵｜5 個 View｜6 組管理查詢｜3,681 筆示範資料**

## 專案在解決什麼問題？

奧運結束後，選手村的房間、建築和設備需要有下一個用途。這個資料庫讓管理者把賽事營運、能源與廢棄物、資產處置、承包商、住宅轉型及在地就業放在同一個資料架構中追蹤。

| 模組 | 可以管理的內容 |
| --- | --- |
| 人員與資格 | 選手、工作人員、NOC、角色及角色有效期間 |
| 基礎設施 | 選手村、建築、房間、住宿分配、設施與使用紀錄 |
| 永續監測 | 能源／用水讀數、碳強度、一般與醫療廢棄物 |
| 醫療營運 | 診所、醫療服務、專業人員、就診及參與人員 |
| 資產生命週期 | 供應商、設備、回收、捐贈及轉售紀錄 |
| 賽後轉型 | 承包商、轉型專案、工作項目及房間用途轉換 |
| 社會影響 | 在地聘用情況、工作活動與投入時數 |

## 六組 SQL 查詢

1. 找出期間內耗電最高的建築與選手村，並估算碳影響。
2. 找出一般及醫療廢棄物的主要來源。
3. 比較資產規劃中的回收、捐贈與轉售占比。
4. 分析有活動紀錄的人員中，在地就業人數與工時占比。
5. 比較已完成建築轉型所涵蓋的房間、容量與無障礙房間。
6. 以專案假設的權重，綜合比較永續、空間轉型和在地就業表現。

使用的 SQL 技術包含多表 JOIN、View、CTE、Window Functions、條件彙總、日期區間篩選及百分比計算。分數權重是示範設計，不能當成官方評分。Q5 的房間數來自整棟建築的既有房間，不能直接解讀為逐間驗收完成；Q6 有同分時可能超過十筆。

## 如何執行

建議使用 **MySQL 8.0 以上與 MySQL Workbench**。

1. 使用獨立、空白的示範資料庫環境。
2. 依序執行 `database/01_schema.sql`、`database/02_demo_data.sql`、`database/03_views.sql`。
3. 開啟 `queries/` 內的 SQL，執行需要的查詢。
4. 執行 `checks/01_foreign_keys.sql`，確認每個違規數為 0；另外查看資料品質檢查。

如果電腦有 Docker，也可以先複製 `.env.example` 為 `.env`、設定自己的本機密碼，再執行：

```bash
docker compose up -d --wait
python3 scripts/validate_mysql.py --docker
```

首次啟動會建立示範資料。已有資料的 Docker volume 不會重新匯入。對外 SQL 連線預設僅綁定本機 `127.0.0.1:3307`。

## 已完成的整理與驗證

原始備份被拆成結構、資料、View 和查詢；執行版本移除了多餘的試算表匯入表與原本的 `root@localhost` View 定義者。公開版本中的姓名、生日、醫療人員註冊號碼，以及供應商／承包商名稱與聯絡信箱，都已替換成示範值。原始檔保留在另外的完整整理包中。

**2026 年 10 月 26 日已通過 GitHub Actions 的 MySQL 8 驗證**：空白資料庫成功建立、41 張表的筆數符合預期、外鍵沒有孤立參照，六組 SQL 全部成功執行。[查看通過紀錄](https://github.com/1121eason/UQx2032BrisbaneOlympics-LegacyDB/actions/runs/40268596494)。

另外也完成 SQLite 轉換檢查，41 張表共載入 3,681 筆資料並產生九組結果。`evidence/` 的 CSV 明確標示為轉換檢查輸出；通過執行不代表所有管理假設已獲業務驗證。細節見 [驗證紀錄](evidence/README.md)。

兩個原始 `.mwb` 模型都有 40 張表，缺少備份中存在的 `roomconversion`。執行版本以資料庫備份為準；完整限制請見 [known-limitations.md](docs/known-limitations.md)。

## 你的作品集定位

專案名稱：**UQx2032BrisbaneOlympics-LegacyDB**。副標題可使用 **Olympic Village Database & Post-Games Transformation**。

這個作品展示你如何把營運、永續與賽後住宅轉型的需求，轉成資料模型、SQL 查詢與管理決策資訊。原始專案是團隊合作；報告紀錄中，Yi-Cheng Lee 的貢獻包含永續模組、整合 ERD 檢查、六組管理問題與 SQL、查詢解釋和最終 SQL 整合。

這個 GitHub 儲存庫是可公開展示的技術版本，包含資料庫、六組 SQL、資料模型、中英文說明與驗證工具。原始報告、Team Charter、未處理的備份與來源工作簿不包含在此公開版本；完整私人整理包另外保留。這是 UQ 課程團隊作品，不代表 UQ 或奧運官方合作。
