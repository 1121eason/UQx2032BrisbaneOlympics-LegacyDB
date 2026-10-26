-- Q1: Energy Consumption
-- Reporting logic preserved from Q1.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-07-18 00:00:00';
SET @endDateExclusive = '2032-07-28 00:00:00';

WITH buildingenergy AS (
    SELECT
        villageId,
        villageName,
        buildingId,
        buildingName,
        SUM(energyConsumedKwh) AS totalEnergyKwh,
        SUM(carbonImpact) AS totalCarbonImpact,
        COUNT(*) AS readingCount,
        COUNT(DISTINCT energyMeterId) AS meterCount
    FROM energyconsumptiondetail
    WHERE readingTimestamp >= @startDate
      AND readingTimestamp < @endDateExclusive
    GROUP BY
        villageId,
        villageName,
        buildingId,
        buildingName
),
rankedbuilding AS (
    SELECT
        buildingenergy.*,
        DENSE_RANK() OVER (
            ORDER BY totalEnergyKwh DESC
        ) AS energyRank
    FROM buildingenergy
)
SELECT
    energyRank,
    villageName,
    buildingId,
    buildingName,
    ROUND(totalEnergyKwh, 2) AS totalEnergyKwh,
    ROUND(totalCarbonImpact, 2) AS totalCarbonImpact,
    meterCount,
    readingCount
FROM rankedbuilding
WHERE energyRank = 1
ORDER BY totalEnergyKwh DESC;

SET @startDate = '2032-07-18 00:00:00';
SET @endDateExclusive = '2032-07-28 00:00:00';

WITH villageenergy AS (
    SELECT
        villageId,
        villageName,
        COUNT(DISTINCT buildingId) AS buildingCount,
        COUNT(DISTINCT energyMeterId) AS meterCount,
        SUM(energyConsumedKwh) AS totalEnergyKwh,
        SUM(carbonImpact) AS totalCarbonImpact,
        COUNT(*) AS readingCount
    FROM energyconsumptiondetail
    WHERE readingTimestamp >= @startDate
      AND readingTimestamp < @endDateExclusive
    GROUP BY
        villageId,
        villageName
),
rankedvillage AS (
    SELECT
        villageenergy.*,
        DENSE_RANK() OVER (
            ORDER BY totalEnergyKwh DESC
        ) AS energyRank
    FROM villageenergy
)
SELECT
    energyRank,
    villageId,
    villageName,
    ROUND(totalEnergyKwh, 2) AS totalEnergyKwh,
    ROUND(totalCarbonImpact, 2) AS totalCarbonImpact,
    buildingCount,
    meterCount,
    readingCount
FROM rankedvillage
WHERE energyRank = 1
ORDER BY totalEnergyKwh DESC;
