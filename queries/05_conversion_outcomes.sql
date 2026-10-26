-- Q5: Conversion Outcomes
-- Reporting logic preserved from Q5.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-09-01';
SET @endDateExclusive = '2033-08-01';

WITH latestcompletedconversion AS (
    SELECT
        cp.conversionId,
        cp.buildingId,
        cp.originalUseType,
        cp.targetUseType,
        cp.startDate,
        cp.endDate,
        cp.conversionStatus,
        ROW_NUMBER() OVER (
            PARTITION BY cp.buildingId
            ORDER BY cp.endDate DESC, cp.conversionId DESC
        ) AS conversionRank
    FROM conversionproject cp
    WHERE cp.conversionStatus = 'Completed'
      AND cp.endDate >= @startDate
      AND cp.endDate < @endDateExclusive
),

conversionoutcome AS (
    SELECT
        lcc.targetUseType AS legacyUseType,
        COUNT(DISTINCT b.buildingId) AS convertedBuildingCount,
        COUNT(DISTINCT r.roomId) AS convertedRoomCount,
        SUM(r.roomCapacity) AS convertedRoomCapacity,
        SUM(CASE WHEN r.isAccessible = 1 THEN 1 ELSE 0 END) AS accessibleRoomCount
    FROM latestcompletedconversion lcc
    JOIN building b
        ON lcc.buildingId = b.buildingId
    LEFT JOIN room r
        ON b.buildingId = r.buildingId
    WHERE lcc.conversionRank = 1
    GROUP BY
        lcc.targetUseType
),

totaloutcome AS (
    SELECT
        SUM(convertedBuildingCount) AS totalConvertedBuildings,
        SUM(convertedRoomCount) AS totalConvertedRooms,
        SUM(convertedRoomCapacity) AS totalConvertedCapacity,
        SUM(accessibleRoomCount) AS totalAccessibleRooms
    FROM conversionoutcome
)

SELECT
    co.legacyUseType,
    co.convertedBuildingCount,
    ROUND(
        co.convertedBuildingCount * 100.0 
        / NULLIF(t.totalConvertedBuildings, 0),
        2
    ) AS buildingPercentage,
    co.convertedRoomCount,
    ROUND(
        co.convertedRoomCount * 100.0 
        / NULLIF(t.totalConvertedRooms, 0),
        2
    ) AS roomPercentage,
    co.convertedRoomCapacity,
    ROUND(
        co.convertedRoomCapacity * 100.0 
        / NULLIF(t.totalConvertedCapacity, 0),
        2
    ) AS capacityPercentage,
    co.accessibleRoomCount,
    ROUND(
        co.accessibleRoomCount * 100.0 
        / NULLIF(t.totalAccessibleRooms, 0),
        2
    ) AS accessibleRoomPercentage
FROM conversionoutcome co
CROSS JOIN totaloutcome t
ORDER BY
    roomPercentage DESC,
    buildingPercentage DESC,
    co.legacyUseType;

SET @startDate = '2032-09-01';
SET @endDateExclusive = '2033-08-01';

WITH allusetype AS (
    SELECT DISTINCT
        targetUseType AS legacyUseType
    FROM conversionproject
    WHERE targetUseType IS NOT NULL
),

latestcompletedconversion AS (
    SELECT
        cp.conversionId,
        cp.buildingId,
        cp.originalUseType,
        cp.targetUseType,
        cp.startDate,
        cp.endDate,
        cp.conversionStatus,
        ROW_NUMBER() OVER (
            PARTITION BY cp.buildingId
            ORDER BY cp.endDate DESC, cp.conversionId DESC
        ) AS conversionRank
    FROM conversionproject cp
    WHERE cp.conversionStatus = 'Completed'
      AND cp.endDate >= @startDate
      AND cp.endDate < @endDateExclusive
),

conversionoutcome AS (
    SELECT
        lcc.targetUseType AS legacyUseType,
        COUNT(DISTINCT b.buildingId) AS convertedBuildingCount,
        COUNT(DISTINCT r.roomId) AS convertedRoomCount,
        COALESCE(SUM(r.roomCapacity), 0) AS convertedRoomCapacity,
        SUM(CASE WHEN r.isAccessible = 1 THEN 1 ELSE 0 END) AS accessibleRoomCount
    FROM latestcompletedconversion lcc
    JOIN building b
        ON lcc.buildingId = b.buildingId
    LEFT JOIN room r
        ON b.buildingId = r.buildingId
    WHERE lcc.conversionRank = 1
    GROUP BY
        lcc.targetUseType
),

finaloutcome AS (
    SELECT
        aut.legacyUseType,
        COALESCE(co.convertedBuildingCount, 0) AS convertedBuildingCount,
        COALESCE(co.convertedRoomCount, 0) AS convertedRoomCount,
        COALESCE(co.convertedRoomCapacity, 0) AS convertedRoomCapacity,
        COALESCE(co.accessibleRoomCount, 0) AS accessibleRoomCount
    FROM allusetype aut
    LEFT JOIN conversionoutcome co
        ON aut.legacyUseType = co.legacyUseType
),

totaloutcome AS (
    SELECT
        SUM(convertedBuildingCount) AS totalConvertedBuildings,
        SUM(convertedRoomCount) AS totalConvertedRooms,
        SUM(convertedRoomCapacity) AS totalConvertedCapacity,
        SUM(accessibleRoomCount) AS totalAccessibleRooms
    FROM finaloutcome
)

SELECT
    fo.legacyUseType,
    fo.convertedBuildingCount,
    ROUND(
        fo.convertedBuildingCount * 100.0 
        / NULLIF(t.totalConvertedBuildings, 0),
        2
    ) AS buildingPercentage,
    fo.convertedRoomCount,
    ROUND(
        fo.convertedRoomCount * 100.0 
        / NULLIF(t.totalConvertedRooms, 0),
        2
    ) AS roomPercentage,
    fo.convertedRoomCapacity,
    ROUND(
        fo.convertedRoomCapacity * 100.0 
        / NULLIF(t.totalConvertedCapacity, 0),
        2
    ) AS capacityPercentage,
    fo.accessibleRoomCount,
    ROUND(
        fo.accessibleRoomCount * 100.0 
        / NULLIF(t.totalAccessibleRooms, 0),
        2
    ) AS accessibleRoomPercentage
FROM finaloutcome fo
CROSS JOIN totaloutcome t
ORDER BY
    roomPercentage DESC,
    buildingPercentage DESC,
    fo.legacyUseType;




