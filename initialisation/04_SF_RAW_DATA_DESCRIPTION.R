l_info("Describing the processing steps...", "SF")

## Size Measures ####

# Official morphometric relationships
lengthLengthEquations = DEFAULT_IOTC_LL_EQUATIONS[SPECIES == CODE_SPECIES_SELECTED]
lengthWeightEquations = DEFAULT_IOTC_LW_EQUATIONS[SPECIES == CODE_SPECIES_SELECTED]
weightWeightEquations = data.table(SPECIES = c("ALB", "BET", "YFT"), FROM = c("GGT", "GGT", "GGT"), TO = c("RND", "RND", "RND"), A = 1.13, B = 0, EQ_ID = "EQ_PROP", NOTES = NA )[SPECIES == CODE_SPECIES_SELECTED]

### Records with size bin too large ####
SF_NonStandardBin = SF_RAW_DATA_SPECIES[(CLASS_HIGH  - CLASS_LOW) > CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL]

### Missing length-length conversion equations ####
alternativeLengthMeasurementCodes = 
  data.table(MEASUREMENT_CODE = c("CF", "CKL", "CKUT", "EFL", "EFUT", "FL", "FLB", "FLC", "FLCT", "FLUT", "LDF", "LDFT", "MLD", "PAL", "PALT", "PCL", "PCLT", "TL"), 
           GENERAL_CODE = c("CF", "CKL", "CKL", "EFL", "EFL", "FL", "FL", "FL", "FL", "FL", "LDF", "LDF", "MLD", "PAL", "PAL", "PCL", "PCL", "TL")
           )

indic = alternativeLengthMeasurementCodes$MEASUREMENT_CODE %in% SF_RAW_DATA_SPECIES$MEASURE_TYPE_CODE

lengthCodesDataset = unique(alternativeLengthMeasurementCodes[indic, MEASUREMENT_CODE])
simplifiedLengthCodesDataset = unique(alternativeLengthMeasurementCodes[indic, GENERAL_CODE])

lengthConversionToForkLengthAvailable = simplifiedLengthCodesDataset[simplifiedLengthCodesDataset %in% lengthLengthEquations$FROM]

lengthConversionToForkLengthMissing = simplifiedLengthCodesDataset[simplifiedLengthCodesDataset != "FL" & !simplifiedLengthCodesDataset %in% lengthLengthEquations$FROM]

SF_MissingForkLengthConversion = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE %in% lengthConversionToForkLengthMissing]

### Missing length-weight conversion equations ####

weightCodesDataset = sort(unique(SF_RAW_DATA_SPECIES[!MEASURE_TYPE_CODE %in% lengthCodesDataset, MEASURE_TYPE_CODE]))

weightConversionToRoundWeightAvailable = weightCodesDataset[weightCodesDataset %in% weightWeightEquations$FROM]

weightConversionToRoundWeightMissing = weightCodesDataset[weightCodesDataset != "RND" & !weightCodesDataset %in% weightWeightEquations$FROM]

SF_MissingRoundWeightConversion = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE %in% weightConversionToRoundWeightMissing]

### Fish too large (after conversion to fork length) ####

SF_FishLargerThanMaximum = FL_STD_DATA_SPECIES[(CLASS_LOW + CLASS_HIGH)/2 > CL_SIZE_REC_TABLE$MAX_MEASUREMENT]

### Fish samples reallocated to lower size class ####

SF_FishSmallerThanMinimum = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE %in% c("FL", "FLB", "FLC", "FLCT", "FLUT") & (CLASS_LOW + CLASS_HIGH)/2 < CL_SIZE_REC_TABLE$MIN_MEASUREMENT]

## Spatial Dimension ####

### Missing spatial information ####

SF_NoSpatialInformation = SF_RAW_DATA_SPECIES[is.na(FISHING_GROUND_CODE)]

### Fish samples in grids outside the Indian Ocean ####

# Merge with regular grids 1x1 and 5x5 to identify data not consistent with expected reporting

REG_GRIDS_NOT_IN_IO = unique(merge(SF_RAW_DATA_SPECIES[substring(FISHING_GROUND_CODE, 1, 1) %in% c("5", "6")], IO_SF_GRID_LIST, by.x = "FISHING_GROUND_CODE", by.y = "CODE", all.x = TRUE)[is.na(NAME_EN), .(FISHING_GROUND_CODE)])[order(FISHING_GROUND_CODE)]

SF_OutsideIndianOcean = SF_RAW_DATA_SPECIES[FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

## Technical Dimension ####

### Missing gear information ####

SF_NoGearInformation = SF_RAW_DATA_SPECIES[is.na(GEAR_CODE)]

### Temporal Dimension ###

# Larger than a quarter
SF_TemporalStrataTooLarge = SF_RAW_DATA_SPECIES[MONTH_END - MONTH_START > 3] 

l_info("Processing intermediate files produced!", "SF")
