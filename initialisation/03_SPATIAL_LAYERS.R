l_info("Reading the spatial layers", prefix = "CL")

# From FAO GeoServer ####

# Connect to FAO GeoServer
WFS = ows4R::WFSClient$new(url = "https://www.fao.org/fishery/geoserver/wfs", serviceVersion = "1.0.0", logger = "INFO")

## IOTC Spatial Layers ####
IO_AREA         = WFS$getFeatures("iotc:iotc_indian_ocean_areas_lowres") %>% filter(gml_id == "iotc_indian_ocean_areas_lowres.1")
IOTC_AREA       = WFS$getFeatures("rfb:RFB_IOTC")
IOTC_MAIN_AREAS = WFS$getFeatures("gta:cl_nc_areas") %>% filter(code %in% c("IOTC_EAST", "IOTC_WEST"))

## CWP Grids ####
cwp11 = WFS$getFeatures("cwp:cwp-grid-map-1deg_x_1deg")
cwp55 = WFS$getFeatures("cwp:cwp-grid-map-5deg_x_5deg")
CWP   = dplyr::bind_rows(cwp11, cwp55)

# From Local Shapefiles ####

## COUNTRIES ####
# if(!file.exists("../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip")){
#   download.file("https://data.iotc.org/reference/latest/domain/admin/shapefiles/COUNTRY_AREAS_1.0.0_SHP.zip", destfile = "../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip", mode = "wb")
#   unzip("../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip", exdir = "../inputs/shapes/")}

#COUNTRY_AREAS_SF = st_read("../inputs/shapes/COUNTRY_AREAS_1.0.0.shp")

## IOTC GRIDS ####

## 1x1 GRID ####
if(!file.exists("../inputs/shapes/IO_GRIDS_01x01_1.0.0_SHP.zip")){
  download.file("https://data.iotc.org/reference/latest/domain/admin/shapefiles/IO_GRIDS_01x01_1.0.0_SHP.zip", destfile = "../inputs/shapes/IO_GRIDS_01x01_1.0.0_SHP.zip", mode = "wb")
  unzip("../inputs/shapes/IO_GRIDS_01x01_1.0.0_SHP.zip", exdir = "../inputs/shapes/")}

IOTC_1x1_GRID_SF = st_read("../inputs/shapes/IO_GRIDS_01x01_1.0.0.shp", crs = st_crs(4326))

## 5x5 GRID ####
if(!file.exists("../inputs/shapes/IO_GRIDS_05x05_1.0.0_SHP.zip")){
  download.file("https://data.iotc.org/reference/latest/domain/admin/shapefiles/IO_GRIDS_05x05_1.0.0_SHP.zip", destfile = "../inputs/shapes/IO_GRIDS_05x05_1.0.0_SHP.zip", mode = "wb")
  unzip("../inputs/shapes/IO_GRIDS_05x05_1.0.0_SHP.zip", exdir = "../inputs/shapes/")}

IOTC_5x5_GRID_SF = st_read("../inputs/shapes/IO_GRIDS_05x05_1.0.0.shp", crs = st_crs(4326))

# From IOTC databases

IO_SF_GRID_LIST = query(DB_IOTC_MASTER(), "SELECT DISTINCT CODE, NAME_EN FROM refs_gis.V_IO_GRIDS_CE_SF;")

# Spatial layer of non standard grids (i.e., different than 1x1 and 5x5 grids)
# LIST_SF_NON_STANDARD_AREAS derived in 03_SF_RAW_DATA_EXTRACTION.R
SF_NON_STANDARD_AREAS =
  query(
    C_REFERENCE_DATA, paste0("
    SELECT
      code,
      name_en,
      ST_AsText(area_geometry) AS wkt_geom
    FROM
      refs_gis.areas
    WHERE
      code IN ('", paste(LIST_NON_STANDARD_AREAS, collapse = "', '"), "')"
    ))

SF_NON_STANDARD_AREAS_SF = st_as_sf(SF_NON_STANDARD_AREAS, wkt = "wkt_geom", crs = st_crs(4326))

# Spatial layer of 1x1 grids in the size dataset and not in the Indian Ocean
# Converted to 5x5 grids for visualisation purpose
# SF_1x1_GRIDS_NOT_IN_IO =
#   query(
#     C_MASTER, paste0("
#     SELECT
#       CODE,
#       NAME_EN,
#       AREA_GEOMETRY.STAsText() AS WKT_GEOM
#     FROM
#       refs_gis.AREAS
#     WHERE
#       CODE IN ('", paste(GRID_1x1_NOT_IN_IO$CWP55, collapse = "', '"), "')"
#     ))
# 
# SF_1x1_GRIDS_NOT_IN_IO_SF = st_as_sf(SF_1x1_GRIDS_NOT_IN_IO, wkt = "WKT_GEOM", crs = st_crs(4326))

l_info("Spatial layers loaded for analysis and mapping", prefix = "CL")



