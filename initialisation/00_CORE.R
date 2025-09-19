# Clears the environment
rm(list = ls())

# To avoid switch to scientific notation
options(scipen = 9999)

# Load libraries
source("90_LIBS.R")
source("91_TABLEFORMAT_FUNCTION.R")
source("92_STANDARD_SIZE_DATASET_FORMAT_CONVERTER.R")

# Define species of interest
CODE_SPECIES_SELECTED = 'BET'

# Define connection to postgres version of the code list database
C_REFERENCE_DATA = 
  DBI::dbConnect(drv = RPostgres::Postgres(),
                 host = Sys.getenv("IOTC_REFERENCE_DATA_DB_SERVER"),
                 dbname = 'IOTC_ReferenceData_2025_07_23',
                 port = 5432,
                 user = Sys.getenv("IOTC_REFERENCE_DATA_DB_USER"),
                 password = Sys.getenv("IOTC_REFERENCE_DATA_DB_PWD")
  )

# Source scripts
source("01_CL_EXTRACTION.R")
source("02_SF_DATA_EXTRACTION.R")
source("03_SF_DATA_PROCESSING.R")
source("04_SF_DATA_PROCESSING_DESCRIPTION.R")
source("05_SF_DATA_QUALITY.R")
source("06_SPATIAL_LAYERS.R")


