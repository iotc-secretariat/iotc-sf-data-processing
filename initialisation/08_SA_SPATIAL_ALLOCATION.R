# Spatial Intersections ####

# Intersections between grids and SA areas
# Issue: Only 5x5 grid areas in intersection file
intersection_sa_swo_grid55 = intersections[layer1 %in% "iotc:iotc_assessment_sa_lowres" & code1 %in% grep("SA_SWO_", code1, value = TRUE)] #& layer2 %in% c("cwp:cwp-grid-map-1deg_x_1deg", "cwp:cwp-grid-map-5deg_x_5deg")]

# Compute proportions
intersection_sa_swo_grid55[, surface1_prop := surface/surface1]
intersection_sa_swo_grid55[, surface2_prop := surface/surface2]

## All fishing grounds in SF dataset to SA Area configuration 1 ####

# Version 1 - Only regular gridded data
# Excluding 10x20 as missing from intersection file (need to build intersection file)

SF_SA_DATASET_V1 = copy(FL_STD_DATA_SPECIES)

# Select regular 1x1 and 5x5 grids
SF_SA_DATASET_V1 = SF_SA_DATASET_V1[substr(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6")]

# Convert 1x1 grids to 5x5 grids
SF_SA_DATASET_V1[, FISHING_GROUND_CODE := convert_CWP_grid(FISHING_GROUND_CODE, target_grid_type_code = grid_5x5), by = .(FISHING_GROUND_CODE)]

SF_SA_DATASET_V1_AREA = merge(SF_SA_DATASET_V1, intersection_sa_swo_grid55[, .(source_code = code2, sa_area = code1, surface2_prop)], by.x = "FISHING_GROUND_CODE", by.y = "source_code", all.x = TRUE, allow.cartesian = TRUE)

SF_SA_DATASET_V1_AREA[, FISH_COUNT := FISH_COUNT * surface2_prop]

SF_SA_DATASET_V1_AREA = SF_SA_DATASET_V1_AREA[, -c("FISHING_GROUND_CODE", "surface2_prop")]

# conservation of numbers to check - 2625345 vs. 2626268

# Version 2 - All spatial data ####


# Version 3 - 

# Define Fishery Types according to gears
FL_STD_DATA_SPECIES_TABLE = merge(FL_STD_DATA_SPECIES_TABLE, CL_GEAR_TO_FISHERY_TYPE_MAPPING, by = "GEAR_CODE")

# Assignment of NJAs for coastal fisheries
#FL_STD_DATA_SPECIES_TABLE[FISHERY_TYPE_CODE == ]

# Allocation of NJA to intersected CWP grids






# raised_dataset_art = raised_dataset[FISHERY_TYPE_CODE == "ART", -c("FISHING_GROUND_CODE")] # Catches restricted to NJAs
# raised_dataset_art[, ASSIGNED_AREA := paste0("NJA_", FLEET_CODE)]
# raised_dataset_art[!FLEET_CODE %in% iotc_entities$ISO3_CODE, FLEET_CODE := 'OTH'] # Non-IOTC members: "BHR" "DJI" "EGY" "JOR" "QAT" "SUN" "TLS"

# Longline and Surface Fisheries ####
# raised_dataset_ind = raised_dataset[FISHERY_TYPE_CODE == "IND"]
# 
# raised_dataset_ind_with_areas = merge(raised_dataset_ind, io_wja_cwp[, .(source_code = code2, ASSIGNED_AREA = code1, surface2_prop)], by.x = "FISHING_GROUND_CODE", by.y = "source_code", all.x = TRUE, allow.cartesian = TRUE)
# 
# # Catches allocated
# raised_dataset_ind_allocated = raised_dataset_ind_with_areas[!is.na(ASSIGNED_AREA)]
# raised_dataset_ind_allocated[, CATCH_MT := CATCH_MT * surface2_prop]
# raised_dataset_ind_allocated = raised_dataset_ind_allocated[, -c("FISHING_GROUND_CODE", "surface2_prop")][]
# 
# # Catches not allocated due to wrong CWP grids (e.g., on land)
# raised_dataset_ind_non_allocated = raised_dataset_ind_with_areas[is.na(ASSIGNED_AREA), -c("ASSIGNED_AREA", "surface2_prop")]
# 
# raised_dataset_allocated = rbindlist(list(raised_dataset_art, raised_dataset_ind_allocated))

## All fishing grounds in SF dataset to SA Area configuration 2 ####

