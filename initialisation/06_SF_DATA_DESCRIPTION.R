# Raw size-frequency data ####

# SF data reported for grids outside the Indian Ocean
SF_RAW_DATA_SPECIES_NOT_IO = SF_RAW_DATA_SPECIES[FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

# Merge with fishing grounds to get area type
# Excluding the data located outside the Indian Ocean
SF_DATA_SPECIES = merge(SF_DATA_SPECIES, CL_FISHING_GROUNDS, by.x = "FISHING_GROUND_CODE", by.y = "FISHING_GROUND_CODE", all.x = TRUE)

SF_SPATIAL_RESOLUTION = SF_DATA_SPECIES[, .(Strata = length(unique(FISHING_GROUND_CODE)), Samples = sum(FISH_COUNT)), keyby = .(`Grid type` = AREA_TYPE_CODE, `Raise code` = RAISE_CODE)]

# Regular grids
SF_REGULAR_GRIDS = unique(SF_DATA_SPECIES[substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6", "7", "8", "9"), .(FISHING_GROUND_CODE)])[order(FISHING_GROUND_CODE)]

SF_REGULAR_GRIDS[, `:=` (LON_MIN = min(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LON), LON_MAX = max(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LON), LAT_MIN = min(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LAT), LAT_MAX = max(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LAT)), by = .(FISHING_GROUND_CODE)]

SF_REGULAR_GRIDS[, LON_CENTROID := (LON_MIN + LON_MAX)/2]
SF_REGULAR_GRIDS[, LAT_CENTROID := (LAT_MIN + LAT_MAX)/2]

SF_SPATIAL_EXTENT_REGULAR_GRIDS = data.table(LON_MIN = min(REGULAR_GRIDS$LON_MIN), 
                                                 LON_MAX = max(REGULAR_GRIDS$LON_MAX), 
                                                 LAT_MIN = min(REGULAR_GRIDS$LAT_MIN), 
                                                 LAT_MAX = max(REGULAR_GRIDS$LAT_MAX)
)

SF_LONGITUDE_RANGE_REGULAR_GRIDS = paste0(SPATIAL_EXTENT_REGULAR_GRIDS$LON_MIN, "\u00b0 to ", SPATIAL_EXTENT_REGULAR_GRIDS$LON_MAX, "\u00b0")

SF_LATITUDE_RANGE_REGULAR_GRIDS = paste0(SPATIAL_EXTENT_REGULAR_GRIDS$LAT_MIN, "\u00b0 to ", SPATIAL_EXTENT_REGULAR_GRIDS$LAT_MAX, "\u00b0")

# Irregular areas
SF_NON_REGULAR_AREAS = unique(SF_DATA_SPECIES[!substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6", "7", "8", "9"), .(AREA_TYPE_CODE, FISHING_GROUND_CODE)])

# Add dates
SF_DATA_SPECIES[, DATE_START := as.Date(paste(YEAR, MONTH_START, "1", sep = "-"))]
SF_DATA_SPECIES[, DATE_END := ceiling_date(as.Date(paste(YEAR, MONTH_END, "1", sep = "-")), "month") - 1]

# Temporal resolution
SF_DATA_SPECIES[, MONTH_DIFF := MONTH_END - MONTH_START + 1]

SF_TEMPORAL_RESOLUTION = SF_DATA_SPECIES[, .(Samples = sum(FISH_COUNT)), keyby = .(`Time period (mo)` = MONTH_DIFF, `Raise code` = RAISE_CODE)]
