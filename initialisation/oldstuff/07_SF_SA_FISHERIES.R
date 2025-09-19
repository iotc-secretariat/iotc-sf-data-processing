print("Describing the size composition of the catch for the assessment fisheries")


# Add SA fisheries to each of the SF datasets
FL_REG = merge(YFT_FL_STD_WPTT26_REGULAR_TO_CWP55_GRIDS, SA_FISHERY_MAPPING, by = c("FLEET_CODE", "GEAR_CODE", "SCHOOL_TYPE_CODE"), all.x = TRUE)

# Focus on baitboats


YFT_FL_STD_WPTT26_REGULAR_TO_CWP55_GRIDS

YFT_FL_STD_WPTT26_IRREGULAR_TO_CWP55_GRIDS