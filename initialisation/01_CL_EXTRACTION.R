l_info("Extract code lists...")

## Recommended Size Measurements
#CL_SIZE_REC_TABLE = fread(input = "https://data.iotc.org/reference/latest/domain/biology/codelists/RECOMMENDED_MEASUREMENTS_1.0.0.csv")[SPECIES_CODE == CODE_SPECIES_SELECTED]

CL_SIZE_REC_TABLE = query(C_REFERENCE_DATA, paste0("SELECT * FROM refs_biology.recommended_measurements WHERE species_code = \'", CODE_SPECIES_SELECTED, "\';"))  %>% {setnames(., new = toupper(names(.))); .}

CL_SIZE_REC = CL_SIZE_REC_TABLE[, .(`Type of measurement code` = TYPE_OF_MEASUREMENT_CODE, `Measurement code` = MEASUREMENT_CODE, `Default measurement interval` = DEFAULT_MEASUREMENT_INTERVAL, `Maximum measurement interval` = MAX_MEASUREMENT_INTERVAL, `Minimum size` = MIN_MEASUREMENT, `Maximum size` = MAX_MEASUREMENT)]

# Add measurement unit
CL_SIZE_REC[, `Measurement unit` := "cm"]

setcolorder(CL_SIZE_REC, neworder = c(1, 2, 7, 3, 4, 5, 6))

CL_SIZE_REC = data.frame(as.data.table(t(CL_SIZE_REC), keep.rownames = TRUE))
names(CL_SIZE_REC) = c("", "")

# Full code lists
CL_SPECIES = query(C_REFERENCE_DATA, query = paste0("SELECT code AS species_code, name_en AS species, name_scientific AS species_scientific FROM refs_biology.species WHERE CODE = \'", CODE_SPECIES_SELECTED, "\';")) %>% {setnames(., new = toupper(names(.))); .}

CL_FLEETS = query(C_REFERENCE_DATA, query = "SELECT DISTINCT fleet_code, name_en, name_fr FROM refs_legacy.fleets;") %>% {setnames(., new = toupper(names(.))); .}

CL_FISHING_GROUNDS = query(C_REFERENCE_DATA, query = "SELECT code AS fishing_ground_code, label_en AS description_en, label_fr AS description_fr, area_type_code FROM refs_gis.areas") %>% {setnames(., new = toupper(names(.))); .}

CL_GEARS = query(C_REFERENCE_DATA, query = "SELECT DISTINCT code AS gear_code, NAME_EN, NAME_FR FROM refs_legacy.GEARS;") %>% {setnames(., new = toupper(names(.))); .}

CL_SCHOOL_TYPES = query(C_REFERENCE_DATA, query = "SELECT DISTINCT code AS catch_school_type_code, name_en, name_fr FROM refs_legacy.SCHOOL_TYPES;") %>% {setnames(., new = toupper(names(.))); .}

CL_RAISINGS = query(C_REFERENCE_DATA, query = "SELECT DISTINCT code AS raising_code, name_en, name_fr FROM refs_legacy.raisings;") %>% {setnames(., new = toupper(names(.))); .}

CL_MEASUREMENTS = query(C_REFERENCE_DATA, query = "SELECT DISTINCT code AS measure_type_code, name_en, description_en, name_fr, description_fr FROM refs_biology.measurements WHERE CODE IN ('FL', 'LJ');") %>% {setnames(., new = toupper(names(.))); .}

l_info("Code lists extracted!")