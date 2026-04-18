l_info("Creating the datasets for the Working Parties...", "SF")

# Legacy Format
LEGACY_FL_STD_DATA_SPECIES_TABLE = copy(FL_STD_DATA_SPECIES_TABLE)[, -c("RAISE_CODE", "REPORTING_QUALITY", "AVG_WEIGHT")]

setnames(LEGACY_FL_STD_DATA_SPECIES_TABLE, old = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SPECIES_CODE", "SCHOOL_TYPE_CODE", "MEASURE_TYPE_CODE", "FIRST_CLASS_LOW", "SIZE_INTERVAL", "NO_FISH", "KG_FISH"), new = c("Fleet", "Year", "MonthStart", "MonthEnd", "Grid", "Gear", "Species", "SchoolType", "MeasureType", "FirstClassLow", "SizeInterval", "TnoFish", "TkgFish")
         )

# # Extract the data
# SF_STD = SF_est(species_code = CODE_SPECIES_SELECTED, years = START_YEAR:END_YEAR,  factorize_results = TRUE)
# 
# # Temp fix to update measure type code
# if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO")) {SF_STD[, MEASURE_TYPE_CODE := "LJ"]}
# 
# # Temp fix to add Legacy Fishery Groups
# SF_STD[FISHERY_CODE %in% c("LLD", "LLO", "LLF"), `:=` (FISHERY_GROUP_CODE = "LL", FISHERY_GROUP = "Longline")]
# 
# SF_STD[FISHERY_CODE %in% c("PSFS", "PSLS", "PSOT"), `:=` (FISHERY_GROUP_CODE = "PS", FISHERY_GROUP = "Purse seine")]
# 
# SF_STD[FISHERY_CODE %in% c("LIT", "LIH", "LIC"), `:=` (FISHERY_GROUP_CODE = "LI", FISHERY_GROUP = "Line")]
# 
# SF_STD[FISHERY_CODE == "BB", `:=` (FISHERY_GROUP_CODE = "BB", FISHERY_GROUP = "Baitboat")]
# 
# SF_STD[FISHERY_CODE == "GN", `:=` (FISHERY_GROUP_CODE = "GN", FISHERY_GROUP = "Gillnet")]
# 
# SF_STD[FISHERY_CODE == "OT", `:=` (FISHERY_GROUP_CODE = "OT", FISHERY_GROUP = "Other")]
# 
# # Select fields
# SF_STD_FOR_WPS = SF_STD[, .(FISH_COUNT = sum(FISH_COUNT)), keyby = .(YEAR, MONTH_START, MONTH_END, FLEET_CODE, FLEET, FISHERY_TYPE_CODE, FISHERY_TYPE, FISHERY_GROUP_CODE, FISHERY_GROUP, GEAR_CODE, GEAR, FISHERY_CODE, FISHERY, FISHING_GROUND_CODE, SPECIES_CATEGORY, SPECIES_CATEGORY_CODE, SPECIES_CODE, SPECIES, MEASURE_TYPE_CODE, MEASURE_TYPE, MEASURE_UNIT_CODE, CLASS_HIGH, CLASS_LOW, RAISE_CODE, SPECIES_SCIENTIFIC)]
# 
# # Export the file
# write.csv(x = SF_STD_FOR_WPS, file = paste0("../outputs/data/", TITLE, "-WP.csv"), row.names = FALSE)

l_info("Working Party datasets produced...", "SF")



