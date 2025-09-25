# In the size-frequency data, i.e., including gear codes like LLOB
#MAPPING_GEARS_FISHERY_GROUPS = unique(SF_raw()[, .(GEAR_CODE, GEAR, FISHERY_GROUP_CODE, FISHERY_GROUP)])
#write.csv(MAPPING_GEARS_FISHERY_GROUPS, "../inputs/MAPPING_GEARS_FISHERY_GROUPS.csv", row.names = FALSE)
MAPPING_GEARS_FISHERY_GROUPS = fread("../inputs/mappings/MAPPING_GEARS_FISHERY_GROUPS.csv")

# SF_RAW_ALL = SF_raw()
# MAPPING_GEARS_FISHERY_TYPES = unique(SF_RAW_ALL[, .(GEAR_CODE, FISHERY_TYPE_CODE, FISHERY_TYPE)])
# write.csv(MAPPING_GEARS_FISHERY_TYPES, "../inputs/MAPPING_GEARS_FISHERY_TYPES.csv", row.names = FALSE)
MAPPING_GEARS_FISHERY_TYPES = fread("../inputs/mappings/MAPPING_GEARS_FISHERY_TYPES.csv")

# Function to convert standard size dataset from legacy format to new format 
StandardSizeDataSetFormatConverter = function(StdSizeLegacyFormatDataSet){

  datafile = copy(StdSizeLegacyFormatDataSet)
# Change field names
setnames(datafile, 
         old = c("Fleet", "Year", "MonthStart", "MonthEnd", "Grid", "Gear", "Species", "SchoolType", "MeasureType", "FirstClassLow", "SizeInterval", "TnoFish", "TkgFish"), 
         new = c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SPECIES_CODE", "SCHOOL_TYPE_CODE", "MEASURE_TYPE_CODE", "MIN_MEASUREMENT", "DEFAULT_MEASUREMENT_INTERVAL", "FISH_NO", "FISH_WEIGHT_KG")
)

# Remove useless fields
  datafile = datafile[, -c("FISH_NO", "FISH_WEIGHT_KG")]

# Melt the data
  datafile_melted = melt.data.table(datafile, c("FLEET_CODE", "YEAR", "MONTH_START", "MONTH_END", "FISHING_GROUND_CODE", "GEAR_CODE", "SPECIES_CODE", "SCHOOL_TYPE_CODE", "MEASURE_TYPE_CODE", "MIN_MEASUREMENT", "DEFAULT_MEASUREMENT_INTERVAL"), variable.name = "SIZE_CLASS_RANK", value.name = "FISH_COUNT")[FISH_COUNT>0]

# Compute fork length classes
  datafile_melted[, SIZE_CLASS_RANK := as.integer(gsub("C", "", SIZE_CLASS_RANK))]
  datafile_melted[, CLASS_LOW :=  MIN_MEASUREMENT + (SIZE_CLASS_RANK - 1)*DEFAULT_MEASUREMENT_INTERVAL]
  datafile_melted[, CLASS_HIGH := MIN_MEASUREMENT + SIZE_CLASS_RANK*DEFAULT_MEASUREMENT_INTERVAL]

# Enrich with reference data
  StdSizeNewFormatDataSet = copy(datafile_melted)
  StdSizeNewFormatDataSet = merge(StdSizeNewFormatDataSet, MAPPING_GEARS_FISHERY_GROUPS, by = "GEAR_CODE", all.x = TRUE)
  StdSizeNewFormatDataSet = add_fishery_codes(StdSizeNewFormatDataSet)
  StdSizeNewFormatDataSet = add_species_metadata(StdSizeNewFormatDataSet)
  StdSizeNewFormatDataSet = merge(StdSizeNewFormatDataSet, MAPPING_GEARS_FISHERY_TYPES, by = "GEAR_CODE", all.x = TRUE)
  StdSizeNewFormatDataSet[, SPECIES_WP_CODE := "TROP"]
  StdSizeNewFormatDataSet[, RAISE_CODE := "UNCL"]
  StdSizeNewFormatDataSet[, SEX_CODE   := "UNCL"]
  StdSizeNewFormatDataSet[, MEASURE_UNIT_CODE := "CM"]
  
  #setcolorder(StdSizeNewFormatDataSet, neworder = c("YEAR", "MONTH_START", "MONTH_END", "FLEET_CODE", "GEAR_CODE", "FISHERY_GROUP_CODE", "FISHERY_TYPE_CODE", "SCHOOL_TYPE_CODE", "FISHING_GROUND_CODE", "SPECIES_CODE", "SPECIES_WP_CODE", "SPECIES_GROUP_CODE", "SPECIES_CATEGORY_CODE", "IS_IOTC_SPECIES", "IS_SPECIES_AGGREGATE", "IS_SSI", "MEASURE_TYPE_CODE", "MEASURE_UNIT_CODE", "SEX_CODE", "CLASS_LOW", "CLASS_HIGH", "FISH_COUNT", "RAISE_CODE"))
  
  StdSizeNewFormatDataSet_ordered = StdSizeNewFormatDataSet[, .(YEAR, MONTH_START, MONTH_END, FLEET_CODE, GEAR_CODE, FISHERY_GROUP_CODE, FISHERY_TYPE_CODE, SCHOOL_TYPE_CODE, FISHERY_CODE, FISHING_GROUND_CODE, SPECIES_CODE, SPECIES_WP_CODE, SPECIES_GROUP_CODE, SPECIES_CATEGORY_CODE, IS_IOTC_SPECIES, IS_SPECIES_AGGREGATE, IS_SSI, MEASURE_TYPE_CODE, MEASURE_UNIT_CODE, SEX_CODE, CLASS_LOW, CLASS_HIGH, FISH_COUNT, RAISE_CODE)]
  
  return(StdSizeNewFormatDataSet_ordered) 
  
}
