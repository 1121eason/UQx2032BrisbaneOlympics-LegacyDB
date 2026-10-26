-- Q6: Legacy Impact Ranking
-- Reporting logic preserved from Q6.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-09-01';
SET @endDateExclusive = '2033-08-01';

WITH scopedproject AS (
    SELECT
        *
    FROM legacyimpactdashboard
    WHERE startDate < @endDateExclusive
      AND endDate >= @startDate
),

basescore AS (
    SELECT
        scopedproject.*,

        CASE conversionStatus
            WHEN 'Completed' THEN 100
            WHEN 'In Progress' THEN 65
            WHEN 'Planned' THEN 35
            WHEN 'Delayed' THEN 10
            ELSE 20
        END AS conversionStatusScore,

        MAX(convertedRoomCapacity) OVER () AS maxConvertedRoomCapacity

    FROM scopedproject
),

dimensionscore AS (
    SELECT
        basescore.*,

        sustainabilityScore AS sustainabilityDimensionScore,

        ROUND(
            conversionStatusScore * 0.50
            +
            (
                convertedRoomCapacity * 100.0
                / NULLIF(maxConvertedRoomCapacity, 0)
            ) * 0.30
            +
            COALESCE(accessibleRoomPercentage, 0) * 0.20,
            2
        ) AS roomConversionDimensionScore,

        ROUND(
            COALESCE(localEmployeePercentage, 0) * 0.50
            +
            COALESCE(localWorkHourPercentage, 0) * 0.50,
            2
        ) AS localEmploymentDimensionScore

    FROM basescore
),

overallscore AS (
    SELECT
        dimensionscore.*,

        ROUND(
            sustainabilityDimensionScore * 0.35
            +
            roomConversionDimensionScore * 0.35
            +
            localEmploymentDimensionScore * 0.30,
            2
        ) AS overallLegacyImpactScore

    FROM dimensionscore
),

rankedproject AS (
    SELECT
        overallscore.*,
        DENSE_RANK() OVER (
            ORDER BY overallLegacyImpactScore DESC
        ) AS overallRank
    FROM overallscore
)

SELECT
    overallRank,
    conversionId,
    villageName,
    buildingName,
    CONCAT(originalUseType, ' → ', targetUseType) AS conversionOutcome,
    conversionStatus,
    contractorName,

    sustainabilityDimensionScore,
    roomConversionDimensionScore,
    localEmploymentDimensionScore,
    overallLegacyImpactScore,

    convertedRoomCount,
    convertedRoomCapacity,
    accessibleRoomCount,
    accessibleRoomPercentage,

    totalEmployees,
    localEmployees,
    localEmployeePercentage,
    totalWorkHours,
    localWorkHours,
    localWorkHourPercentage

FROM rankedproject
WHERE overallRank <= 10
ORDER BY
    overallRank,
    overallLegacyImpactScore DESC,
    conversionId;
