# Generates the standardized SF data files for the most common IOTC and bycatch species
library(iotc.base.common.std)
library(openxlsx)

PUBLIC_DATASETS_FOLDER = "Z:/03_Data/07_Data_dissemination/02_Public_datasets/"

CURRENT_DATE = Sys.Date()

CURRENT_FOLDER = paste0(PUBLIC_DATASETS_FOLDER, year(CURRENT_DATE), "/", CURRENT_DATE)

if (!dir.exists(CURRENT_FOLDER)) dir.create(CURRENT_FOLDER)

ORIGINAL_FOLDER = paste0(PUBLIC_DATASETS_FOLDER, year(CURRENT_DATE), "/", CURRENT_DATE, "/original/")

if (!dir.exists(ORIGINAL_FOLDER)) dir.create(ORIGINAL_FOLDER)

FILE_SUFFIX = CURRENT_DATE

save_xlsx = function(features_metadata,
                     spatial_metadata,
                     temporal_metadata,
                     fleet_metadata,
                     gear_metadata,
                     school_type_metadata,
                     data,
                     folder = CURRENT_FOLDER,
                     output_filename) {

  TEMPLATE = loadWorkbook(paste0(PUBLIC_DATASETS_FOLDER, "IOTC-DATASETS-YYYY-MM-DD-SF-[species]_1950-yyyy.xlsx"))

  writeDataTable(wb = TEMPLATE, sheet = "FEATURES",            features_metadata,    startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "SPATIAL_RESOLUTION",  spatial_metadata,     startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "TEMPORAL_RESOLUTION", temporal_metadata,    startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "FLEET_CODES",         fleet_metadata,       startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "GEAR_CODES",          gear_metadata,        startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "SCHOOL_TYPE_CODES",   school_type_metadata, startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")
  writeDataTable(wb = TEMPLATE, sheet = "DATA",                data,                 startRow = 1, startCol = 1, colNames = TRUE, tableStyle = "TableStyleLight11")

  setColWidths(wb = TEMPLATE, sheet = "FEATURES",            cols = 1:50, widths = "auto")
  setColWidths(wb = TEMPLATE, sheet = "SPATIAL_RESOLUTION",  cols = 1:4,  widths = "auto")
  setColWidths(wb = TEMPLATE, sheet = "TEMPORAL_RESOLUTION", cols = 1:3,  widths = "auto")
  setColWidths(wb = TEMPLATE, sheet = "FLEET_CODES",         cols = 1:4,  widths = "auto")
  setColWidths(wb = TEMPLATE, sheet = "GEAR_CODES",          cols = 1:4,  widths = "auto")
  setColWidths(wb = TEMPLATE, sheet = "SCHOOL_TYPE_CODES",   cols = 1:4,  widths = "auto")

  activeSheet(TEMPLATE) = "FEATURES"

  saveWorkbook(TEMPLATE, paste0(folder, "/original/", output_filename), overwrite = TRUE)

  zip::zipr(zipfile = str_replace(paste0(folder, "/", output_filename), "xlsx", "zip"),
            files   = paste0(folder, "/original/", output_filename), include_directories = FALSE)
}

write_to_IOTDB = function(connection, table_name, SF_data) {
  query(
    connection,
    paste0("
      IF OBJECT_ID(N'", table_name, "', N'U') IS NOT NULL
      DROP TABLE ", table_name
    )
  )

  SF_data_updated = copy(SF_data)
  SF_data_updated$AVG_WEIGHT = NULL

  column_names = append(
    c("Fleet",
      "Year",
      "MonthStart",
      "MonthEnd",
      "Grid",
      "Gear",
      "Species",
      "SchoolType",
      "MeasureType",
      "FirstClassLow",
      "SizeInterval",
      "TnoFish",
      "TkgFish"
    ),
    colnames(SF_data_updated)[14:163]
  )

  colnames(SF_data_updated) = column_names

  dbWriteTable(connection, table_name, SF_data_updated)
}

IOTDB_connection = DB_IOTDB()

ALL_SPECIES =
  query(
    connection = DB_IOTDB(),
    query = "
    SELECT DISTINCT  --DISTINCT added by manu 24/04/2023
      E.[Group] AS SPECIES_GROUP_CODE,
      E.Species AS SPECIES_CODE,
      S.NAME_EN AS SPECIES_NAME_EN,
      S.NAME_LT AS SPECIES_SCIENTIFIC_NAME,
      E.StdSizeCode AS LENGTH_CODE,
      CASE
        WHEN E.StdSizeCode = 'FL' THEN 'Fork length'
        WHEN E.StdSizeCode = 'EFL' THEN 'Eye-fork length'
  	  ELSE
        M.EngDescr
    	END AS LENGTH_NAME_EN,
      E.MaxStdSize AS MAX_SIZE,
      E.StdSizeClassInt AS STANDARD_BIN_SIZE,
      E.MaxSizeClassInt AS MAX_BIN_SIZE,
      E.FirstSizeClass AS FIRST_SIZE_CLASS
    FROM
      estSpecies E
    LEFT JOIN
      [IOTDB].[meta].SPECIES S
    ON
      E.Species = S.CODE
    LEFT JOIN
    	[IOTDB].[dbo].cdeMeasTypes M
    ON
    	E.StdSizeCode = M.ACode
    WHERE
      --S.IOTDB_CODE IN ('BET', 'SKJ', 'YFT') AND
      S.IOTDB_CODE NOT IN ('SKJS', 'SKJM', 'SKJL',
                           'YFTS', 'YFTM', 'YFTL')
    ")

ALL_FLEETS = query(
  connection = IOTDB_connection, #DB_IOTDB(),
  query = "
    SELECT DISTINCT
      CODE AS FLEET_CODE,
      NAME_EN AS FLEET_NAME_EN
    FROM
      [meta].FLEETS
  "
)

ALL_GEARS = query(
  connection = IOTDB_connection, #DB_IOTDB(),
  query = "
    SELECT DISTINCT
      CODE AS GEAR_CODE,
      NAME_EN AS GEAR_NAME_EN
    FROM
      [meta].GEARS
  "
)

ALL_SCHOOL_TYPES = query(
  connection = IOTDB_connection, #DB_IOTDB(),
  query = "
    SELECT DISTINCT
      ACode AS SCHOOL_TYPE_CODE,
      EngDescr AS SCHOOL_TYPE_NAME_EN
    FROM
      [dbo].cdeSchoolTypes
  "
)

BILLFISH_SPECIES= ALL_SPECIES[SPECIES_GROUP_CODE == "BIL"]
NERITIC_SPECIES = ALL_SPECIES[SPECIES_GROUP_CODE == "NER"]
SHARK_SPECIES   = ALL_SPECIES[SPECIES_GROUP_CODE == "SKH"]
IOTC_SPECIES    = ALL_SPECIES[SPECIES_GROUP_CODE != "SKH"]

produce_species_features_metadata = function(species) {
  current_species_features_metadata = data.table(FEATURE_NAME = character(), FEATURE_VALUE = character())
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Species",
                                                 FEATURE_VALUE = paste0(species$SPECIES_NAME_EN, " (", species$SPECIES_SCIENTIFIC_NAME, ")")))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Species code",
                                                 FEATURE_VALUE = species$SPECIES_CODE))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Standard size",
                                                 FEATURE_VALUE = species$LENGTH_NAME_EN))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Standard size code",
                                                 FEATURE_VALUE = species$LENGTH_CODE))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Unit",
                                                 FEATURE_VALUE = "cm"))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Maximum standard size",
                                                 FEATURE_VALUE = species$MAX_SIZE))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "First standard size class",
                                                 FEATURE_VALUE = species$FIRST_SIZE_CLASS))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Size class interval",
                                                 FEATURE_VALUE = species$STANDARD_BIN_SIZE))
  current_species_features_metadata = rbind(current_species_features_metadata,
                                            list(FEATURE_NAME = "Maximum size class interval",
                                                 FEATURE_VALUE = species$MAX_BIN_SIZE))

  return(
    current_species_features_metadata
  )
}

