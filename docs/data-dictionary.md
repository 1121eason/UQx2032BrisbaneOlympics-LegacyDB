# Data dictionary

Generated from the executable schema, not inferred from the report. Data types and constraints are preserved from the backup. Business explanations are in the source report.

## `country`

Module: People and accreditation. Primary key: `countryCode`.

| Column | Definition | References |
| --- | --- | --- |
| `countryCode` | `char(3) NOT NULL` | — |
| `countryName` | `varchar(45) NOT NULL` | — |

## `noc`

Module: People and accreditation. Primary key: `nocId`.

| Column | Definition | References |
| --- | --- | --- |
| `nocId` | `int NOT NULL` | — |
| `nocName` | `varchar(80) NOT NULL` | — |
| `countryCode` | `char(3) NOT NULL` | `country.countryCode` |

## `person`

Module: People and accreditation. Primary key: `personId`.

| Column | Definition | References |
| --- | --- | --- |
| `personId` | `int NOT NULL` | — |
| `firstName` | `varchar(45) NOT NULL` | — |
| `lastName` | `varchar(45) NOT NULL` | — |
| `dateOfBirth` | `date NOT NULL` | — |
| `gender` | `char(1) NOT NULL` | — |
| `nocId` | `int DEFAULT NULL` | `noc.nocId` |
| `groupingId` | `int DEFAULT NULL` | `persongroup.groupingId` |

## `persongroup`

Module: People and accreditation. Primary key: `groupingId`.

| Column | Definition | References |
| --- | --- | --- |
| `groupingId` | `int NOT NULL` | — |
| `groupingName` | `varchar(45) NOT NULL` | — |

## `personrole`

Module: People and accreditation. Primary key: `personId`, `roleId`, `startDate`.

| Column | Definition | References |
| --- | --- | --- |
| `personId` | `int NOT NULL` | `person.personId` |
| `roleId` | `int NOT NULL` | `role.roleId` |
| `startDate` | `date NOT NULL` | — |
| `endDate` | `date DEFAULT NULL` | — |

## `role`

Module: People and accreditation. Primary key: `roleId`.

| Column | Definition | References |
| --- | --- | --- |
| `roleId` | `int NOT NULL` | — |
| `roleName` | `varchar(45) NOT NULL` | — |

## `location`

Module: Infrastructure. Primary key: `locationId`.

| Column | Definition | References |
| --- | --- | --- |
| `locationId` | `int NOT NULL` | — |
| `streetAddress` | `varchar(100) NOT NULL` | — |
| `city` | `varchar(45) NOT NULL` | — |
| `state` | `varchar(45) NOT NULL` | — |
| `postcode` | `char(4) NOT NULL` | — |

## `village`

Module: Infrastructure. Primary key: `villageId`.

| Column | Definition | References |
| --- | --- | --- |
| `villageId` | `int NOT NULL` | — |
| `villageName` | `varchar(45) NOT NULL` | — |
| `locationId` | `int NOT NULL` | `location.locationId` |

## `building`

Module: Infrastructure. Primary key: `buildingId`.

| Column | Definition | References |
| --- | --- | --- |
| `buildingId` | `int NOT NULL` | — |
| `villageId` | `int NOT NULL` | `village.villageId` |
| `buildingName` | `varchar(45) NOT NULL` | — |
| `constructionType` | `varchar(45) NOT NULL` | — |
| `legacyUseType` | `varchar(45) NOT NULL` | — |
| `energyRating` | `varchar(45) NOT NULL` | — |

## `room`

Module: Infrastructure. Primary key: `roomId`.

| Column | Definition | References |
| --- | --- | --- |
| `roomId` | `int NOT NULL` | — |
| `buildingId` | `int NOT NULL` | `building.buildingId` |
| `roomType` | `varchar(45) NOT NULL` | — |
| `roomCapacity` | `int NOT NULL` | — |
| `isAccessible` | `tinyint NOT NULL` | — |

## `facility`

Module: Infrastructure. Primary key: `facilityId`.

| Column | Definition | References |
| --- | --- | --- |
| `facilityId` | `int NOT NULL` | — |
| `buildingId` | `int NOT NULL` | `building.buildingId` |
| `facilityName` | `varchar(45) NOT NULL` | — |
| `facilityType` | `varchar(45) NOT NULL` | — |

## `roomallocation`

Module: Infrastructure. Primary key: `allocationId`.

| Column | Definition | References |
| --- | --- | --- |
| `allocationId` | `int NOT NULL` | — |
| `personId` | `int NOT NULL` | `person.personId` |
| `roomId` | `int NOT NULL` | `room.roomId` |
| `startDate` | `date NOT NULL` | — |
| `endDate` | `date DEFAULT NULL` | — |

