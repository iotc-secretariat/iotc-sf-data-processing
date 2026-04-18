l_info("Adding reporting quality to the data...", "SF")

# Extract reporting quality
FL_REPORTING_QUALITY_SPECIES = data_quality(species_code = CODE_SPECIES_SELECTED, year_from = START_YEAR, year_to = END_YEAR)

# Add reporting quality to the data in wide format
FL_STD_DATA_SPECIES_TABLE = merge(FL_STD_DATA_SPECIES_TABLE, FL_REPORTING_QUALITY_SPECIES[, .(FLEET_CODE, YEAR, GEAR_CODE, SPECIES_CODE, REPORTING_QUALITY = SF)], by.x = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), by.y = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), all.x = TRUE) 

# Reorder to put RAISE_CODE and REPORTING_QUALITY at the end of the fields
setcolorder(FL_STD_DATA_SPECIES_TABLE, neworder = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SPECIES_CODE", "SCHOOL_TYPE_CODE", "MEASURE_TYPE_CODE", "FIRST_CLASS_LOW", "SIZE_INTERVAL", "NO_FISH", "KG_FISH", "RAISE_CODE", "REPORTING_QUALITY"))

# Add reporting quality to the data in melted format
FL_STD_DATA_SPECIES = merge(FL_STD_DATA_SPECIES, FL_REPORTING_QUALITY_SPECIES[, .(FLEET_CODE, YEAR, GEAR_CODE, SPECIES_CODE, REPORTING_QUALITY = SF)], by.x = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), by.y = c("YEAR", "FLEET_CODE", "GEAR_CODE", "SPECIES_CODE"), all.x = TRUE) 

# Reorder to put RAISE_CODE and REPORTING_QUALITY at the end of the fields
setcolorder(FL_STD_DATA_SPECIES, neworder = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SPECIES_CODE", "SCHOOL_TYPE_CODE", "MEASURE_TYPE_CODE", "CLASS_LOW", "CLASS_HIGH", "FISH_COUNT", "RAISE_CODE", "REPORTING_QUALITY"))

## Assuming observer size data are good
FL_STD_DATA_SPECIES_TABLE[GEAR_CODE %in% c("LLOB", "FLLOB", "ELLOB", "PSOB"), REPORTING_QUALITY := "0"]
FL_STD_DATA_SPECIES[GEAR_CODE %in% c("LLOB", "FLLOB", "ELLOB", "PSOB"), REPORTING_QUALITY := "0"]

# Missing quality scoring
# To input data quality in the database
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY), .(FISH_COUNT = floor(sum(FISH_COUNT))), keyby = .(FLEET_CODE, GEAR_CODE, RAISE_CODE)][order(-FISH_COUNT)]

# Checking quality scores for non regular area grids
# unique(FL_STD_DATA_SPECIES[FISHING_GROUND_CODE %in% LIST_NON_STANDARD_AREAS, .(REPORTING_QUALITY), keyby = .(FLEET_CODE, GEAR_CODE, SCHOOL_TYPE_CODE, FISHING_GROUND_CODE)])

l_info("Reporting quality added to the data!", "SF")