# Libraries
library(this.path)

# Set the Working Directory
setwd(here())

# Select the species
CODE_SPECIES_SELECTED = "BET"
START_YEAR            = 1950
END_YEAR              = 2024

# Select the view in IOTDB
#VIEW = ifelse(CODE_SPECIES_SELECTED %in% c("BLT", "FRI", "KAW", "LOT", "COM", "GUT"), "vwSFNER", paste0("dbo.vwSF", CODE_SPECIES_SELECTED))

# Select the URL for the document on conversion factors and morphometric relationships
if(CODE_SPECIES_SELECTED %in% c("BET", "SKJ", "YFT")){
  TITLE_CONVERSION_DOCUMENT = "IOTC-2025-WPTT27-DATA08"
  URL_CONVERSION_DOCUMENT = "https://iotc.org/WPTT/27/Data/08-EQ"}

if(CODE_SPECIES_SELECTED %in% c("BLT", "FRI", "KAW", "LOT", "COM", "GUT"))
   {
  TITLE_CONVERSION_DOCUMENT = "IOTC-2022-WPNT12-DATA11"
  URL_CONVERSION_DOCUMENT = "https://www.iotc.org/WPNT/12/Data/11-Equations"
}

if(CODE_SPECIES_SELECTED %in% c("BLM", "BUM", "MLS", "SFA", "SWO"))
{
  TITLE_CONVERSION_DOCUMENT = "IOTC-2022-WPB20-DATA11"
  URL_CONVERSION_DOCUMENT = "https://www.iotc.org/WPB/20/Data/11-Equations"
}

if(CODE_SPECIES_SELECTED %in% c("ALB"))
{
  TITLE_CONVERSION_DOCUMENT = "IOTC-2025-WPTmT09(DP)-DATA11"
  URL_CONVERSION_DOCUMENT = "https://www.iotc.org/WPTmT/09DP/Data/11-Equations"
}

# Source the R codes
setwd("initialisation")
source("00_CORE.R")
setwd("..")

# HTML -  CURRENT
render("./rmd/SF_METADATA.Rmd", 
       output_format = "html_document2",
       output_file = paste0("METADATA_", TITLE, ".html"), 
       output_dir = "./outputs/html/",
       params = list(dynamictitle = paste("METADATA FOR THE STANDARDISED SIZE-FREQUENCY DATA FOR ", toupper(SPECIES_SELECTED))))

# Add HTML in archive
zip::zip_append(paste0("./outputs/data/", TITLE, ".zip"), files = paste0("./outputs/html/METADATA_", TITLE, ".html"), mode = "cherry-pick")

# Generic report
render("./rmd/SF_DESCRIPTION.Rmd", output_file = paste0("DESCRIPTION_", TITLE, ".docx"), 
       output_dir = "./outputs/docx/",
       params = list(dynamictitle = paste0("Standardisation of the size-frequency data for ", SPECIES_SELECTED, " ", START_YEAR, "--", END_YEAR))
)

# Temp RC METADATA
setwd("initialisation/")
source("90_LIBS.R")
source("91_LIBS_EXTERNAL.R")
#source("01_CL_EXTRACTION_RC.R")
source("08_RC_DATA_EXPORT.R")
setwd("..")

render("./rmd/RC_METADATA.Rmd", 
       output_format = "html_document2",
       output_file = paste0("METADATA_", TITLE, ".html"), 
       output_dir = "./outputs/html/",
       params = list(dynamictitle = paste("Metadata for Retained Catch Data")))




