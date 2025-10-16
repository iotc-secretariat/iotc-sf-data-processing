l_info("Exporting the data and code lists", "SF")

# Species of interest
SPECIES_SELECTED = CL_SPECIES[SPECIES_CODE == CODE_SPECIES_SELECTED, SPECIES]

TITLE = paste("IOTC-DATASETS-SF", CODE_SPECIES_SELECTED, min(FL_STD_DATA_SPECIES$YEAR), max(FL_STD_DATA_SPECIES$YEAR), sep = "-")

# EXPORT FIELD AND CODELISTS ####

# Create empty workbook
STD_SF_DATA = createWorkbook("STD_SF_DATA")

# DATA FIELDS ####

# Read description of data fields

## Wide table format
FIELDS_STD_SF_DATA_TABLE = data.table(read.xlsx("../inputs/FIELDS_STD_SF_DATA.xlsx", sheet = "WIDE FORMAT FIELDS - CURRENT", sep.names = " "))[, .(FIELD, DEFINITION, `CODE LIST NAME`, `CODE LIST URL`)]

FIELDS_STD_SF_DATA_TABLE[!is.na(`CODE LIST NAME`), `CODE LIST` := paste0("<a href=\"", `CODE LIST URL`, "\">", `CODE LIST NAME`, "</a>")]

FIELDS_STD_SF_DATA_TABLE = FIELDS_STD_SF_DATA_TABLE[, -c("CODE LIST NAME", "CODE LIST URL")]

# Melted table format
FIELDS_STD_SF_DATA = data.table(read.xlsx("../inputs/FIELDS_STD_SF_DATA.xlsx", sheet = "MELTED FORMAT FIELDS - CURRENT", sep.names = " "))[, .(FIELD, DEFINITION, `CODE LIST NAME`, `CODE LIST URL`)]

# Add to workbook
addWorksheet(STD_SF_DATA, "WIDE FORMAT FIELDS")
writeDataTable(STD_SF_DATA, sheet = "WIDE FORMAT FIELDS", x = FIELDS_STD_SF_DATA_TABLE, rowNames = FALSE, tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "WIDE FORMAT FIELDS", cols = 1:ncol(FIELDS_STD_SF_DATA_TABLE), widths = "auto")

addWorksheet(STD_SF_DATA, "MELTED FORMAT FIELDS")
writeDataTable(STD_SF_DATA, sheet = "MELTED FORMAT FIELDS", x = FIELDS_STD_SF_DATA, rowNames = FALSE, tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "MELTED FORMAT FIELDS", cols = 1:ncol(FIELDS_STD_SF_DATA), widths = "auto")

# STANDARDIZED SF DATA ####

# CODE LISTS ####

## FLEETS ####
addWorksheet(STD_SF_DATA, "FLEETS")
writeDataTable(STD_SF_DATA, sheet = "FLEETS", x = CL_FLEETS_FL_DATA,  tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "FLEETS", cols = 1:nrow(CL_FLEETS), widths = "auto")

## IRREGULAR GRID ####
addWorksheet(STD_SF_DATA, "FISHING GROUNDS")
writeDataTable(STD_SF_DATA, sheet = "FISHING GROUNDS", x = CL_FISHING_GROUNDS_FL_DATA,  tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "FISHING GROUNDS", cols = 1:nrow(CL_FISHING_GROUNDS), widths = "auto")

## GEARS ####
addWorksheet(STD_SF_DATA, "GEARS")
writeDataTable(STD_SF_DATA, sheet = "GEARS", x = CL_GEARS_FL_DATA,  tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "GEARS", cols = 1:nrow(CL_GEARS), widths = "auto")

## SCHOOL TYPES ####
addWorksheet(STD_SF_DATA, "SCHOOL TYPES")
writeDataTable(STD_SF_DATA, "SCHOOL TYPES", CL_SCHOOL_TYPES_FL_DATA, tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "SCHOOL TYPES", cols = 1:nrow(CL_SCHOOL_TYPES), widths = "auto")

## MEASUREMENT TYPES ####
addWorksheet(STD_SF_DATA, "MEASUREMENTS")
writeDataTable(STD_SF_DATA, "MEASUREMENTS", CL_MEASUREMENTS_FL_DATA, tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "MEASUREMENTS", cols = 1:nrow(CL_MEASUREMENTS), widths = "auto")

## RAISINGS ####
addWorksheet(STD_SF_DATA, "RAISINGS")
writeDataTable(STD_SF_DATA, "RAISINGS", CL_RAISINGS_FL_DATA, tableStyle = "TableStyleLight11")
setColWidths(STD_SF_DATA, sheet = "RAISINGS", cols = 1:nrow(CL_RAISINGS), widths = "auto")

# Save the workbook
saveWorkbook(STD_SF_DATA, paste0("../outputs/data/", TITLE, "-DDD.xlsx"), overwrite = TRUE)

# EXPORT DATA AS CSV FILE ####

## MELTED FORMAT ####
write.csv(FL_STD_DATA_SPECIES, file = paste0("../outputs/data/", TITLE, "-MELTED-FORMAT.csv"), row.names = FALSE)

# File size in KB
STD_SF_MELTED_DATA_SIZE = round(file.size(paste0("../outputs/data/", TITLE, "-MELTED-FORMAT.csv"))/1e3)

## WIDE FORMAT ####
write.csv(FL_STD_DATA_SPECIES_TABLE, file = paste0("../outputs/data/", TITLE, "-WIDE-FORMAT.csv"), row.names = FALSE)

# File size in KB
STD_SF_TABLE_DATA_SIZE = round(file.size(paste0("../outputs/data/", TITLE, "-WIDE-FORMAT.csv"))/1e3)

# Zip the files
zip::zip(zipfile = paste0("../outputs/data/", TITLE, ".zip"), files = c(paste0("../outputs/data/", TITLE, "-WIDE-FORMAT.csv"), paste0("../outputs/data/", TITLE, "-MELTED-FORMAT.csv"), paste0("../outputs/data/", TITLE, "-DDD.xlsx")), mode = "cherry-pick", recurse = FALSE)
         
# Zipped file size in KB
STD_SF_DATA_ZIP_SIZE = round(file.size(paste0("../outputs/data/", TITLE, ".zip"))/1e3)

# Remove files after creating the archive
file.remove(paste0("../outputs/data/", TITLE, "-DDD.xlsx"))
file.remove(paste0("../outputs/data/", TITLE, "-MELTED-FORMAT.csv"))
file.remove(paste0("../outputs/data/", TITLE, "-WIDE-FORMAT.csv"))

l_info("Data and code lists exported!", "SF")
