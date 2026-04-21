l_info("Standardising the size-frequency data")

# Standardise the size data
# SF_DATA_SPECIES corresponds to the consolidated dataset derived from SF_RAW_DATA_CONSOLIDATION
FL_STD_DATA_SPECIES = standardize.SF(SF_DATA_SPECIES, 
                                     bin_size = CL_SIZE_REC_TABLE$DEFAULT_MEASUREMENT_INTERVAL, 
                                     max_bin_size = CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL, 
                                     first_class_low = CL_SIZE_REC_TABLE$MIN_MEASUREMENT, 
                                     last_size_bin = 150)[, .(FLEET_CODE, YEAR, MONTH_START, MONTH_END, FISHING_GROUND_CODE, GEAR_CODE, SCHOOL_TYPE_CODE, SPECIES_CODE, MEASURE_TYPE_CODE, RAISE_CODE, CLASS_LOW, CLASS_HIGH, FISH_COUNT)]

if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO")) {FL_STD_DATA_SPECIES[, MEASURE_TYPE_CODE := "LJ"]}

# Trick to aggregate all sex in table
SF_DATA_SPECIES[, SEX_CODE := "UNCL"]

# Standardise and pivot the raw size data
# Sex excluded
FL_STD_DATA_SPECIES_TABLE = standardize_and_pivot_size_frequencies(raw_data = SF_DATA_SPECIES, 
                                                                   bin_size = CL_SIZE_REC_TABLE$DEFAULT_MEASUREMENT_INTERVAL, 
                                                                   max_bin_size = CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL, 
                                                                   first_class_low = CL_SIZE_REC_TABLE$MIN_MEASUREMENT, 
                                                                   last_size_bin = 150, 
                                                                   keep_sex_and_raise_code = TRUE)[, -c("SEX_CODE")]#, "AVG_WEIGHT")]

if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO")) {FL_STD_DATA_SPECIES_TABLE[, MEASURE_TYPE_CODE := "LJ"]}

l_info("Size-frequency data standardised")