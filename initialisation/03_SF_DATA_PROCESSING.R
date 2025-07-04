# Filtering ####

# Remove data reported outside the Indian Ocean
SF_DATA_SPECIES = SF_RAW_DATA_SPECIES[!FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

# Standardisation ####

# Standardise the size data
FL_STD_DATA_SPECIES = standardize.SF(SF_DATA_SPECIES)[, .(FLEET_CODE, YEAR, MONTH_START, MONTH_END, FISHING_GROUND_CODE, GEAR_CODE, SCHOOL_TYPE_CODE, SPECIES_CODE, MEASURE_TYPE_CODE, RAISE_CODE, CLASS_LOW, CLASS_HIGH, FISH_COUNT)]

# Trick to aggregate all sex in table
SF_DATA_SPECIES[, SEX_CODE := "UNCL"]

# Standardise and pivot the raw size data
# Sex excluded
FL_STD_DATA_SPECIES_TABLE = standardize_and_pivot_size_frequencies(SF_DATA_SPECIES, keep_sex_and_raise_code = TRUE)[, -c("SEX_CODE", "AVG_WEIGHT")]

# Extract reporting quality
FL_REPORTING_QUALITY_SPECIES = data_quality(species_code = CODE_SPECIES_SELECTED)

# Add reporting quality to the data in wide format
FL_STD_DATA_SPECIES_TABLE = merge(FL_STD_DATA_SPECIES_TABLE, FL_REPORTING_QUALITY_SPECIES[, .(FLEET_CODE, YEAR, GEAR_CODE, SPECIES_CODE, REPORTING_QUALITY = SF)], by.x = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), by.y = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), all.x = TRUE) 

# Reorder to put RAISE_CODE and REPORTING_QUALITY at the end of the fields
setcolorder(FL_STD_DATA_SPECIES_TABLE, neworder = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SCHOOL_TYPE_CODE", "SPECIES_CODE", "MEASURE_TYPE_CODE", "FIRST_CLASS_LOW", "SIZE_INTERVAL", "NO_FISH", "KG_FISH", "RAISE_CODE", "REPORTING_QUALITY"))

# Add reporting quality to the data in melted format
FL_STD_DATA_SPECIES = merge(FL_STD_DATA_SPECIES, FL_REPORTING_QUALITY_SPECIES[, .(FLEET_CODE, YEAR, GEAR_CODE, SPECIES_CODE, REPORTING_QUALITY = SF)], by.x = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), by.y = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), all.x = TRUE) 

# Reorder to put RAISE_CODE and REPORTING_QUALITY at the end of the fields
setcolorder(FL_STD_DATA_SPECIES, neworder = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SCHOOL_TYPE_CODE", "SPECIES_CODE", "MEASURE_TYPE_CODE", "CLASS_LOW", "CLASS_HIGH", "FISH_COUNT", "RAISE_CODE", "REPORTING_QUALITY"))





