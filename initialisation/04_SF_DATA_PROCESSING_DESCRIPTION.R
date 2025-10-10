l_info("Describing the processing steps...", "SF")

# Processing Steps ####

# Official morphometric relationships
lengthLengthEquations = DEFAULT_IOTC_LL_EQUATIONS[SPECIES == CODE_SPECIES_SELECTED]
lengthWeightEquations = DEFAULT_IOTC_LW_EQUATIONS[SPECIES == CODE_SPECIES_SELECTED]
weightWeightEquations = data.table(SPECIES = c("ALB", "BET", "YFT"), FROM = c("GGT", "GGT", "GGT"), TO = c("RND", "RND", "RND"), A = 1.13, B = 0, EQ_ID = "EQ_PROP", NOTES = NA )[SPECIES == CODE_SPECIES_SELECTED]

## Fish samples removed ####

### 1- Records with too large bin size ####
SF_NonStandardBin = SF_RAW_DATA_SPECIES[(CLASS_HIGH  - CLASS_LOW) > CL_SIZE_REC_TABLE$MAX_MEASUREMENT_INTERVAL]

### 2- Missing length-length conversion equations ####
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

### 3- Missing length-weight conversion equations ####

weightCodesDataset = sort(unique(SF_RAW_DATA_SPECIES[!MEASURE_TYPE_CODE %in% lengthCodesDataset, MEASURE_TYPE_CODE]))

weightConversionToRoundWeightAvailable = weightCodesDataset[weightCodesDataset %in% weightWeightEquations$FROM]

weightConversionToRoundWeightMissing = weightCodesDataset[weightCodesDataset != "RND" & !weightCodesDataset %in% weightWeightEquations$FROM]

SF_MissingRoundWeightConversion = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE %in% weightConversionToRoundWeightMissing]

### 4- Fish too large (after conversion to fork length)

SF_FishLargerThanMaximum = FL_STD_DATA_SPECIES[(CLASS_LOW + CLASS_HIGH)/2 > CL_SIZE_REC_TABLE$MAX_MEASUREMENT]

### 5- Fish samples reported for grids outside the Indian Ocean ####

SF_OutsideIndianOcean = SF_RAW_DATA_SPECIES[FISHING_GROUND_CODE %in% REG_GRIDS_NOT_IN_IO$FISHING_GROUND_CODE]

## 6- Fish samples reallocated to lower size class ####

SF_FishSmallerThanMinimum = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE %in% c("FL", "FLB", "FLC", "FLCT", "FLUT") & (CLASS_LOW + CLASS_HIGH)/2 < CL_SIZE_REC_TABLE$MIN_MEASUREMENT]

l_info("Processing intermediate files produced!", "SF")