## `facilityusage`

Module: Infrastructure. Primary key: `usageId`.

| Column | Definition | References |
| --- | --- | --- |
| `usageId` | `int NOT NULL` | — |
| `facilityId` | `int NOT NULL` | `facility.facilityId` |
| `personId` | `int NOT NULL` | `person.personId` |
| `usageTimestamp` | `datetime NOT NULL` | — |

## `energysource`

Module: Sustainability. Primary key: `energySourceId`.

| Column | Definition | References |
| --- | --- | --- |
| `energySourceId` | `int NOT NULL` | — |
| `sourceName` | `varchar(45) NOT NULL` | — |
| `isRenewable` | `tinyint NOT NULL` | — |
| `sourceDescription` | `varchar(225) DEFAULT NULL` | — |

## `energymeter`

Module: Sustainability. Primary key: `energyMeterId`.

| Column | Definition | References |
| --- | --- | --- |
| `energyMeterId` | `int NOT NULL` | — |
| `meterCode` | `varchar(45) NOT NULL` | — |
| `meterStatus` | `varchar(45) NOT NULL` | — |
| `energySourceId` | `int NOT NULL` | `energysource.energySourceId` |
| `buildingId` | `int NOT NULL` | `building.buildingId` |

## `energyreading`

Module: Sustainability. Primary key: `readingTimestamp`, `energyMeterId`.

| Column | Definition | References |
| --- | --- | --- |
| `readingTimestamp` | `datetime NOT NULL` | — |
| `energyMeterId` | `int NOT NULL` | `energymeter.energyMeterId` |
| `energyConsumedKwh` | `decimal(12,2) DEFAULT NULL` | — |
| `carbonIntensity` | `decimal(8,4) DEFAULT NULL` | — |

## `watersource`

Module: Sustainability. Primary key: `waterSourceId`.

| Column | Definition | References |
| --- | --- | --- |
| `waterSourceId` | `int NOT NULL` | — |
| `sourceName` | `varchar(45) NOT NULL` | — |
| `sourceType` | `varchar(45) DEFAULT NULL` | — |
| `sourceDescription` | `varchar(255) DEFAULT NULL` | — |

## `watermeter`

Module: Sustainability. Primary key: `waterMeterId`.

| Column | Definition | References |
| --- | --- | --- |
| `waterMeterId` | `int NOT NULL` | — |
| `meterCode` | `varchar(45) NOT NULL` | — |
| `meterStatus` | `varchar(45) NOT NULL` | — |
| `waterSourceId` | `int NOT NULL` | `watersource.waterSourceId` |
| `buildingId` | `int NOT NULL` | `building.buildingId` |

## `waterreading`

Module: Sustainability. Primary key: `waterMeterId`, `readingTimestamp`.

| Column | Definition | References |
| --- | --- | --- |
| `readingTimestamp` | `datetime NOT NULL` | — |
| `waterMeterId` | `int NOT NULL` | `watermeter.waterMeterId` |
| `waterConsumed` | `decimal(12,2) DEFAULT NULL` | — |

## `wastetype`

Module: Sustainability. Primary key: `wasteTypeId`.

| Column | Definition | References |
| --- | --- | --- |
| `wasteTypeId` | `int NOT NULL` | — |
| `wasteTypeName` | `varchar(45) DEFAULT NULL` | — |
| `wasteDescription` | `varchar(255) DEFAULT NULL` | — |

## `wastecollection`

Module: Sustainability. Primary key: `collectionTimestamp`, `buildingId`, `wasteTypeId`.

| Column | Definition | References |
| --- | --- | --- |
| `collectionTimestamp` | `timestamp NOT NULL` | — |
| `buildingId` | `int NOT NULL` | `building.buildingId` |
| `wasteTypeId` | `int NOT NULL` | `wastetype.wasteTypeId` |
| `quantityKg` | `decimal(10,2) NOT NULL` | — |

## `medicalwastetype`

Module: Sustainability. Primary key: `medicalWasteTypeId`.

| Column | Definition | References |
| --- | --- | --- |
| `medicalWasteTypeId` | `int NOT NULL` | — |
| `medicalWasteTypeName` | `varchar(225) DEFAULT NULL` | — |
| `medicalWasteDescription` | `varchar(225) DEFAULT NULL` | — |

## `medicalwastecollection`

Module: Sustainability. Primary key: `medicalWasteLogId`.

