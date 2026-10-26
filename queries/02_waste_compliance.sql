-- Q2: Waste Compliance
-- Reporting logic preserved from Q2.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-07-18 00:00:00';
SET @endDateExclusive = '2032-07-28 00:00:00';

WITH buildingwaste AS (
    SELECT
        villageId,
        villageName,
        buildingId,
        buildingName,
        SUM(wasteKg) AS totalWasteKg,
        SUM(CASE WHEN wasteStream = 'General' THEN wasteKg ELSE 0 END) AS generalWasteKg,
        SUM(CASE WHEN wasteStream = 'Medical' THEN wasteKg ELSE 0 END) AS medicalWasteKg,
        COUNT(*) AS wasteRecordCount,
        COUNT(DISTINCT wasteCategoryName) AS wasteCategoryCount
    FROM wastedetail
    WHERE wasteDateTime >= @startDate
      AND wasteDateTime < @endDateExclusive
    GROUP BY
        villageId,
        villageName,
        buildingId,
        buildingName
),
rankedbuilding AS (
    SELECT
        buildingwaste.*,
        DENSE_RANK() OVER (
            ORDER BY totalWasteKg DESC
        ) AS wasteRank
    FROM buildingwaste
)
SELECT
    wasteRank,
    villageName,
    buildingId,
    buildingName,
    ROUND(totalWasteKg, 2) AS totalWasteKg,
    ROUND(generalWasteKg, 2) AS generalWasteKg,
    ROUND(medicalWasteKg, 2) AS medicalWasteKg,
    wasteCategoryCount,
    wasteRecordCount
FROM rankedbuilding
WHERE wasteRank = 1
ORDER BY totalWasteKg DESC;

SET @startDate = '2032-07-18 00:00:00';
SET @endDateExclusive = '2032-07-28 00:00:00';

WITH polyclinicwaste AS (
    SELECT
        villageId,
        villageName,
        buildingId,
        buildingName,
        clinicId,
        polyclinicName,
        SUM(wasteKg) AS totalMedicalWasteKg,
        COUNT(*) AS medicalWasteRecordCount,
        COUNT(DISTINCT wasteCategoryName) AS medicalWasteCategoryCount
    FROM wastedetail
    WHERE wasteStream = 'Medical'
      AND wasteDateTime >= @startDate
      AND wasteDateTime < @endDateExclusive
    GROUP BY
        villageId,
        villageName,
        buildingId,
        buildingName,
        clinicId,
        polyclinicName
),
rankedpolyclinic AS (
    SELECT
        polyclinicwaste.*,
        DENSE_RANK() OVER (
            ORDER BY totalMedicalWasteKg DESC
        ) AS wasteRank
    FROM polyclinicwaste
)
SELECT
    wasteRank,
    villageName,
    buildingName,
    clinicId,
    polyclinicName,
    ROUND(totalMedicalWasteKg, 2) AS totalMedicalWasteKg,
    medicalWasteCategoryCount,
    medicalWasteRecordCount
FROM rankedpolyclinic
WHERE wasteRank = 1
ORDER BY totalMedicalWasteKg DESC;
