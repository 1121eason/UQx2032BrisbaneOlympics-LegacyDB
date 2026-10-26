-- Q3: Asset Disposal
-- Reporting logic preserved from Q3.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-09-01';
SET @endDateExclusive = '2032-12-01';

WITH latestplan AS (
    SELECT
        assetId,
        assetName,
        categoryId,
        categoryName,
        villageId,
        villageName,
        buildingId,
        buildingName,
        disposalMethod,
        disposalDate,
        ROW_NUMBER() OVER (
            PARTITION BY assetId
            ORDER BY disposalDate DESC, disposalId DESC
        ) AS planRank
    FROM assetdisposaldetail
    WHERE disposalId IS NOT NULL
      AND disposalDate >= @startDate
      AND disposalDate < @endDateExclusive
),
methodsummary AS (
    SELECT
        disposalMethod,
        COUNT(*) AS plannedAssetCount,
        COUNT(DISTINCT categoryId) AS affectedCategoryCount,
        COUNT(DISTINCT villageId) AS affectedVillageCount,
        COUNT(DISTINCT buildingId) AS affectedBuildingCount,
        MIN(disposalDate) AS firstPlannedDate,
        MAX(disposalDate) AS latestPlannedDate
    FROM latestplan
    WHERE planRank = 1
    GROUP BY disposalMethod
),
rankedmethod AS (
    SELECT
        methodsummary.*,
        ROUND(
            plannedAssetCount * 100.0 / SUM(plannedAssetCount) OVER (),
            2
        ) AS percentageOfPlannedAssets,
        DENSE_RANK() OVER (
            ORDER BY plannedAssetCount DESC
        ) AS disposalRank
    FROM methodsummary
)
SELECT
    disposalRank,
    disposalMethod,
    plannedAssetCount,
    percentageOfPlannedAssets,
    affectedCategoryCount,
    affectedVillageCount,
    affectedBuildingCount,
    firstPlannedDate,
    latestPlannedDate
FROM rankedmethod
ORDER BY disposalRank, disposalMethod;
