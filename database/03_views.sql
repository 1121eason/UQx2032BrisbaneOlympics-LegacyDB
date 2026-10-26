-- Portfolio execution copy derived from the submitted MySQL 8 backup.
-- Views execute with the invoking user; no root@localhost definer is retained.
USE olympicdb;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW energyconsumptiondetail AS
SELECT
    er.readingTimestamp,
    v.villageId,
    v.villageName,
    b.buildingId,
    b.buildingName,
    em.energyMeterId,
    em.meterCode,
    em.meterStatus,
    es.energySourceId,
    es.sourceName,
    es.isRenewable,
    COALESCE(er.energyConsumedKwh, 0) AS energyConsumedKwh,
    er.carbonIntensity,
    COALESCE(er.energyConsumedKwh, 0) * COALESCE(er.carbonIntensity, 0) AS carbonImpact
FROM energyreading er
JOIN energymeter em
    ON er.energyMeterId = em.energyMeterId
JOIN building b
    ON em.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
JOIN energysource es
    ON em.energySourceId = es.energySourceId;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW wastedetail AS
SELECT
    'General' AS wasteStream,
    wc.collectionTimestamp AS wasteDateTime,
    v.villageId,
    v.villageName,
    b.buildingId,
    b.buildingName,
    NULL AS clinicId,
    NULL AS polyclinicName,
    wt.wasteTypeId AS wasteCategoryId,
    wt.wasteTypeName AS wasteCategoryName,
    wt.wasteDescription AS wasteDescription,
    wc.quantityKg AS wasteKg
FROM wastecollection wc
JOIN building b
    ON wc.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
JOIN wastetype wt
    ON wc.wasteTypeId = wt.wasteTypeId

UNION ALL

SELECT
    'Medical' AS wasteStream,
    CAST(mwc.logDate AS DATETIME) AS wasteDateTime,
    v.villageId,
    v.villageName,
    b.buildingId,
    b.buildingName,
    c.clinicId,
    f.facilityName AS polyclinicName,
    mwt.medicalWasteTypeId AS wasteCategoryId,
    mwt.medicalWasteTypeName AS wasteCategoryName,
    mwt.medicalWasteDescription AS wasteDescription,
    mwc.weightKg AS wasteKg
FROM medicalwastecollection mwc
JOIN clinic c
    ON mwc.clinicId = c.clinicId
JOIN facility f
    ON c.facilityId = f.facilityId
JOIN building b
    ON f.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
JOIN medicalwastetype mwt
    ON mwc.medicalWasteTypeId = mwt.medicalWasteTypeId;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW assetdisposaldetail AS
SELECT
    a.assetId,
    a.assetName,
    a.sustainabilityRating,
    a.assetStatus,
    ac.categoryId,
    ac.categoryName,
    b.buildingId,
    b.buildingName,
    v.villageId,
    v.villageName,
    s.supplierId,
    s.supplierName,
    ad.disposalId,
    ad.disposalDate,
    LOWER(ad.disposalType) AS rawDisposalType,
    CASE
        WHEN LOWER(ad.disposalType) = 'recycling' THEN 'Recycling'
        WHEN LOWER(ad.disposalType) = 'donation' THEN 'Donation'
        WHEN LOWER(ad.disposalType) IN ('resale', 'resell', 'resold') THEN 'Resell'
        ELSE 'No disposal plan'
    END AS disposalMethod,
    ad.disposalNote
FROM asset a
JOIN assetcategory ac
    ON a.categoryId = ac.categoryId
JOIN building b
    ON a.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
JOIN supplier s
    ON a.supplierId = s.supplierId
LEFT JOIN assetdisposal ad
    ON a.assetId = ad.assetId;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW localemployabilitydetail AS
