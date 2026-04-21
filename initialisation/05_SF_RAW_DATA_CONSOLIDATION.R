l_info("Consolidating the data", "SF")

# Initiate the dataset
SF_DATA_SPECIES = copy(SF_RAW_DATA_SPECIES)

# Filtering ####

# Data without spatial information ####
SF_DATA_SPECIES = SF_DATA_SPECIES[!is.na(FISHING_GROUND_CODE)]

## Data reported outside the Indian Ocean ####
SF_DATA_SPECIES = SF_DATA_SPECIES[!FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

## Data with temporal resolution larger than 3 months ####
SF_DATA_SPECIES = SF_DATA_SPECIES[MONTH_END - MONTH_START <= 3] 

# Data without gear information ####
SF_DATA_SPECIES = SF_DATA_SPECIES[!is.na(GEAR_CODE)]

l_info("Data consolidated!", "SF")