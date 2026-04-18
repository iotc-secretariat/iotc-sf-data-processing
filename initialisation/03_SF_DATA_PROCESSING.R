l_info("Standardising the size-frequency data")

# Temp fix/test for SYC LL size measurements in 2016
# Assuming measurements were made in Pectoral-anal length
SF_RAW_DATA_SPECIES[FLEET_CODE == "SYC" & GEAR_CODE == "ELL" & YEAR == 2016, `:=` (MEASURE_TYPE_CODE = "PAL", MEASURE_TYPE = "Pectoral-anal length (by using a calliper)")]

# Filtering ####

## Data reported outside the Indian Ocean ####

# Merge with regular grids 1x1 and 5x5 to identify data not consistent with expected reporting
IO_SF_GRID_LIST = query(DB_IOTC_MASTER(), "SELECT DISTINCT CODE, NAME_EN FROM refs_gis.V_IO_GRIDS_CE_SF;")

REG_GRIDS_NOT_IN_IO = unique(merge(SF_RAW_DATA_SPECIES[substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6")], IO_SF_GRID_LIST, by.x = "FISHING_GROUND_CODE", by.y = "CODE", all.x = TRUE)[is.na(NAME_EN), .(FISHING_GROUND_CODE)])[order(FISHING_GROUND_CODE)]

SF_DATA_SPECIES = SF_RAW_DATA_SPECIES[!FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

# Standardisation ####

# Standardise the size data
FL_STD_DATA_SPECIES = standardize.SF(SF_DATA_SPECIES, 
                                     bin_size = CL_SIZE_REC_TABLE$DEFAULT_MEASUREMENT_INTERVAL, 
                                     max_bin_size = CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL, 
                                     first_class_low = CL_SIZE_REC_TABLE$MIN_MEASUREMENT, 
                                     last_size_bin = 150)[, .(FLEET_CODE, YEAR, MONTH_START, MONTH_END, FISHING_GROUND_CODE, GEAR_CODE, SCHOOL_TYPE_CODE, SPECIES_CODE, MEASURE_TYPE_CODE, RAISE_CODE, CLASS_LOW, CLASS_HIGH, FISH_COUNT)]

if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO")) {FL_STD_DATA_SPECIES[, MEASURE_TYPE_CODE := "LJ"]}

# Trick to aggregate all sex in table
SF_RAW_DATA_SPECIES[, SEX_CODE := "UNCL"]

# Standardise and pivot the raw size data
# Sex excluded
FL_STD_DATA_SPECIES_TABLE = standardize_and_pivot_size_frequencies(SF_DATA_SPECIES, 
                                                                   bin_size = CL_SIZE_REC_TABLE$DEFAULT_MEASUREMENT_INTERVAL, 
                                                                   max_bin_size = CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL, 
                                                                   first_class_low = CL_SIZE_REC_TABLE$MIN_MEASUREMENT, 
                                                                   last_size_bin = 150, 
                                                                   keep_sex_and_raise_code = TRUE)[, -c("SEX_CODE")]#, "AVG_WEIGHT")]

if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO")) {FL_STD_DATA_SPECIES_TABLE[, MEASURE_TYPE_CODE := "LJ"]}

l_info("Size-frequency data standardised")