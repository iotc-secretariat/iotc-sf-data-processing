# Libraries
library(this.path)

# Set the Working Directory
setwd(here())

# Select the species
CODE_SPECIES_SELECTED = "BET"

# Select the view in IOTDB
#VIEW = ifelse(CODE_SPECIES_SELECTED %in% c("BLT", "FRI", "KAW", "LOT", "COM", "GUT"), "vwSFNER", paste0("dbo.vwSF", CODE_SPECIES_SELECTED))

# Select the URL for the document on conversion factors and morphometric relationships
if(CODE_SPECIES_SELECTED %in% c("BET", "SKJ", "YFT")){
  TITLE_CONVERSION_DOCUMENT = "IOTC-2023-WPTT25(AS)-DATA13"
  URL_CONVERSION_DOCUMENT = "https://www.iotc.org/WPTT/25/Data/13-Equations"}

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
zip::zip_append(paste0("./outputs/", TITLE, ".zip"), files = paste0("./outputs/html/METADATA_", TITLE, ".html"), mode = "cherry-pick")

# Generic report
render("./rmd/SF_DESCRIPTION.Rmd", output_file = paste0("DESCRIPTION_", TITLE, ".docx"), 
       output_dir = "./outputs/docx/",
       params = list(dynamictitle = paste("Standardisation of the size-frequency data for ", SPECIES_SELECTED))
)
