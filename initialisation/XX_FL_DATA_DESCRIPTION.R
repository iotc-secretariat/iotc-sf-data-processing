print("Initialisation of metadata...")

# Metadata from data contents
FL_STD_DATA_SPECIES_FOR_METADATA = copy(FL_STD_DATA_SPECIES)

# Add area type codes
FL_STD_DATA_SPECIES_FOR_METADATA = merge(FL_STD_DATA_SPECIES, CL_FISHING_GROUNDS, by.x = "FISHING_GROUND_CODE", by.y = "FISHING_GROUND_CODE")   # , all.x = TRUE - check FGC_DATASET_NOT_IN_CODE_LIST

# Global spatial resolution
SPATIAL_RESOLUTION = FL_STD_DATA_SPECIES_FOR_METADATA[, .(Strata = length(unique(FISHING_GROUND_CODE)), Samples = sum(FISH_COUNT)), keyby = .(`Area type code` = AREA_TYPE_CODE, `Raise code` = RAISE_CODE)]

# Regular grids
REGULAR_GRIDS = unique(FL_STD_DATA_SPECIES_FOR_METADATA[!AREA_TYPE_CODE %in% c("IRREGAREA", "GRID10x20"), .(AREA_TYPE_CODE, FISHING_GROUND_CODE)])

REGULAR_GRIDS[, `:=` (LON_MIN = min(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LON), 
                      LON_MAX = max(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LON), 
                      LAT_MIN = min(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LAT), 
                      LAT_MAX = max(CWP_to_grid_coordinates(FISHING_GROUND_CODE)$LAT)), by = .(FISHING_GROUND_CODE)]


SPATIAL_EXTENT_REGULAR_GRIDS = data.table(LON_MIN = min(REGULAR_GRIDS$LON_MIN), 
                                          LON_MAX = max(REGULAR_GRIDS$LON_MAX), 
                                          LAT_MIN = min(REGULAR_GRIDS$LAT_MIN), 
                                          LAT_MAX = max(REGULAR_GRIDS$LAT_MAX)
)

LONGITUDE_RANGE_REGULAR_GRIDS = paste0(SPATIAL_EXTENT_REGULAR_GRIDS$LON_MIN, "\u00b0 to ", SPATIAL_EXTENT_REGULAR_GRIDS$LON_MAX, "\u00b0")

LATITUDE_RANGE_REGULAR_GRIDS = paste0(SPATIAL_EXTENT_REGULAR_GRIDS$LAT_MIN, "\u00b0 to ", SPATIAL_EXTENT_REGULAR_GRIDS$LAT_MAX, "\u00b0")

# Irregular grids
IRREGULAR_GRIDS = unique(FL_STD_DATA_SPECIES_FOR_METADATA[AREA_TYPE_CODE %in% c("IRREGAREA", "GRID10x20"), .(AREA_TYPE_CODE, FISHING_GROUND_CODE, DESCRIPTION_EN, DESCRIPTION_FR)])

# Add dates
FL_STD_DATA_SPECIES[, DATE_START := as.Date(paste(YEAR, MONTH_START, "1", sep = "-"))]
FL_STD_DATA_SPECIES[, DATE_END := ceiling_date(as.Date(paste(YEAR, MONTH_END, "1", sep = "-")), "month") - 1]

# Temporal resolution
FL_STD_DATA_SPECIES_FOR_METADATA[, MONTH_DIFF := MONTH_END - MONTH_START + 1]

TEMPORAL_RESOLUTION = FL_STD_DATA_SPECIES_FOR_METADATA[, .(Samples = sum(FISH_COUNT)), keyby = .(`Time period (mo)` = MONTH_DIFF, `Raise code` = RAISE_CODE)]

print("Metadata initialised!")