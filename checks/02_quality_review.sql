USE olympicdb;
-- Review findings. These are not silently repaired during packaging.
SELECT 'asset_without_any_disposal_record' AS check_name, COUNT(*) AS findings
FROM asset a WHERE NOT EXISTS (SELECT 1 FROM assetdisposal d WHERE d.assetId = a.assetId)
UNION ALL
SELECT 'negative_energy_or_carbon', COUNT(*) FROM energyreading WHERE energyConsumedKwh < 0 OR carbonIntensity < 0
UNION ALL
SELECT 'missing_energy_or_carbon', COUNT(*) FROM energyreading WHERE energyConsumedKwh IS NULL OR carbonIntensity IS NULL
UNION ALL
SELECT 'negative_water', COUNT(*) FROM waterreading WHERE waterConsumed < 0
UNION ALL
SELECT 'nonpositive_room_capacity', COUNT(*) FROM room WHERE roomCapacity <= 0
UNION ALL
SELECT 'invalid_accessibility_flag', COUNT(*) FROM room WHERE isAccessible NOT IN (0,1)
UNION ALL
SELECT 'reversed_conversion_dates', COUNT(*) FROM conversionproject WHERE endDate < startDate
UNION ALL
SELECT 'reversed_role_dates', COUNT(*) FROM personrole WHERE endDate < startDate
UNION ALL
SELECT 'reversed_allocation_dates', COUNT(*) FROM roomallocation WHERE endDate < startDate
UNION ALL
SELECT 'missing_medical_waste_dates', COUNT(*) FROM medicalwastecollection WHERE logDate IS NULL;
