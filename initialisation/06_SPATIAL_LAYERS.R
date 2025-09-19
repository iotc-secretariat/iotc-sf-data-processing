# COUNTRIES ####
if(!file.exists("../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip")){
  download.file("https://data.iotc.org/reference/latest/domain/admin/shapefiles/COUNTRY_AREAS_1.0.0_SHP.zip", destfile = "../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip", mode = "wb")
  unzip("../inputs/shapes/COUNTRY_AREAS_1.0.0_SHP.zip", exdir = "../inputs/shapes/")}

COUNTRY_AREAS_SF = st_read("../inputs/shapes/COUNTRY_AREAS_1.0.0.shp")

# IOTC GRIDS ####

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

# Spatial layer of non standard grids (i.e., different than 1x1 and 5x5 grids)
# LIST_SF_NON_STANDARD_AREAS derived in 02_SF_DATA_EXTRACTION.R
SF_NON_STANDARD_AREAS =
  query(
    DB_IOTC_MASTER(), paste0("
    SELECT
      CODE,
      NAME_EN,
      AREA_GEOMETRY.STAsText() AS WKT_GEOM
    FROM
      refs_gis.AREAS
    WHERE
      CODE IN ('", paste(LIST_NON_STANDARD_AREAS, collapse = "', '"), "')"
    ))

SF_NON_STANDARD_AREAS_SF = st_as_sf(SF_NON_STANDARD_AREAS, wkt = "WKT_GEOM", crs = st_crs(4326))

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




