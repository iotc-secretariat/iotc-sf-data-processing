print("Extract code lists...")

## Recommended Size Measurements
CL_SIZE_REC_TABLE = fread(input = "https://data.iotc.org/reference/latest/domain/biology/codelists/RECOMMENDED_MEASUREMENTS_1.0.0.csv")[SPECIES_CODE == CODE_SPECIES_SELECTED]

CL_SIZE_REC = CL_SIZE_REC_TABLE[, .(`Type of measurement code` = TYPE_OF_MEASUREMENT_CODE, `Measurement code` = MEASUREMENT_CODE, `Default measurement interval` = DEFAULT_MEASUREMENT_INTERVAL, `Maximum measurement interval` = MAX_MEASUREMENT_INTERVAL, `Minimum size` = MIN_MEASUREMENT, `Maximum size` = MAX_MEASUREMENT)]

# Add measurement unit
CL_SIZE_REC[, `Measurement unit` := "cm"]

setcolorder(CL_SIZE_REC, neworder = c(1, 2, 7, 3, 4, 5, 6))

CL_SIZE_REC = data.frame(as.data.table(t(CL_SIZE_REC), keep.rownames = TRUE))
names(CL_SIZE_REC) = c("", "")

# Code lists restricted to the standardised dataset
CL_SPECIES = query(DB_IOTC_MASTER(), query = paste0("SELECT CODE AS SPECIES_CODE, NAME_EN AS SPECIES FROM refs_biological.SPECIES WHERE CODE = \'", CODE_SPECIES_SELECTED, "\';"))

CL_FLEETS = query(DB_IOTC_MASTER(), query = "SELECT DISTINCT FLEET_CODE, NAME_EN, NAME_FR FROM refs_legacy.FLEETS;")

CL_FISHING_GROUNDS = query(DB_IOTC_MASTER(), query = "SELECT CODE AS FISHING_GROUND_CODE, LABEL_EN AS DESCRIPTION_EN, LABEL_FR AS DESCRIPTION_FR, AREA_TYPE_CODE FROM refs_gis.AREAS")

CL_GEARS = query(DB_IOTC_MASTER(), query = "SELECT DISTINCT CODE AS GEAR_CODE, NAME_EN, NAME_FR FROM refs_legacy.GEARS;")

CL_SCHOOL_TYPES = query(DB_IOTC_MASTER(), query = "SELECT DISTINCT CODE AS CATCH_SCHOOL_TYPE_CODE, NAME_EN, NAME_FR FROM refs_legacy.SCHOOL_TYPES;")

CL_RAISINGS = query(DB_IOTC_MASTER(), query = "SELECT DISTINCT CODE AS RAISING_CODE, NAME_EN, NAME_FR FROM refs_legacy.RAISINGS;")

CL_MEASUREMENTS = query(DB_IOTC_MASTER(), query = "SELECT DISTINCT CODE AS MEASURE_TYPE_CODE, NAME_EN, DESCRIPTION_EN, NAME_FR, DESCRIPTION_FR FROM refs_biological.MEASUREMENTS WHERE CODE IN ('FL', 'LJ');")

print("Code lists extracted!")