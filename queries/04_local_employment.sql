-- Q4: Local Employment
-- Reporting logic preserved from Q4.sql; view setup is in database/03_views.sql.
USE olympicdb;

SET @startDate = '2032-07-10';
SET @endDateExclusive = '2032-08-16';

SELECT
    COUNT(DISTINCT employmentId) AS totalEmployedPeople,
    COUNT(DISTINCT CASE
        WHEN isLocalResident = 1 THEN employmentId
    END) AS localEmployedPeople,
    COUNT(DISTINCT CASE
        WHEN isLocalResident = 0 THEN employmentId
    END) AS nonLocalEmployedPeople,
    ROUND(
        COUNT(DISTINCT CASE WHEN isLocalResident = 1 THEN employmentId END)
        * 100.0 / NULLIF(COUNT(DISTINCT employmentId), 0),
        2
    ) AS localEmploymentPercentage,
    ROUND(SUM(hours), 2) AS totalWorkHours,
    ROUND(SUM(CASE WHEN isLocalResident = 1 THEN hours ELSE 0 END), 2) AS localWorkHours,
    ROUND(
        SUM(CASE WHEN isLocalResident = 1 THEN hours ELSE 0 END)
        * 100.0 / NULLIF(SUM(hours), 0),
        2
    ) AS localWorkHourPercentage
FROM localemployabilitydetail
WHERE activityDate >= @startDate
  AND activityDate < @endDateExclusive;
