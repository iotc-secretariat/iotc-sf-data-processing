# Function to insert the standardised SF dataset
# The data input (SF_data) is the output of the function standardize_and_pivot_size_frequencies()
# See iotc_base_common_std_sf_standardization.R in library iotc-lib-base-common-std
write_to_IOTDB = function(connection, table_name, SF_data) {
  query(
    connection,
    paste0("
      IF OBJECT_ID(N'", table_name, "', N'U') IS NOT NULL
      DROP TABLE ", table_name
    )
  )
  
  SF_data_updated = copy(SF_data)
  # Remove fields
  SF_data_updated[, `:=` (AVG_WEIGHT = NULL, RAISE_CODE = NULL)]
  
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

# Load the data in the IOTDB database
write_to_IOTDB(DB_IOTDB(), paste0("vwSF", CODE_SPECIES_SELECTED), FL_STD_DATA_SPECIES_TABLE)

