USE olympicdb;
-- Each row reports the number of orphan references. Every count must be zero.
SELECT 'fk_asset_building' AS check_name, COUNT(*) AS violations FROM `asset` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_asset_category' AS check_name, COUNT(*) AS violations FROM `asset` c WHERE c.`categoryId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `assetcategory` p WHERE p.`categoryId` = c.`categoryId`)
UNION ALL
SELECT 'fk_asset_supplier' AS check_name, COUNT(*) AS violations FROM `asset` c WHERE c.`supplierId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `supplier` p WHERE p.`supplierId` = c.`supplierId`)
UNION ALL
SELECT 'fk_assetdisposal_asset' AS check_name, COUNT(*) AS violations FROM `assetdisposal` c WHERE c.`assetId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `asset` p WHERE p.`assetId` = c.`assetId`)
UNION ALL
SELECT 'fk_building_village' AS check_name, COUNT(*) AS violations FROM `building` c WHERE c.`villageId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `village` p WHERE p.`villageId` = c.`villageId`)
UNION ALL
SELECT 'fk_clinic_facility' AS check_name, COUNT(*) AS violations FROM `clinic` c WHERE c.`facilityId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `facility` p WHERE p.`facilityId` = c.`facilityId`)
UNION ALL
SELECT 'fk_clinicservice_clinic' AS check_name, COUNT(*) AS violations FROM `clinicservice` c WHERE c.`clinicId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `clinic` p WHERE p.`clinicId` = c.`clinicId`)
UNION ALL
SELECT 'fk_clinicservice_service' AS check_name, COUNT(*) AS violations FROM `clinicservice` c WHERE c.`serviceId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `clinicalservice` p WHERE p.`serviceId` = c.`serviceId`)
UNION ALL
SELECT 'fk_conversionproject_building' AS check_name, COUNT(*) AS violations FROM `conversionproject` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_conversionproject_contractor' AS check_name, COUNT(*) AS violations FROM `conversionproject` c WHERE c.`contractorId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `contractor` p WHERE p.`contractorId` = c.`contractorId`)
UNION ALL
SELECT 'fk_conversiontask_conversionproject' AS check_name, COUNT(*) AS violations FROM `conversiontask` c WHERE c.`conversionId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `conversionproject` p WHERE p.`conversionId` = c.`conversionId`)
UNION ALL
SELECT 'fk_employmentActivity_localEmployment1' AS check_name, COUNT(*) AS violations FROM `employmentactivity` c WHERE c.`employmentId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `localemployment` p WHERE p.`employmentId` = c.`employmentId`)
UNION ALL
SELECT 'fk_encounter_casemanager' AS check_name, COUNT(*) AS violations FROM `encounter` c WHERE c.`caseManagerId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `medicalstaff` p WHERE p.`staffCode` = c.`caseManagerId`)
UNION ALL
SELECT 'fk_encounter_clinic' AS check_name, COUNT(*) AS violations FROM `encounter` c WHERE c.`clinicId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `clinic` p WHERE p.`clinicId` = c.`clinicId`)
UNION ALL
SELECT 'fk_encounter_person' AS check_name, COUNT(*) AS violations FROM `encounter` c WHERE c.`personId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`personId` = c.`personId`)
UNION ALL
SELECT 'fk_encounterservice_encounter' AS check_name, COUNT(*) AS violations FROM `encounterservice` c WHERE c.`encounterId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `encounter` p WHERE p.`encounterId` = c.`encounterId`)
UNION ALL
SELECT 'fk_encounterservice_service' AS check_name, COUNT(*) AS violations FROM `encounterservice` c WHERE c.`serviceId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `clinicalservice` p WHERE p.`serviceId` = c.`serviceId`)
UNION ALL
SELECT 'fk_encounterstaff_encounter' AS check_name, COUNT(*) AS violations FROM `encounterstaff` c WHERE c.`encounterId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `encounter` p WHERE p.`encounterId` = c.`encounterId`)
UNION ALL
SELECT 'fk_encounterstaff_staff' AS check_name, COUNT(*) AS violations FROM `encounterstaff` c WHERE c.`staffCode` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `medicalstaff` p WHERE p.`staffCode` = c.`staffCode`)
UNION ALL
SELECT 'fk_energymeter_building' AS check_name, COUNT(*) AS violations FROM `energymeter` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_energymeter_energysource' AS check_name, COUNT(*) AS violations FROM `energymeter` c WHERE c.`energySourceId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `energysource` p WHERE p.`energySourceId` = c.`energySourceId`)
UNION ALL
SELECT 'fk_energyreading_energymeter' AS check_name, COUNT(*) AS violations FROM `energyreading` c WHERE c.`energyMeterId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `energymeter` p WHERE p.`energyMeterId` = c.`energyMeterId`)
UNION ALL
SELECT 'fk_facility_building' AS check_name, COUNT(*) AS violations FROM `facility` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_facilityusage_facility' AS check_name, COUNT(*) AS violations FROM `facilityusage` c WHERE c.`facilityId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `facility` p WHERE p.`facilityId` = c.`facilityId`)
UNION ALL
SELECT 'fk_facilityusage_person' AS check_name, COUNT(*) AS violations FROM `facilityusage` c WHERE c.`personId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`personId` = c.`personId`)
UNION ALL
SELECT 'fk_localEmployment_conversionProject1' AS check_name, COUNT(*) AS violations FROM `localemployment` c WHERE c.`projectId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `conversionproject` p WHERE p.`conversionId` = c.`projectId`)
UNION ALL
SELECT 'fk_medicalstaff_person' AS check_name, COUNT(*) AS violations FROM `medicalstaff` c WHERE c.`personId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`personId` = c.`personId`)
UNION ALL
SELECT 'fk_medicalstaff_specialty' AS check_name, COUNT(*) AS violations FROM `medicalstaff` c WHERE c.`specialtyId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `medicalspecialty` p WHERE p.`specialtyId` = c.`specialtyId`)
UNION ALL
SELECT 'fk_medicalwastecollection_clinic' AS check_name, COUNT(*) AS violations FROM `medicalwastecollection` c WHERE c.`clinicId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `clinic` p WHERE p.`clinicId` = c.`clinicId`)
UNION ALL
SELECT 'fk_medicalwastecollection_type' AS check_name, COUNT(*) AS violations FROM `medicalwastecollection` c WHERE c.`medicalWasteTypeId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `medicalwastetype` p WHERE p.`medicalWasteTypeId` = c.`medicalWasteTypeId`)
UNION ALL
SELECT 'fk_noc_country' AS check_name, COUNT(*) AS violations FROM `noc` c WHERE c.`countryCode` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `country` p WHERE p.`countryCode` = c.`countryCode`)
UNION ALL
SELECT 'fk_person_grouping' AS check_name, COUNT(*) AS violations FROM `person` c WHERE c.`groupingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `persongroup` p WHERE p.`groupingId` = c.`groupingId`)
UNION ALL
SELECT 'fk_person_noc' AS check_name, COUNT(*) AS violations FROM `person` c WHERE c.`nocId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `noc` p WHERE p.`nocId` = c.`nocId`)
UNION ALL
SELECT 'fk_personrole_person' AS check_name, COUNT(*) AS violations FROM `personrole` c WHERE c.`personId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`personId` = c.`personId`)
UNION ALL
SELECT 'fk_personrole_role' AS check_name, COUNT(*) AS violations FROM `personrole` c WHERE c.`roleId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `role` p WHERE p.`roleId` = c.`roleId`)
UNION ALL
SELECT 'fk_room_building' AS check_name, COUNT(*) AS violations FROM `room` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_roomallocation_person' AS check_name, COUNT(*) AS violations FROM `roomallocation` c WHERE c.`personId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`personId` = c.`personId`)
UNION ALL
SELECT 'fk_roomallocation_room' AS check_name, COUNT(*) AS violations FROM `roomallocation` c WHERE c.`roomId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `room` p WHERE p.`roomId` = c.`roomId`)
UNION ALL
SELECT 'fk_roomconversion_conversionproject' AS check_name, COUNT(*) AS violations FROM `roomconversion` c WHERE c.`conversionId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `conversionproject` p WHERE p.`conversionId` = c.`conversionId`)
UNION ALL
SELECT 'fk_roomconversion_room' AS check_name, COUNT(*) AS violations FROM `roomconversion` c WHERE c.`roomId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `room` p WHERE p.`roomId` = c.`roomId`)
UNION ALL
SELECT 'fk_village_location' AS check_name, COUNT(*) AS violations FROM `village` c WHERE c.`locationId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `location` p WHERE p.`locationId` = c.`locationId`)
UNION ALL
SELECT 'fk_wastecollection_building' AS check_name, COUNT(*) AS violations FROM `wastecollection` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_wastecollection_wastetype' AS check_name, COUNT(*) AS violations FROM `wastecollection` c WHERE c.`wasteTypeId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `wastetype` p WHERE p.`wasteTypeId` = c.`wasteTypeId`)
UNION ALL
SELECT 'fk_watermeter_building' AS check_name, COUNT(*) AS violations FROM `watermeter` c WHERE c.`buildingId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `building` p WHERE p.`buildingId` = c.`buildingId`)
UNION ALL
SELECT 'fk_watermeter_watersource' AS check_name, COUNT(*) AS violations FROM `watermeter` c WHERE c.`waterSourceId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `watersource` p WHERE p.`waterSourceId` = c.`waterSourceId`)
UNION ALL
SELECT 'fk_waterreading_watermeter' AS check_name, COUNT(*) AS violations FROM `waterreading` c WHERE c.`waterMeterId` IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `watermeter` p WHERE p.`waterMeterId` = c.`waterMeterId`);
