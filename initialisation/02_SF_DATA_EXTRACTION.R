l_info("Extracting the raw size-frequency data...")

# Map legacy IOTDB codes to new codes
LEGACY_NEW_IRREGULAR_AREAS_MAPPING = fread("../inputs/mappings/MAPPING_SF_IRREGULAR_AREAS_IOTDB_MASTER.csv", colClasses = c("character", "character"))

# Extract the raw size data
SF_RAW_DATA_SPECIES = SF_raw(species_code = CODE_SPECIES_SELECTED)

# Temp fix for tunas caught in Australian longline fisheries
# To do in the database
SF_RAW_DATA_SPECIES[SPECIES_CODE %in% c("BET", "YFT") & MEASURE_TYPE_CODE == "GIL", `:=` (MEASURE_TYPE_CODE = "GGT", MEASURE_TYPE = "Gilled and gutted (bill is off for billfish)")]

# Temp fix to remove some fish without gear code reported for EUESP
SF_RAW_DATA_SPECIES = SF_RAW_DATA_SPECIES[!(FLEET_CODE == "EUESP" & is.na(GEAR_CODE))]

# Temp fix for tunas caught in Seychelles
# SF_RAW_DATA_SPECIES[FLEET_CODE == "SYC" & GEAR_CODE == "PS", `:=` (MEASURE_TYPE_CODE = "FL", MEASURE_TYPE = "Fork length (lower jaw fork length for BIL)")]

#SF_RAW_DATA_SPECIES[FLEET_CODE == "SYC" & GEAR_CODE %in% c("LLCO", "ELL", "LL", "FLL"), `:=` (MEASURE_TYPE_CODE = "FLUT", MEASURE_TYPE = "Fork length (unconverted tape measure lengths)")]

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
