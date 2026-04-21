l_info("Extracting the raw size-frequency data...")

# Extract the raw size data
SF_RAW_DATA_SPECIES = SF_raw(species_code = CODE_SPECIES_SELECTED, years = START_YEAR:END_YEAR)

# Temp fix/test for SYC LL size measurements in 2016
# Assuming measurements were made in Pectoral-anal length
SF_RAW_DATA_SPECIES[FLEET_CODE == "SYC" & GEAR_CODE == "ELL" & YEAR == 2016, `:=` (MEASURE_TYPE_CODE = "PAL", MEASURE_TYPE = "Pectoral-anal length (by using a calliper)")]

#SF_RAW_DATA_SPECIES_BACKUP = copy(SF_RAW_DATA_SPECIES)

# Save legacy fishing ground
setnames(SF_RAW_DATA_SPECIES, old = "FISHING_GROUND_CODE", new = "LEGACY_FISHING_GROUND_CODE")

# Update fishing ground codes for non-regular areas (from IOTCStatistics to IOTC_Master)
SF_RAW_DATA_SPECIES = merge(SF_RAW_DATA_SPECIES, LEGACY_NEW_IRREGULAR_AREAS_MAPPING, by.x = "LEGACY_FISHING_GROUND_CODE", by.y = "LEGACY_FISHING_GROUND_CODE", all.x = TRUE)

# Keep regular fishing grounds
SF_RAW_DATA_SPECIES[substring(LEGACY_FISHING_GROUND_CODE, 1, 1) %in% c("5", "6") & is.na(FISHING_GROUND_CODE), FISHING_GROUND_CODE := LEGACY_FISHING_GROUND_CODE]

# Remove legacy fishing grounds
SF_RAW_DATA_SPECIES[, LEGACY_FISHING_GROUND_CODE := NULL]

# List of non standard areas in the raw SF dataset
LIST_NON_STANDARD_AREAS = sort(unique(SF_RAW_DATA_SPECIES[!substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6"), FISHING_GROUND_CODE]))

l_info("Raw size-frequency data extracted!")