| Column | Definition | References |
| --- | --- | --- |
| `medicalWasteLogId` | `int NOT NULL` | — |
| `clinicId` | `int NOT NULL` | `clinic.clinicId` |
| `medicalWasteTypeId` | `int NOT NULL` | `medicalwastetype.medicalWasteTypeId` |
| `wasteCategory` | `varchar(45) DEFAULT NULL` | — |
| `logDate` | `date DEFAULT NULL` | — |
| `weightKg` | `decimal(10,2) NOT NULL` | — |

## `clinic`

Module: Medical operations. Primary key: `clinicId`.

| Column | Definition | References |
| --- | --- | --- |
| `clinicId` | `int NOT NULL AUTO_INCREMENT` | — |
| `facilityId` | `int NOT NULL` | `facility.facilityId` |
| `is24Hour` | `tinyint NOT NULL DEFAULT '0'` | — |
| `infectionControlLevel` | `varchar(45) NOT NULL` | — |
| `hasImaging` | `tinyint NOT NULL DEFAULT '0'` | — |
| `hasRehabilitation` | `tinyint NOT NULL DEFAULT '0'` | — |

## `clinicalservice`

Module: Medical operations. Primary key: `serviceId`.

| Column | Definition | References |
| --- | --- | --- |
| `serviceId` | `int NOT NULL AUTO_INCREMENT` | — |
| `serviceName` | `varchar(45) NOT NULL` | — |

## `clinicservice`

Module: Medical operations. Primary key: `clinicId`, `serviceId`.

| Column | Definition | References |
| --- | --- | --- |
| `clinicId` | `int NOT NULL` | `clinic.clinicId` |
| `serviceId` | `int NOT NULL` | `clinicalservice.serviceId` |

## `medicalspecialty`

Module: Medical operations. Primary key: `specialtyId`.

| Column | Definition | References |
| --- | --- | --- |
| `specialtyId` | `int NOT NULL AUTO_INCREMENT` | — |
| `specialtyName` | `varchar(45) NOT NULL` | — |
| `specialtyCode` | `char(1) NOT NULL` | — |

## `medicalstaff`

Module: Medical operations. Primary key: `staffCode`.

| Column | Definition | References |
| --- | --- | --- |
| `staffCode` | `varchar(45) NOT NULL` | — |
| `personId` | `int NOT NULL` | `person.personId` |
| `specialtyId` | `int NOT NULL` | `medicalspecialty.specialtyId` |
| `registrationNumber` | `varchar(45) NOT NULL` | — |
| `registrationCountry` | `varchar(45) NOT NULL` | — |

## `encounter`

Module: Medical operations. Primary key: `encounterId`.

| Column | Definition | References |
| --- | --- | --- |
| `encounterId` | `int NOT NULL AUTO_INCREMENT` | — |
| `clinicId` | `int NOT NULL` | `clinic.clinicId` |
| `caseManagerId` | `varchar(45) NOT NULL` | `medicalstaff.staffCode` |
| `personId` | `int NOT NULL` | `person.personId` |
| `encounterTimestamp` | `datetime NOT NULL` | — |
| `encounterType` | `varchar(45) NOT NULL` | — |

## `encounterservice`

Module: Medical operations. Primary key: `encounterId`, `serviceId`.

| Column | Definition | References |
| --- | --- | --- |
| `encounterId` | `int NOT NULL` | `encounter.encounterId` |
| `serviceId` | `int NOT NULL` | `clinicalservice.serviceId` |

## `encounterstaff`

Module: Medical operations. Primary key: `encounterId`, `staffCode`.

| Column | Definition | References |
| --- | --- | --- |
| `encounterId` | `int NOT NULL` | `encounter.encounterId` |
| `staffCode` | `varchar(45) NOT NULL` | `medicalstaff.staffCode` |
| `staffRole` | `varchar(45) NOT NULL` | — |

## `supplier`

Module: Asset lifecycle. Primary key: `supplierId`.

| Column | Definition | References |
| --- | --- | --- |
| `supplierId` | `int NOT NULL AUTO_INCREMENT` | — |
| `supplierName` | `varchar(45) NOT NULL` | — |
| `sustainabilityRating` | `varchar(45) NOT NULL` | — |
| `contactEmail` | `varchar(45) NOT NULL` | — |

## `assetcategory`

Module: Asset lifecycle. Primary key: `categoryId`.

| Column | Definition | References |
| --- | --- | --- |
| `categoryId` | `int NOT NULL AUTO_INCREMENT` | — |
| `categoryName` | `varchar(45) NOT NULL` | — |

## `asset`

Module: Asset lifecycle. Primary key: `assetId`.

