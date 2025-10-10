l_info("Filtering the code lists in the data...", "SF")

# Code lists restricted to the standardised dataset
CL_FLEETS_FL_DATA = CL_FLEETS[FLEET_CODE %in% unique(FL_STD_DATA_SPECIES$FLEET_CODE)]

CL_FISHING_GROUNDS_FL_DATA = CL_FISHING_GROUNDS[FISHING_GROUND_CODE %in% unique(FL_STD_DATA_SPECIES$FISHING_GROUND_CODE)]

CL_GEARS_FL_DATA = CL_GEARS[GEAR_CODE %in% unique(FL_STD_DATA_SPECIES$GEAR_CODE)]

CL_SCHOOL_TYPES_FL_DATA = CL_SCHOOL_TYPES[CATCH_SCHOOL_TYPE_CODE %in% unique(FL_STD_DATA_SPECIES$SCHOOL_TYPE_CODE)]

CL_RAISINGS_FL_DATA = CL_RAISINGS[RAISING_CODE %in% unique(FL_STD_DATA_SPECIES$RAISE_CODE)]

CL_MEASUREMENTS_FL_DATA = CL_MEASUREMENTS[MEASURE_TYPE_CODE %in% unique(FL_STD_DATA_SPECIES$MEASURE_TYPE_CODE)]

# Export all code lists as CSV files
write.csv(CL_FLEETS_FL_DATA, "../outputs/codelists/CL_FLEETS.csv", row.names = FALSE)
write.csv(CL_FISHING_GROUNDS_FL_DATA, "../outputs/codelists/CL_FISHING_GROUNDS.csv", row.names = FALSE)
write.csv(CL_GEARS_FL_DATA, "../outputs/codelists/CL_GEARS.csv", row.names = FALSE)
write.csv(CL_SCHOOL_TYPES_FL_DATA, "../outputs/codelists/CL_SCHOOL_TYPES.csv", row.names = FALSE)
write.csv(CL_RAISINGS_FL_DATA, "../outputs/codelists/CL_RAISINGS.csv", row.names = FALSE)
write.csv(CL_MEASUREMENTS_FL_DATA, "../outputs/codelists/CL_MEASUREMENTS.csv", row.names = FALSE)

l_info("Code lists in the data filtered!", "SF")