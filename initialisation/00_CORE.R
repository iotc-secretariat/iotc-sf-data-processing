# Clears the environment
rm(list = ls())

# To avoid switch to scientific notation
options(scipen = 100)

# Load libraries
source("90_LIBS.R")
source("91_TABLEFORMAT_FUNCTION.R")
source("92_STANDARD_SIZE_DATASET_FORMAT_CONVERTER.R")

# Define species of interest
CODE_SPECIES_SELECTED = 'ALB'

# Load scripts
source("01_CL_EXTRACTION.R")
source("02_SF_DATA_EXTRACTION.R")
source("03_SF_DATA_PROCESSING.R")
source("04_SF_DATA_QUALITY_COMPLETION.R")
source("05_CL_FILTERING.R")
source("06_SF_DATA_DESCRIPTION.R")

# Define dataset name
# DATASET_NAME = "IOTC-2024-WPTT26(AS) - YFT - SF frequencies"
# 
# # Source the scripts
# source("01_SA_PARAMETERS_YFT.R")
# source("02_DATA_EXTRACTION.R")
# source("03_DATA_PROCESS.R")
# source("04_SPATIAL_LAYERS.R")
# source("05_SF_NON_REGULAR_AREAS.R")
# source("06_MAPS.R")
