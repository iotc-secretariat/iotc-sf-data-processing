SF_Rec_Params = fread(input = "https://data.iotc.org/reference/latest/domain/biology/codelists/RECOMMENDED_MEASUREMENTS_1.0.0.csv")[SPECIES_CODE == "ALB"]

SF_ll_Params = DEFAULT_IOTC_LL_EQUATIONS[SPECIES == "ALB"]
SF_lw_Params = DEFAULT_IOTC_LW_EQUATIONS[SPECIES == "ALB"]

# Temp trick to keep using table from brother F
LW_EQ = SF_lw_Params[, .(FISHERY_TYPE = GEAR_TYPE, A, B, M = C)]
