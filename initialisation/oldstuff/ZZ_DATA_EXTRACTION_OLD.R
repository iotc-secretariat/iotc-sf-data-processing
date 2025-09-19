l_info("Extracting raw and standard size-frequency data...")

# Map legacy IOTDB codes to new codes
LEGACY_NEW_IRREGULAR_AREAS_MAPPING = fread("../inputs/mappings/MAPPING_SF_IRREGULAR_AREAS_IOTDB_MASTER.csv", colClasses = c("character", "character"))

## RAW SIZE DATA ####
SF_RAW_YFT = SF.raw(connection = DB_IOTDB(), species_codes = "YFT")

# Save legacy fishing ground
setnames(SF_RAW_YFT, old = "FISHING_GROUND_CODE", new = "LEGACY_FISHING_GROUND_CODE")

# Update fishing ground codes for non-regular areas (from IOTCStatistics to IOTC_Master)
SF_RAW_YFT = merge(SF_RAW_YFT, LEGACY_NEW_IRREGULAR_AREAS_MAPPING, by.x = "LEGACY_FISHING_GROUND_CODE", by.y = "LEGACY_FISHING_GROUND_CODE", all.x = TRUE)

# Keep regular fishing grounds
SF_RAW_YFT[substring(LEGACY_FISHING_GROUND_CODE, 1, 1) %in% c("5", "6") & is.na(FISHING_GROUND_CODE), FISHING_GROUND_CODE := LEGACY_FISHING_GROUND_CODE]

# Add area type code
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "5", AREA_TYPE_CODE := "GRID01x01"]
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "6", AREA_TYPE_CODE := "GRID05x05"]
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "7", AREA_TYPE_CODE := "GRID10x10"]
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "8", AREA_TYPE_CODE := "GRID20x20"]
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "9", AREA_TYPE_CODE := "GRID30x30"]
SF_RAW_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "A", AREA_TYPE_CODE := "GRID10x20"]
SF_RAW_YFT[!substring(FISHING_GROUND_CODE, 1, 1) %in% c("A", "5", "6", "7", "8", "9"), AREA_TYPE_CODE := "IRREGAREA"]

# TEMP FIX for Seychelles swordfish longliners
SF_RAW_YFT[FLEET_CODE == "SYC" & MEASURE_TYPE_CODE == "LDF" & GEAR_CODE == "ELL", MEASURE_TYPE_CODE := "FL"]

SF_RAW_YFT[FLEET_CODE == "SYC" & MEASURE_TYPE_CODE == "LDFT" & GEAR_CODE == "ELL", MEASURE_TYPE_CODE := "FLUT"]


## STANDARDISE SIZE DATA ####
SF_STD_YFT = standardize_size_frequencies(SF_RAW_YFT, 
                                          bin_size = PARAMS_SF_YFT$DEFAULT_MEASUREMENT_INTERVAL, 
                                          max_bin_size = PARAMS_SF_YFT$MAX_MEASUREMENT_INTERVAL, 
                                          first_class_low = PARAMS_SF_YFT$MIN_MEASUREMENT, 
                                          last_size_bin = PARAMS_SF_YFT$MAX_MEASUREMENT
                                          )

# Add area type code
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "5", AREA_TYPE_CODE := "GRID01x01"]
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "6", AREA_TYPE_CODE := "GRID05x05"]
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "7", AREA_TYPE_CODE := "GRID10x10"]
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "8", AREA_TYPE_CODE := "GRID20x20"]
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "9", AREA_TYPE_CODE := "GRID30x30"]
SF_STD_YFT[substring(FISHING_GROUND_CODE, 1, 1) == "A", AREA_TYPE_CODE := "GRID10x20"]
SF_STD_YFT[!substring(FISHING_GROUND_CODE, 1, 1) %in% c("A", "5", "6", "7", "8", "9"), AREA_TYPE_CODE := "IRREGAREA"]

# SF REPORTING QUALITY ####
SF_REPORTING_QUALITY_1952_2022 = fread("../inputs/data/YFT_SF_QUALITY_SCORES.csv")

SF_REPORTING_QUALITY_2023 = data_quality(species_code = "YFT", year_from = 2023, year_to = 2023)[, .(YEAR, FLEET_CODE, GEAR_CODE, SPECIES_CODE, REPORTING_QUALITY = SF)]

SF_REPORTING_QUALITY = rbindlist(list(SF_REPORTING_QUALITY_1952_2022, SF_REPORTING_QUALITY_2023))

# Add quality
SF_STD_YFT = merge(SF_STD_YFT, SF_REPORTING_QUALITY, by = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), all.x = TRUE)

# Temp fix for missing strata (all observer data set to good quality)
SF_STD_YFT[GEAR_CODE %in% c("LLOB", "FLLOB", "ELLOB", "PSOB"), REPORTING_QUALITY := "0"]

l_info("Size-frequency data extracted and consolidated!")