produce_multiple_species_features_metadata = function(multiple_species) {
  species_features_metadata =
    data.table(FEATURE_NAME =  c("Species",
                                 "Species code",
                                 "Standard size",
                                 "Standard size code",
                                 "Unit",
                                 "Maximum standard size",
                                 "First standard size class",
                                 "Size class interval",
                                 "Maximum size class interval")
    )

  for(species_code in multiple_species$SPECIES_CODE) {
    species = multiple_species[SPECIES_CODE == species_code]

    feature_value_column = paste0("FEATURE_VALUE_", species$SPECIES_CODE)
    features = c(paste0(species$SPECIES_NAME_EN, " (", species$SPECIES_SCIENTIFIC_NAME, ")"),
                 species$SPECIES_CODE,
                 species$LENGTH_NAME_EN,
                 species$LENGTH_CODE,
                 "cm",
                 species$MAX_SIZE,
                 species$FIRST_SIZE_CLASS,
                 species$STANDARD_BIN_SIZE,
                 species$MAX_BIN_SIZE)

    species_features_metadata[, feature_value_column] = features
  }

  return(
    species_features_metadata
  )
}

produce_spatial_metadata = function(data) {
    processed = copy(data)
    processed[, GRID_TYPE_CODE := str_sub(FISHING_GROUND_CODE, end = 1)]
    processed[GRID_TYPE_CODE == "9", GRID_TYPE_CODE := "19"]
    processed$GRID_TYPE_CODE = as.integer(processed$GRID_TYPE_CODE)
    processed[GRID_TYPE_CODE == 1,  RESOLUTION := "GRID30x30"]
    processed[GRID_TYPE_CODE == 2,  RESOLUTION := "GRID10x20"]
    processed[GRID_TYPE_CODE == 3,  RESOLUTION := "GRID10x10"]
    processed[GRID_TYPE_CODE == 4,  RESOLUTION := "GRID20x20"]
    processed[GRID_TYPE_CODE == 5,  RESOLUTION := "GRID1x1"]
    processed[GRID_TYPE_CODE == 6,  RESOLUTION := "GRID5x5"]
    processed[GRID_TYPE_CODE == 19, RESOLUTION := "FAO statistical areas"]

    return(
      processed[, .(NUM_STRATA = .N, NUM_SAMPLES = round(sum(NO_FISH, na.rm = TRUE), 0)), keyby = .(GRID_TYPE_CODE, RESOLUTION)]
    )
}

