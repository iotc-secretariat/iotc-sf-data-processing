# Map legacy IOTDB codes to new codes
LEGACY_NEW_IRREGULAR_AREAS_MAPPING = fread("../inputs/mappings/MAPPING_SF_IRREGULAR_AREAS_IOTDB_MASTER.csv", colClasses = c("character", "character"))

# Extract the raw size data
SF_RAW_DATA_SPECIES = SF_raw(species_code = CODE_SPECIES_SELECTED)

# Save legacy fishing ground
setnames(SF_RAW_DATA_SPECIES, old = "FISHING_GROUND_CODE", new = "LEGACY_FISHING_GROUND_CODE")

# Update fishing ground codes for non-regular areas (from IOTCStatistics to IOTC_Master)
SF_RAW_DATA_SPECIES = merge(SF_RAW_DATA_SPECIES, LEGACY_NEW_IRREGULAR_AREAS_MAPPING, by.x = "LEGACY_FISHING_GROUND_CODE", by.y = "LEGACY_FISHING_GROUND_CODE", all.x = TRUE)

# Keep regular fishing grounds
SF_RAW_DATA_SPECIES[substring(LEGACY_FISHING_GROUND_CODE, 1, 1) %in% c("5", "6") & is.na(FISHING_GROUND_CODE), FISHING_GROUND_CODE := LEGACY_FISHING_GROUND_CODE]

# Remove legacy fishing grounds
SF_RAW_DATA_SPECIES[, LEGACY_FISHING_GROUND_CODE := NULL]

# Merge with regular grids 1x1 and 5x5 to identify data not consistent with expected reporting
IO_SF_GRID_LIST = query(DB_IOTC_MASTER(), "SELECT DISTINCT CODE, NAME_EN FROM refs_gis.V_IO_GRIDS_CE_SF;")

REG_GRIDS_NOT_IN_IO = unique(merge(SF_RAW_DATA_SPECIES[substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6")], IO_SF_GRID_LIST, by.x = "FISHING_GROUND_CODE", by.y = "CODE", all.x = TRUE)[is.na(NAME_EN), .(FISHING_GROUND_CODE)])[order(FISHING_GROUND_CODE)]

