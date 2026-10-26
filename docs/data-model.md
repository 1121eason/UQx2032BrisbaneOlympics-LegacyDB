# Data model

The executable backup is the source of truth for this package: **41 domain tables and 46 foreign-key constraints**. The additional spreadsheet import residue is excluded. Both supplied Workbench files contain 40 tables and omit `roomconversion`; keep that discrepancy in mind when opening them.

## People and accreditation

- `country` → reference / root table
- `noc` → `country` (countryCode)
- `person` → `persongroup` (groupingId), `noc` (nocId)
- `persongroup` → reference / root table
- `personrole` → `person` (personId), `role` (roleId)
- `role` → reference / root table

## Infrastructure

- `location` → reference / root table
- `village` → `location` (locationId)
- `building` → `village` (villageId)
- `room` → `building` (buildingId)
- `facility` → `building` (buildingId)
- `roomallocation` → `person` (personId), `room` (roomId)
- `facilityusage` → `facility` (facilityId), `person` (personId)

## Sustainability

- `energysource` → reference / root table
- `energymeter` → `building` (buildingId), `energysource` (energySourceId)
- `energyreading` → `energymeter` (energyMeterId)
- `watersource` → reference / root table
- `watermeter` → `building` (buildingId), `watersource` (waterSourceId)
- `waterreading` → `watermeter` (waterMeterId)
- `wastetype` → reference / root table
- `wastecollection` → `building` (buildingId), `wastetype` (wasteTypeId)
- `medicalwastetype` → reference / root table
- `medicalwastecollection` → `clinic` (clinicId), `medicalwastetype` (medicalWasteTypeId)

## Medical operations

- `clinic` → `facility` (facilityId)
- `clinicalservice` → reference / root table
- `clinicservice` → `clinic` (clinicId), `clinicalservice` (serviceId)
- `medicalspecialty` → reference / root table
- `medicalstaff` → `person` (personId), `medicalspecialty` (specialtyId)
- `encounter` → `medicalstaff` (caseManagerId), `clinic` (clinicId), `person` (personId)
- `encounterservice` → `encounter` (encounterId), `clinicalservice` (serviceId)
- `encounterstaff` → `encounter` (encounterId), `medicalstaff` (staffCode)

## Asset lifecycle

- `supplier` → reference / root table
- `assetcategory` → reference / root table
- `asset` → `building` (buildingId), `assetcategory` (categoryId), `supplier` (supplierId)
- `assetdisposal` → `asset` (assetId)

## Post-Games conversion

- `contractor` → reference / root table
- `conversionproject` → `building` (buildingId), `contractor` (contractorId)
- `conversiontask` → `conversionproject` (conversionId)
- `roomconversion` → `conversionproject` (conversionId), `room` (roomId)

## Social impact

- `localemployment` → `conversionproject` (projectId)
- `employmentactivity` → `localemployment` (employmentId)