produce_temporal_metadata = function(data) {
  processed = copy(data)
  processed[, TIME_PERIOD_MONTHS := MONTH_END - MONTH_START + 1]

  return(
    processed[, .(NUM_STRATA = .N, NUM_SAMPLES = round(sum(NO_FISH, na.rm = TRUE), 0)), keyby = .(TIME_PERIOD_MONTHS)][order(TIME_PERIOD_MONTHS)]
  )
}

produce_fleet_metadata = function(data) {
  processed = copy(data)

  processed = processed[, .(NUM_STRATA = .N, NUM_SAMPLES = round(sum(NO_FISH, na.rm = TRUE), 0)), keyby = .(FLEET_CODE)]

  processed = merge.data.table(processed, ALL_FLEETS,
                               by.x = "FLEET_CODE", by.y = "FLEET_CODE",
                               all.x = TRUE)

  return(
    processed[, .(FLEET_CODE, FLEET_NAME_EN, NUM_STRATA, NUM_SAMPLES)][order(FLEET_CODE)]
  )
}

produce_gear_metadata = function(data) {
  processed = copy(data)

  processed = processed[, .(NUM_STRATA = .N, NUM_SAMPLES = round(sum(NO_FISH, na.rm = TRUE), 0)), keyby = .(GEAR_CODE)]

  processed = merge.data.table(processed, ALL_GEARS,
                               by.x = "GEAR_CODE", by.y = "GEAR_CODE",
                               all.x = TRUE)

  return(
    processed[, .(GEAR_CODE, GEAR_NAME_EN, NUM_STRATA, NUM_SAMPLES)][order(GEAR_CODE)]
  )
}

produce_school_type_metadata = function(data) {
  processed = copy(data)

  processed = processed[, .(NUM_STRATA = .N, NUM_SAMPLES = round(sum(NO_FISH, na.rm = TRUE), 0)), keyby = .(SCHOOL_TYPE_CODE)]

  processed = merge.data.table(processed, ALL_SCHOOL_TYPES,
                               by.x = "SCHOOL_TYPE_CODE", by.y = "SCHOOL_TYPE_CODE",
                               all.x = TRUE)

  return(
    processed[, .(SCHOOL_TYPE_CODE, SCHOOL_TYPE_NAME_EN, NUM_STRATA, NUM_SAMPLES)][order(SCHOOL_TYPE_CODE)]
  )
}

for(species in IOTC_SPECIES$SPECIES_CODE) {
  l_info(paste0("Processing S-F data for ", species))

  SF_raw = SF.raw(connection = IOTDB_connection, species_codes = species)

  current_species = IOTC_SPECIES[SPECIES_CODE == species]

  OUTPUT_FILENAME = paste0("IOTC-DATASETS-", FILE_SUFFIX, "-SF-",
                           species, "-", min(SF_raw$YEAR), "-", max(SF_raw$YEAR), ".xlsx")

  if(nrow(SF_raw) == 0) {
    l_warn(paste0("No raw S-F data for ", species))
  } else {
    current_species_sf =
      standardize_and_pivot_size_frequencies(
        SF_raw,
        bin_size = current_species$STANDARD_BIN_SIZE,
        max_bin_size = current_species$MAX_BIN_SIZE,
        first_class_low = current_species$FIRST_SIZE_CLASS
      )

    if(nrow(current_species_sf) > 0) {
      save_xlsx(produce_species_features_metadata(current_species),
                produce_spatial_metadata         (current_species_sf),
                produce_temporal_metadata        (current_species_sf),
                produce_fleet_metadata           (current_species_sf),
                produce_gear_metadata            (current_species_sf),
                produce_school_type_metadata     (current_species_sf),
                current_species_sf,
                CURRENT_FOLDER,
                OUTPUT_FILENAME)

      write_to_IOTDB(IOTDB_connection, paste0("vwSF", species), current_species_sf)
    }
  }
}

