-- Portfolio execution copy derived from the submitted MySQL 8 backup.
CREATE DATABASE IF NOT EXISTS olympicdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE olympicdb;
SET @portfolio_old_fk_checks = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `asset` (
  `assetId` int NOT NULL,
  `assetName` varchar(45) NOT NULL,
  `sustainabilityRating` varchar(45) NOT NULL,
  `buildingId` int NOT NULL,
  `assetStatus` varchar(45) NOT NULL,
  `categoryId` int NOT NULL,
  `supplierId` int NOT NULL,
  PRIMARY KEY (`assetId`),
  KEY `fk_asset_building` (`buildingId`),
  KEY `fk_asset_category_idx` (`categoryId`),
  KEY `fk_asset_supplier_idx` (`supplierId`),
  CONSTRAINT `fk_asset_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`),
  CONSTRAINT `fk_asset_category` FOREIGN KEY (`categoryId`) REFERENCES `assetcategory` (`categoryId`),
  CONSTRAINT `fk_asset_supplier` FOREIGN KEY (`supplierId`) REFERENCES `supplier` (`supplierId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `assetcategory` (
  `categoryId` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(45) NOT NULL,
  PRIMARY KEY (`categoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `assetdisposal` (
  `disposalId` int NOT NULL AUTO_INCREMENT,
  `assetId` int NOT NULL,
  `disposalType` varchar(45) NOT NULL,
  `disposalDate` date NOT NULL,
  `disposalNote` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`disposalId`),
  KEY `fk_assetdisposal_asset_idx` (`assetId`),
  CONSTRAINT `fk_assetdisposal_asset` FOREIGN KEY (`assetId`) REFERENCES `asset` (`assetId`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `building` (
  `buildingId` int NOT NULL,
  `villageId` int NOT NULL,
  `buildingName` varchar(45) NOT NULL,
  `constructionType` varchar(45) NOT NULL,
  `legacyUseType` varchar(45) NOT NULL,
  `energyRating` varchar(45) NOT NULL,
  PRIMARY KEY (`buildingId`),
  KEY `fk_building_village` (`villageId`),
  CONSTRAINT `fk_building_village` FOREIGN KEY (`villageId`) REFERENCES `village` (`villageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `clinic` (
  `clinicId` int NOT NULL AUTO_INCREMENT,
  `facilityId` int NOT NULL,
  `is24Hour` tinyint NOT NULL DEFAULT '0',
  `infectionControlLevel` varchar(45) NOT NULL,
  `hasImaging` tinyint NOT NULL DEFAULT '0',
  `hasRehabilitation` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`clinicId`),
  KEY `fk_clinic_facility` (`facilityId`),
  CONSTRAINT `fk_clinic_facility` FOREIGN KEY (`facilityId`) REFERENCES `facility` (`facilityId`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `clinicalservice` (
  `serviceId` int NOT NULL AUTO_INCREMENT,
  `serviceName` varchar(45) NOT NULL,
  PRIMARY KEY (`serviceId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `clinicservice` (
  `clinicId` int NOT NULL,
  `serviceId` int NOT NULL,
  PRIMARY KEY (`clinicId`,`serviceId`),
  KEY `fk_clinicservice_service` (`serviceId`),
  CONSTRAINT `fk_clinicservice_clinic` FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`clinicId`),
  CONSTRAINT `fk_clinicservice_service` FOREIGN KEY (`serviceId`) REFERENCES `clinicalservice` (`serviceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `contractor` (
  `contractorId` int NOT NULL,
  `contractorName` varchar(45) DEFAULT NULL,
  `contractorType` varchar(45) DEFAULT NULL,
  `contactEmail` varchar(45) DEFAULT NULL,
  `sustainabilityRating` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`contractorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `conversionproject` (
  `conversionId` int NOT NULL,
  `buildingId` int NOT NULL,
  `contractorId` int NOT NULL,
  `originalUseType` varchar(45) NOT NULL,
  `targetUseType` varchar(45) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `conversionStatus` varchar(45) NOT NULL,
  PRIMARY KEY (`conversionId`),
  KEY `fk_conversionproject_building` (`buildingId`),
  KEY `fk_conversionproject_contractor` (`contractorId`),
  CONSTRAINT `fk_conversionproject_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`),
  CONSTRAINT `fk_conversionproject_contractor` FOREIGN KEY (`contractorId`) REFERENCES `contractor` (`contractorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `conversiontask` (
  `taskId` int NOT NULL,
  `conversionId` int NOT NULL,
  `taskName` varchar(100) NOT NULL,
  `taskStatus` varchar(45) NOT NULL,
  `plannedCompletionDate` date NOT NULL,
  `actualCompletionDate` date DEFAULT NULL,
  `taskNotes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`taskId`),
  KEY `fk_conversiontask_conversionproject` (`conversionId`),
  CONSTRAINT `fk_conversiontask_conversionproject` FOREIGN KEY (`conversionId`) REFERENCES `conversionproject` (`conversionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `country` (
  `countryCode` char(3) NOT NULL,
  `countryName` varchar(45) NOT NULL,
  PRIMARY KEY (`countryCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `employmentactivity` (
  `activityId` int NOT NULL AUTO_INCREMENT,
  `activityDate` date NOT NULL,
  `activityType` varchar(45) NOT NULL,
  `hours` decimal(5,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `employmentId` int NOT NULL,
  PRIMARY KEY (`activityId`),
  KEY `fk_employmentActivity_localEmployment1_idx` (`employmentId`),
  CONSTRAINT `fk_employmentActivity_localEmployment1` FOREIGN KEY (`employmentId`) REFERENCES `localemployment` (`employmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `encounter` (
  `encounterId` int NOT NULL AUTO_INCREMENT,
  `clinicId` int NOT NULL,
  `caseManagerId` varchar(45) NOT NULL,
  `personId` int NOT NULL,
  `encounterTimestamp` datetime NOT NULL,
  `encounterType` varchar(45) NOT NULL,
  PRIMARY KEY (`encounterId`),
  KEY `fk_encounter_clinic` (`clinicId`),
  KEY `fk_encounter_casemanager` (`caseManagerId`),
  KEY `fk_encounter_person` (`personId`),
  CONSTRAINT `fk_encounter_casemanager` FOREIGN KEY (`caseManagerId`) REFERENCES `medicalstaff` (`staffCode`),
  CONSTRAINT `fk_encounter_clinic` FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`clinicId`),
  CONSTRAINT `fk_encounter_person` FOREIGN KEY (`personId`) REFERENCES `person` (`personId`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `encounterservice` (
  `encounterId` int NOT NULL,
  `serviceId` int NOT NULL,
  PRIMARY KEY (`encounterId`,`serviceId`),
  KEY `fk_encounterservice_service` (`serviceId`),
  CONSTRAINT `fk_encounterservice_encounter` FOREIGN KEY (`encounterId`) REFERENCES `encounter` (`encounterId`),
  CONSTRAINT `fk_encounterservice_service` FOREIGN KEY (`serviceId`) REFERENCES `clinicalservice` (`serviceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `encounterstaff` (
  `encounterId` int NOT NULL,
  `staffCode` varchar(45) NOT NULL,
  `staffRole` varchar(45) NOT NULL,
  PRIMARY KEY (`encounterId`,`staffCode`),
  KEY `fk_encounterstaff_staff` (`staffCode`),
  CONSTRAINT `fk_encounterstaff_encounter` FOREIGN KEY (`encounterId`) REFERENCES `encounter` (`encounterId`),
  CONSTRAINT `fk_encounterstaff_staff` FOREIGN KEY (`staffCode`) REFERENCES `medicalstaff` (`staffCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `energymeter` (
  `energyMeterId` int NOT NULL,
  `meterCode` varchar(45) NOT NULL,
  `meterStatus` varchar(45) NOT NULL,
  `energySourceId` int NOT NULL,
  `buildingId` int NOT NULL,
  PRIMARY KEY (`energyMeterId`),
  KEY `fk_energymeter_energysource` (`energySourceId`),
  KEY `fk_energymeter_building` (`buildingId`),
  CONSTRAINT `fk_energymeter_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`),
  CONSTRAINT `fk_energymeter_energysource` FOREIGN KEY (`energySourceId`) REFERENCES `energysource` (`energySourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `energyreading` (
  `readingTimestamp` datetime NOT NULL,
  `energyMeterId` int NOT NULL,
  `energyConsumedKwh` decimal(12,2) DEFAULT NULL,
  `carbonIntensity` decimal(8,4) DEFAULT NULL,
  PRIMARY KEY (`readingTimestamp`,`energyMeterId`),
  KEY `fk_energyreading_energymeter` (`energyMeterId`),
  CONSTRAINT `fk_energyreading_energymeter` FOREIGN KEY (`energyMeterId`) REFERENCES `energymeter` (`energyMeterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `energysource` (
  `energySourceId` int NOT NULL,
  `sourceName` varchar(45) NOT NULL,
  `isRenewable` tinyint NOT NULL,
  `sourceDescription` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`energySourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `facility` (
  `facilityId` int NOT NULL,
  `buildingId` int NOT NULL,
  `facilityName` varchar(45) NOT NULL,
  `facilityType` varchar(45) NOT NULL,
  PRIMARY KEY (`facilityId`),
  KEY `fk_facility_building` (`buildingId`),
  CONSTRAINT `fk_facility_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `facilityusage` (
  `usageId` int NOT NULL,
  `facilityId` int NOT NULL,
  `personId` int NOT NULL,
  `usageTimestamp` datetime NOT NULL,
  PRIMARY KEY (`usageId`),
  KEY `fk_facilityusage_facility` (`facilityId`),
  KEY `fk_facilityusage_person` (`personId`),
  CONSTRAINT `fk_facilityusage_facility` FOREIGN KEY (`facilityId`) REFERENCES `facility` (`facilityId`),
  CONSTRAINT `fk_facilityusage_person` FOREIGN KEY (`personId`) REFERENCES `person` (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `localemployment` (
  `isLocalResident` tinyint NOT NULL,
  `jobTitle` varchar(45) NOT NULL,
  `hireDate` date NOT NULL,
  `projectId` int NOT NULL,
  `employmentId` int NOT NULL,
  `employmentNotes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`employmentId`),
  KEY `fk_localEmployment_conversionProject1_idx` (`projectId`),
  CONSTRAINT `fk_localEmployment_conversionProject1` FOREIGN KEY (`projectId`) REFERENCES `conversionproject` (`conversionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `location` (
  `locationId` int NOT NULL,
  `streetAddress` varchar(100) NOT NULL,
  `city` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL,
  `postcode` char(4) NOT NULL,
  PRIMARY KEY (`locationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `medicalspecialty` (
  `specialtyId` int NOT NULL AUTO_INCREMENT,
  `specialtyName` varchar(45) NOT NULL,
  `specialtyCode` char(1) NOT NULL,
  PRIMARY KEY (`specialtyId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `medicalstaff` (
  `staffCode` varchar(45) NOT NULL,
  `personId` int NOT NULL,
  `specialtyId` int NOT NULL,
  `registrationNumber` varchar(45) NOT NULL,
  `registrationCountry` varchar(45) NOT NULL,
  PRIMARY KEY (`staffCode`),
  KEY `idx_medicalstaff_personId` (`personId`),
  KEY `fk_medicalstaff_specialty` (`specialtyId`),
  CONSTRAINT `fk_medicalstaff_person` FOREIGN KEY (`personId`) REFERENCES `person` (`personId`),
  CONSTRAINT `fk_medicalstaff_specialty` FOREIGN KEY (`specialtyId`) REFERENCES `medicalspecialty` (`specialtyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `medicalwastecollection` (
  `medicalWasteLogId` int NOT NULL,
  `clinicId` int NOT NULL,
  `medicalWasteTypeId` int NOT NULL,
  `wasteCategory` varchar(45) DEFAULT NULL,
  `logDate` date DEFAULT NULL,
  `weightKg` decimal(10,2) NOT NULL,
  PRIMARY KEY (`medicalWasteLogId`),
  KEY `fk_medicalwastecollection_clinic` (`clinicId`),
  KEY `fk_medicalwastecollection_type` (`medicalWasteTypeId`),
  CONSTRAINT `fk_medicalwastecollection_clinic` FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`clinicId`),
  CONSTRAINT `fk_medicalwastecollection_type` FOREIGN KEY (`medicalWasteTypeId`) REFERENCES `medicalwastetype` (`medicalWasteTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `medicalwastetype` (
  `medicalWasteTypeId` int NOT NULL,
  `medicalWasteTypeName` varchar(225) DEFAULT NULL,
  `medicalWasteDescription` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`medicalWasteTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `noc` (
  `nocId` int NOT NULL,
  `nocName` varchar(80) NOT NULL,
  `countryCode` char(3) NOT NULL,
  PRIMARY KEY (`nocId`),
  KEY `fk_noc_country` (`countryCode`),
  CONSTRAINT `fk_noc_country` FOREIGN KEY (`countryCode`) REFERENCES `country` (`countryCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `person` (
  `personId` int NOT NULL,
  `firstName` varchar(45) NOT NULL,
  `lastName` varchar(45) NOT NULL,
  `dateOfBirth` date NOT NULL,
  `gender` char(1) NOT NULL,
  `nocId` int DEFAULT NULL,
  `groupingId` int DEFAULT NULL,
  PRIMARY KEY (`personId`),
  KEY `fk_person_noc` (`nocId`),
  KEY `fk_person_grouping` (`groupingId`),
  CONSTRAINT `fk_person_grouping` FOREIGN KEY (`groupingId`) REFERENCES `persongroup` (`groupingId`),
  CONSTRAINT `fk_person_noc` FOREIGN KEY (`nocId`) REFERENCES `noc` (`nocId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `persongroup` (
  `groupingId` int NOT NULL,
  `groupingName` varchar(45) NOT NULL,
  PRIMARY KEY (`groupingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `personrole` (
  `personId` int NOT NULL,
  `roleId` int NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  PRIMARY KEY (`personId`,`roleId`,`startDate`),
  KEY `fk_personrole_role` (`roleId`),
  CONSTRAINT `fk_personrole_person` FOREIGN KEY (`personId`) REFERENCES `person` (`personId`),
  CONSTRAINT `fk_personrole_role` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `role` (
  `roleId` int NOT NULL,
  `roleName` varchar(45) NOT NULL,
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `room` (
  `roomId` int NOT NULL,
  `buildingId` int NOT NULL,
  `roomType` varchar(45) NOT NULL,
  `roomCapacity` int NOT NULL,
  `isAccessible` tinyint NOT NULL,
  PRIMARY KEY (`roomId`),
  KEY `fk_room_building` (`buildingId`),
  CONSTRAINT `fk_room_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `roomallocation` (
  `allocationId` int NOT NULL,
  `personId` int NOT NULL,
  `roomId` int NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  PRIMARY KEY (`allocationId`),
  KEY `fk_roomallocation_person` (`personId`),
  KEY `fk_roomallocation_room` (`roomId`),
  CONSTRAINT `fk_roomallocation_person` FOREIGN KEY (`personId`) REFERENCES `person` (`personId`),
  CONSTRAINT `fk_roomallocation_room` FOREIGN KEY (`roomId`) REFERENCES `room` (`roomId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `roomconversion` (
  `roomConversionId` int NOT NULL,
  `conversionId` int NOT NULL,
  `roomId` int NOT NULL,
  `originalRoomUse` varchar(45) NOT NULL,
  `newRoomUse` varchar(45) NOT NULL,
  `conversionNotes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`roomConversionId`),
  KEY `fk_roomconversion_conversionproject_idx` (`conversionId`),
  KEY `fk_roomconversion_room_idx` (`roomId`),
  CONSTRAINT `fk_roomconversion_conversionproject` FOREIGN KEY (`conversionId`) REFERENCES `conversionproject` (`conversionId`),
  CONSTRAINT `fk_roomconversion_room` FOREIGN KEY (`roomId`) REFERENCES `room` (`roomId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `supplier` (
  `supplierId` int NOT NULL AUTO_INCREMENT,
  `supplierName` varchar(45) NOT NULL,
  `sustainabilityRating` varchar(45) NOT NULL,
  `contactEmail` varchar(45) NOT NULL,
  PRIMARY KEY (`supplierId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `village` (
  `villageId` int NOT NULL,
  `villageName` varchar(45) NOT NULL,
  `locationId` int NOT NULL,
  PRIMARY KEY (`villageId`),
  KEY `fk_village_location` (`locationId`),
  CONSTRAINT `fk_village_location` FOREIGN KEY (`locationId`) REFERENCES `location` (`locationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wastecollection` (
  `collectionTimestamp` timestamp NOT NULL,
  `buildingId` int NOT NULL,
  `wasteTypeId` int NOT NULL,
  `quantityKg` decimal(10,2) NOT NULL,
  PRIMARY KEY (`collectionTimestamp`,`buildingId`,`wasteTypeId`),
  KEY `fk_wastecollection_building` (`buildingId`),
  KEY `fk_wastecollection_wastetype` (`wasteTypeId`),
  CONSTRAINT `fk_wastecollection_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`),
  CONSTRAINT `fk_wastecollection_wastetype` FOREIGN KEY (`wasteTypeId`) REFERENCES `wastetype` (`wasteTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wastetype` (
  `wasteTypeId` int NOT NULL,
  `wasteTypeName` varchar(45) DEFAULT NULL,
  `wasteDescription` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`wasteTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `watermeter` (
  `waterMeterId` int NOT NULL,
  `meterCode` varchar(45) NOT NULL,
  `meterStatus` varchar(45) NOT NULL,
  `waterSourceId` int NOT NULL,
  `buildingId` int NOT NULL,
  PRIMARY KEY (`waterMeterId`),
  KEY `fk_watermeter_watersource` (`waterSourceId`),
  KEY `fk_watermeter_building` (`buildingId`),
  CONSTRAINT `fk_watermeter_building` FOREIGN KEY (`buildingId`) REFERENCES `building` (`buildingId`),
  CONSTRAINT `fk_watermeter_watersource` FOREIGN KEY (`waterSourceId`) REFERENCES `watersource` (`waterSourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `waterreading` (
  `readingTimestamp` datetime NOT NULL,
  `waterMeterId` int NOT NULL,
  `waterConsumed` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`waterMeterId`,`readingTimestamp`),
  CONSTRAINT `fk_waterreading_watermeter` FOREIGN KEY (`waterMeterId`) REFERENCES `watermeter` (`waterMeterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `watersource` (
  `waterSourceId` int NOT NULL,
  `sourceName` varchar(45) NOT NULL,
  `sourceType` varchar(45) DEFAULT NULL,
  `sourceDescription` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`waterSourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = @portfolio_old_fk_checks;
