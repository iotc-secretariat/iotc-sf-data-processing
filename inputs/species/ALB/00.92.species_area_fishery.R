SA_AREAS_ALB = query(DB_IOTC_MASTER(), "SELECT
           CODE,
           NAME_EN,
           NAME_FR,
           OCEAN_AREA_KM2 AS OCEAN_AREA,
           OCEAN_AREA_IO_KM2 AS IO_AREA,
           OCEAN_AREA_IOTC_KM2 AS IOTC_AREA,
           CENTER_LAT,
           CENTER_LON,
           AREA_GEOMETRY.STAsText() AS WKT
         FROM
           refs_gis.V_IO_STOCK_ASSESSMENT_AREAS 
         WHERE SUBSTRING(CODE, 4, 3) = 'ALB'
         AND SUBSTRING(CODE, 8, 3) NOT LIKE 'ALT'"
)

SA_AREAS_ALB_SF = st_as_sf(SA_AREAS_ALB, wkt = "WKT", crs = st_crs(4326))

SA_FISHERY_AREA_MAPPINGS_FILE = "FISHERY_AREA_MAPPINGS.csv"

SA_AREAS_CONFIG = data.table(
  IOTC_CODE  = c("IRALB01", "IRALB02", "IRALB03", "IRALB04"),
  AREA_CODE  = c("A1", "A2", "A3", "A4"),
  NAME_SHORT = c("Northwest",
                 "Northeast",
                 "Southwest",
                 "Southeast")
)

SA_AREAS_CONFIG[, AREA_NAME := paste0(AREA_CODE, " - ", NAME_SHORT)]
SA_AREAS_CONFIG_ORIG = copy(SA_AREAS_CONFIG)

postprocess_fishery = function(dataset) {
  dataset[, SF_FISHERY := fifelse(FISHERY %in% c("PS", "DN"), "PSPLGI", "LLOT")]
  dataset[, FISHERY := paste0(FISHERY, str_sub(AREA, -1))]
  
  return(dataset)
}

FISHERY_CODES = c("DN3", "DN4", "LL1", "LL2", "LL3", "LL4", "OT1", "OT2", "OT3", "OT4", "PS1", "PS2", "PS3", "PS4")

FISHERY_GROUP_NAMES = c("DN - Driftnets", 
                        "FLL - Fresh-tuna longlines", 
                        "LL - All other longlines", 
                        "PS - Industrial purse seines", 
                        "OT - Other gears")

update_fishery_groups = function(dataset) {
  dataset[, FISHERY_GROUP := "OT - Other gears"]
  dataset[GEAR_CODE == "PS", FISHERY_GROUP  := "PS - industrial purse seines"]
  dataset[GEAR_CODE == "FLL", FISHERY_GROUP := "FLL - fresh-tuna longlines"]
  dataset[GEAR_CODE == "GILL" & FLEET == "TWN", FISHERY_GROUP := "DN - Driftnets"]
  dataset[GEAR_CODE %in% c("LL", "LLCO", "ELL", "SLL", "LLEX"), FISHERY_GROUP := "LL - All other longliners"]
  
  dataset$FISHERY_GROUP = factor(
    dataset$FISHERY_GROUP,
    labels = FISHERY_GROUP_NAMES,
    levels = FISHERY_GROUP_NAMES,
    ordered = TRUE
  )
  
  return(dataset)
}