l_info("Processing S-F data for BILLFISH")

SF_billfish = SF.raw(species_codes = c("BLM", "BUM", "MLS", "SFA", "SWO"))

billfish_sf =
  standardize_and_pivot_size_frequencies(
    SF_billfish,
    bin_size        =  3,
    max_bin_size    =  5,
    first_class_low = 15,
  )

OUTPUT_FILENAME = paste0("IOTC-DATASETS-", FILE_SUFFIX, "-SF-",
                         "BIL", "-", min(billfish_sf$YEAR), "-", max(billfish_sf$YEAR), ".xlsx")

save_xlsx(produce_multiple_species_features_metadata(BILLFISH_SPECIES),
          produce_spatial_metadata(billfish_sf),
          produce_temporal_metadata(billfish_sf),
          produce_fleet_metadata(billfish_sf),
          produce_gear_metadata(billfish_sf),
          produce_school_type_metadata(billfish_sf),
          billfish_sf,
          CURRENT_FOLDER,
          OUTPUT_FILENAME)

write_to_IOTDB(IOTDB_connection, "vwSFBIL", billfish_sf)

l_info("Processing S-F data for NERITICS")

SF_neritics = SF.raw(species_codes = unique(NERITIC_SPECIES$SPECIES_CODE))
#SF_neritics[SPECIES_CODE == "UNCL", SPECIES_CODE := "PSK"] # TO BE FIXED BY ADDING PSK TO THE LIST OF FACTORISED SHARK SPECIES

neritics_sf =
  standardize_and_pivot_size_frequencies(
    SF_neritics[SPECIES_CODE %in% c("LOT", "COM", "GUT")],
    bin_size        =  1,
    max_bin_size    =  3,
    first_class_low = 10,
  )

neritics_sf =
  rbind(
    neritics_sf,
    standardize_and_pivot_size_frequencies(
      SF_neritics[SPECIES_CODE %in% c("KAW", "FRI", "BLT")],
      bin_size        =  1,
      max_bin_size    =  2,
      first_class_low = 10,
    )
  )

OUTPUT_FILENAME = paste0("IOTC-DATASETS-", FILE_SUFFIX, "-SF-",
                         "NER", "-", min(neritics_sf$YEAR), "-", max(neritics_sf$YEAR), ".xlsx")

save_xlsx(produce_multiple_species_features_metadata(NERITIC_SPECIES),
          produce_spatial_metadata(neritics_sf),
          produce_temporal_metadata(neritics_sf),
          produce_fleet_metadata(neritics_sf),
          produce_gear_metadata(neritics_sf),
          produce_school_type_metadata(neritics_sf),
          neritics_sf,
          CURRENT_FOLDER,
          OUTPUT_FILENAME)

write_to_IOTDB(IOTDB_connection, "vwSFNER", neritics_sf)

l_info("Processing S-F data for sharks")

SF_sharks = SF.raw(species_codes = unique(SHARK_SPECIES$SPECIES_CODE))
SF_sharks[SPECIES_CODE == "UNCL", SPECIES_CODE := "PSK"] # TO BE FIXED BY ADDING PSK TO THE LIST OF FACTORISED SHARK SPECIES

sharks_sf =
  standardize_and_pivot_size_frequencies(
    SF_sharks,
    bin_size        =  5,
    max_bin_size    = 10,
    first_class_low = 30,
  )

OUTPUT_FILENAME = paste0("IOTC-DATASETS-", FILE_SUFFIX, "-SF-",
                         "SKH", "-", min(sharks_sf$YEAR), "-", max(sharks_sf$YEAR), ".xlsx")

save_xlsx(produce_multiple_species_features_metadata(SHARK_SPECIES),
          produce_spatial_metadata(sharks_sf),
          produce_temporal_metadata(sharks_sf),
          produce_fleet_metadata(sharks_sf),
          produce_gear_metadata(sharks_sf),
          produce_school_type_metadata(sharks_sf),
          sharks_sf,
          CURRENT_FOLDER,
          OUTPUT_FILENAME)

write_to_IOTDB(IOTDB_connection, "vwSFSKH", sharks_sf)