SELECT
    le.employmentId,
    le.jobTitle,
    le.isLocalResident,
    le.hireDate,
    le.employmentNotes,
    cp.conversionId,
    cp.originalUseType,
    cp.targetUseType,
    cp.startDate AS conversionStartDate,
    cp.endDate AS conversionEndDate,
    cp.conversionStatus,
    c.contractorId,
    c.contractorName,
    c.contractorType,
    b.buildingId,
    b.buildingName,
    v.villageId,
    v.villageName,
    ea.activityId,
    ea.activityDate,
    ea.activityType,
    ea.hours
FROM localemployment le
JOIN conversionproject cp
    ON le.projectId = cp.conversionId
JOIN contractor c
    ON cp.contractorId = c.contractorId
JOIN building b
    ON cp.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
LEFT JOIN employmentactivity ea
    ON le.employmentId = ea.employmentId;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW legacyimpactdashboard AS
SELECT
    cp.conversionId,
    cp.originalUseType,
    cp.targetUseType,
    cp.startDate,
    cp.endDate,
    cp.conversionStatus,

    v.villageId,
    v.villageName,
    b.buildingId,
    b.buildingName,
    b.energyRating,
    b.legacyUseType AS plannedLegacyUseType,

    c.contractorId,
    c.contractorName,
    c.contractorType,
    c.sustainabilityRating AS contractorSustainabilityRating,

    COALESCE(rs.roomCount, 0) AS convertedRoomCount,
    COALESCE(rs.roomCapacity, 0) AS convertedRoomCapacity,
    COALESCE(rs.accessibleRoomCount, 0) AS accessibleRoomCount,
    ROUND(
        COALESCE(rs.accessibleRoomCount, 0) * 100.0
        / NULLIF(rs.roomCount, 0),
        2
    ) AS accessibleRoomPercentage,

    COALESCE(es.totalEmployees, 0) AS totalEmployees,
    COALESCE(es.localEmployees, 0) AS localEmployees,
    ROUND(
        COALESCE(es.localEmployees, 0) * 100.0
        / NULLIF(es.totalEmployees, 0),
        2
    ) AS localEmployeePercentage,

    COALESCE(es.totalWorkHours, 0) AS totalWorkHours,
    COALESCE(es.localWorkHours, 0) AS localWorkHours,
    ROUND(
        COALESCE(es.localWorkHours, 0) * 100.0
        / NULLIF(es.totalWorkHours, 0),
        2
    ) AS localWorkHourPercentage,

    ROUND(
        (
            CASE b.energyRating
                WHEN 'A+' THEN 100
                WHEN 'A' THEN 90
                WHEN 'B' THEN 75
                WHEN 'C' THEN 60
                ELSE 40
            END
            +
            CASE c.sustainabilityRating
                WHEN 'A+' THEN 100
                WHEN 'A' THEN 90
                WHEN 'B' THEN 75
                WHEN 'C' THEN 60
                ELSE 40
            END
        ) / 2,
        2
    ) AS sustainabilityScore

FROM conversionproject cp
JOIN building b
    ON cp.buildingId = b.buildingId
JOIN village v
    ON b.villageId = v.villageId
JOIN contractor c
    ON cp.contractorId = c.contractorId

LEFT JOIN (
    SELECT
        buildingId,
        COUNT(roomId) AS roomCount,
        SUM(roomCapacity) AS roomCapacity,
        SUM(CASE WHEN isAccessible = 1 THEN 1 ELSE 0 END) AS accessibleRoomCount
    FROM room
    GROUP BY buildingId
) rs
    ON b.buildingId = rs.buildingId

LEFT JOIN (
    SELECT
        le.projectId AS conversionId,
        COUNT(DISTINCT le.employmentId) AS totalEmployees,
        COUNT(DISTINCT CASE
            WHEN le.isLocalResident = 1 THEN le.employmentId
        END) AS localEmployees,
        SUM(ea.hours) AS totalWorkHours,
        SUM(CASE
            WHEN le.isLocalResident = 1 THEN ea.hours
            ELSE 0
        END) AS localWorkHours
    FROM localemployment le
    LEFT JOIN employmentactivity ea
        ON le.employmentId = ea.employmentId
    GROUP BY le.projectId
) es
    ON cp.conversionId = es.conversionId;