| Column | Definition | References |
| --- | --- | --- |
| `assetId` | `int NOT NULL` | — |
| `assetName` | `varchar(45) NOT NULL` | — |
| `sustainabilityRating` | `varchar(45) NOT NULL` | — |
| `buildingId` | `int NOT NULL` | `building.buildingId` |
| `assetStatus` | `varchar(45) NOT NULL` | — |
| `categoryId` | `int NOT NULL` | `assetcategory.categoryId` |
| `supplierId` | `int NOT NULL` | `supplier.supplierId` |

## `assetdisposal`

Module: Asset lifecycle. Primary key: `disposalId`.

| Column | Definition | References |
| --- | --- | --- |
| `disposalId` | `int NOT NULL AUTO_INCREMENT` | — |
| `assetId` | `int NOT NULL` | `asset.assetId` |
| `disposalType` | `varchar(45) NOT NULL` | — |
| `disposalDate` | `date NOT NULL` | — |
| `disposalNote` | `varchar(255) DEFAULT NULL` | — |

## `contractor`

Module: Post-Games conversion. Primary key: `contractorId`.

| Column | Definition | References |
| --- | --- | --- |
| `contractorId` | `int NOT NULL` | — |
| `contractorName` | `varchar(45) DEFAULT NULL` | — |
| `contractorType` | `varchar(45) DEFAULT NULL` | — |
| `contactEmail` | `varchar(45) DEFAULT NULL` | — |
| `sustainabilityRating` | `varchar(45) DEFAULT NULL` | — |

## `conversionproject`

Module: Post-Games conversion. Primary key: `conversionId`.

| Column | Definition | References |
| --- | --- | --- |
| `conversionId` | `int NOT NULL` | — |
| `buildingId` | `int NOT NULL` | `building.buildingId` |
| `contractorId` | `int NOT NULL` | `contractor.contractorId` |
| `originalUseType` | `varchar(45) NOT NULL` | — |
| `targetUseType` | `varchar(45) NOT NULL` | — |
| `startDate` | `date NOT NULL` | — |
| `endDate` | `date NOT NULL` | — |
| `conversionStatus` | `varchar(45) NOT NULL` | — |

## `conversiontask`

Module: Post-Games conversion. Primary key: `taskId`.

| Column | Definition | References |
| --- | --- | --- |
| `taskId` | `int NOT NULL` | — |
| `conversionId` | `int NOT NULL` | `conversionproject.conversionId` |
| `taskName` | `varchar(100) NOT NULL` | — |
| `taskStatus` | `varchar(45) NOT NULL` | — |
| `plannedCompletionDate` | `date NOT NULL` | — |
| `actualCompletionDate` | `date DEFAULT NULL` | — |
| `taskNotes` | `varchar(255) DEFAULT NULL` | — |

## `roomconversion`

Module: Post-Games conversion. Primary key: `roomConversionId`.

| Column | Definition | References |
| --- | --- | --- |
| `roomConversionId` | `int NOT NULL` | — |
| `conversionId` | `int NOT NULL` | `conversionproject.conversionId` |
| `roomId` | `int NOT NULL` | `room.roomId` |
| `originalRoomUse` | `varchar(45) NOT NULL` | — |
| `newRoomUse` | `varchar(45) NOT NULL` | — |
| `conversionNotes` | `varchar(255) DEFAULT NULL` | — |

## `localemployment`

Module: Social impact. Primary key: `employmentId`.

| Column | Definition | References |
| --- | --- | --- |
| `isLocalResident` | `tinyint NOT NULL` | — |
| `jobTitle` | `varchar(45) NOT NULL` | — |
| `hireDate` | `date NOT NULL` | — |
| `projectId` | `int NOT NULL` | `conversionproject.conversionId` |
| `employmentId` | `int NOT NULL` | — |
| `employmentNotes` | `varchar(255) DEFAULT NULL` | — |

## `employmentactivity`

Module: Social impact. Primary key: `activityId`.

| Column | Definition | References |
| --- | --- | --- |
| `activityId` | `int NOT NULL AUTO_INCREMENT` | — |
| `activityDate` | `date NOT NULL` | — |
| `activityType` | `varchar(45) NOT NULL` | — |
| `hours` | `decimal(5,2) NOT NULL` | — |
| `description` | `varchar(255) DEFAULT NULL` | — |
| `employmentId` | `int NOT NULL` | `localemployment.employmentId` |

## Constraint limits

The schema has foreign keys and selected unique keys; it does not implement all business validation described in the report. Room overbooking, overlapping roles, controlled vocabularies, positive measurements, date order, clinical access control and audit trails require further work.
