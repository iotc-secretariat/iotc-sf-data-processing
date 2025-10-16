#SPECIES_SELECTED = CL_SPECIES[SPECIES_CODE == CODE_SPECIES_SELECTED, SPECIES]
#SPECIES_SELECTED = "Bigeye tuna"

#TITLE = paste("IOTC-DATASETS-RC", CODE_SPECIES_SELECTED, min(FL_STD_DATA_SPECIES$YEAR), max(FL_STD_DATA_SPECIES$YEAR), sep = "-")

#TITLE = paste("IOTC-DATASETS-RC", CODE_SPECIES_SELECTED, START_YEAR, END_YEAR, sep = "-")
#TITLE = paste0("IOTC-DATASETS-", Sys.Date(), "-RC-BSE_1950-2024")
TITLE = "IOTC-2025-WPTT27-DATA02_RC"

# Extract the data
RC_BSE = NC_est(years = START_YEAR:END_YEAR,  factorize_results = TRUE)[, .(CATCH = sum(CATCH)), keyby = .(YEAR, FISHING_GROUND_CODE, FISHING_GROUND, FLEET_CODE, FLEET, FISHERY_TYPE_CODE, FISHERY_TYPE, FISHERY_GROUP_CODE, FISHERY_GROUP, FISHERY_CODE, FISHERY, GEAR_CODE, GEAR, SPECIES_CATEGORY_CODE, SPECIES_CATEGORY, SPECIES_CODE, SPECIES, SPECIES_SCIENTIFIC, FATE_TYPE_CODE, FATE_TYPE, FATE_CODE, FATE, CATCH_UNIT_CODE)]
                                                                                            
# Export the file
write.csv(RC_BSE, paste0("../outputs/data/", TITLE, ".csv"), row.names = FALSE)

# File size in KB
RC_BSE_DATA_SIZE = round(file.size(paste0("../outputs/data/", TITLE, ".csv"))/1e3)

# EXPORT FIELD AND CODELISTS ####

# Create empty workbook
RC_BSE_DATA = createWorkbook("BSE_RC_DATA")

# DATA FIELDS ####

# Read description of data fields

## Wide table format
FIELDS_RC_BSE_DATA_TABLE = data.table(read.xlsx("../inputs/FIELDS_RC_DATA.xlsx", sheet = "RC FORMAT FIELDS", sep.names = " "))[FIELD %in% names(RC_BSE), .(FIELD, DEFINITION, `CODE LIST NAME`, `CODE LIST URL`)]

FIELDS_RC_BSE_DATA_TABLE[!is.na(`CODE LIST NAME`), `CODE LIST` := paste0("<a href=\"", `CODE LIST URL`, "\">", `CODE LIST NAME`, "</a>")]

FIELDS_RC_BSE_DATA_TABLE = FIELDS_RC_BSE_DATA_TABLE[, -c("CODE LIST NAME", "CODE LIST URL")]

# Add to workbook
addWorksheet(RC_BSE_DATA, "field_description")
writeDataTable(RC_BSE_DATA, sheet = "field_description", x = FIELDS_RC_BSE_DATA_TABLE, rowNames = FALSE, tableStyle = "TableStyleLight11")
setColWidths(RC_BSE_DATA, sheet = "field_description", cols = 1:ncol(FIELDS_RC_BSE_DATA_TABLE), widths = "auto")

# # CODE LISTS ####
# 
# ## FLEETS ####
# addWorksheet(BSE_RC_DATA, "FLEETS")
# writeDataTable(BSE_RC_DATA, sheet = "FLEETS", x = CL_FLEETS, tableStyle = "TableStyleLight11")
# setColWidths(BSE_RC_DATA, sheet = "FLEETS", cols = 1:nrow(CL_FLEETS), widths = "auto")
# 
# ## IRREGULAR GRID ####
# addWorksheet(BSE_RC_DATA, "FISHING GROUNDS")
# writeDataTable(BSE_RC_DATA, sheet = "FISHING GROUNDS", x = CL_FISHING_GROUNDS,  tableStyle = "TableStyleLight11")
# setColWidths(BSE_RC_DATA, sheet = "FISHING GROUNDS", cols = 1:nrow(CL_FISHING_GROUNDS), widths = "auto")
# 
# ## GEARS ####
# addWorksheet(BSE_RC_DATA, "GEARS")
# writeDataTable(BSE_RC_DATA, sheet = "GEARS", x = CL_GEARS,  tableStyle = "TableStyleLight11")
# setColWidths(BSE_RC_DATA, sheet = "GEARS", cols = 1:nrow(CL_GEARS), widths = "auto")
# 
# ## SCHOOL TYPES ####
# addWorksheet(BSE_RC_DATA, "SCHOOL TYPES")
# writeDataTable(BSE_RC_DATA, "SCHOOL TYPES", CL_SCHOOL_TYPES, tableStyle = "TableStyleLight11")
# setColWidths(BSE_RC_DATA, sheet = "SCHOOL TYPES", cols = 1:nrow(CL_SCHOOL_TYPES), widths = "auto")
# 
# Save the workbook
saveWorkbook(RC_BSE_DATA, paste0("../outputs/data/", TITLE, "-DDD.xlsx"), overwrite = TRUE)

# Zip the files
#zip::zip(zipfile = paste0("../outputs/data/", TITLE, ".zip"), files = c(paste0("../outputs/data/", TITLE, ".csv"), paste0("../outputs/data/", TITLE, "-DDD.xlsx")), mode = "cherry-pick", recurse = FALSE)

zip::zip(zipfile = paste0("../outputs/data/", TITLE, ".zip"), files = c(paste0("../outputs/data/", TITLE, ".csv")), mode = "cherry-pick", recurse = FALSE)

# Zipped file size in KB
RC_BSE_DATA_ZIP_SIZE = round(file.size(paste0("../outputs/data/", TITLE, ".zip"))/1e3)
