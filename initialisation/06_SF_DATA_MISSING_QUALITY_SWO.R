# Issues to address in the database

## Seychelles semi-industrial longline fishery targeting swordfish
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "SYC" & GEAR_CODE %in% c("ELL"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "SYC" & GEAR_CODE %in% c("ELL"), REPORTING_QUALITY := "6"]

FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & FLEET_CODE == "SYC" & GEAR_CODE %in% c("ELL"), REPORTING_QUALITY := "6"]

## No gear code -- corresponds to EM for Spanish ELL -- remove the records
FL_STD_DATA_SPECIES_TABLE_NO_GEAR = FL_STD_DATA_SPECIES_TABLE[is.na(GEAR_CODE)]
FL_STD_DATA_SPECIES_NO_GEAR       = FL_STD_DATA_SPECIES[is.na(GEAR_CODE)]

FL_STD_DATA_SPECIES_TABLE = FL_STD_DATA_SPECIES_TABLE[!is.na(GEAR_CODE)]
FL_STD_DATA_SPECIES       = FL_STD_DATA_SPECIES[!is.na(GEAR_CODE)]

## Unclassified gears
FL_STD_DATA_SPECIES_TABLE_UNCL_GEAR = FL_STD_DATA_SPECIES_TABLE[GEAR_CODE == "UNCL"]
FL_STD_DATA_SPECIES_UNCL_GEAR       = FL_STD_DATA_SPECIES[GEAR_CODE == "UNCL"]

FL_STD_DATA_SPECIES_TABLE = FL_STD_DATA_SPECIES_TABLE[GEAR_CODE != "UNCL"]
FL_STD_DATA_SPECIES       = FL_STD_DATA_SPECIES[GEAR_CODE != "UNCL"]

## Aggregate gears
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & GEAR_CODE %in% c("HATR", "G/L"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & GEAR_CODE %in% c("HATR", "G/L"), REPORTING_QUALITY := "4"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & GEAR_CODE %in% c("HATR", "G/L"), REPORTING_QUALITY := "4"]

## NEIPS
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "NEIPS" & GEAR_CODE %in% c("PS"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "NEIPS" & GEAR_CODE %in% c("PS"), REPORTING_QUALITY := "0"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & FLEET_CODE == "NEIPS" & GEAR_CODE %in% c("PS"), REPORTING_QUALITY := "0"] 

## Deep-freezing longline fishery from South Africa
# 3 very small fish - not removed by the standardisation?
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "ZAF" & GEAR_CODE %in% c("LL"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "ZAF" & GEAR_CODE %in% c("LL"), REPORTING_QUALITY := "0"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & FLEET_CODE == "ZAF" & GEAR_CODE %in% c("LL"), REPORTING_QUALITY := "0"]

## Handline fishery from Tanzania
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "TZA" & GEAR_CODE %in% c("HAND"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "TZA" & GEAR_CODE %in% c("HAND"), REPORTING_QUALITY := "0"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & FLEET_CODE == "TZA" & GEAR_CODE %in% c("HAND"), REPORTING_QUALITY := "0"]

## Iranian Purse seiners
# School type is missing
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "IRN" & GEAR_CODE %in% c("PS"), .N, .(YEAR, FLEET_CODE, GEAR_CODE, FISHING_GROUND_CODE)]

FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY) & FLEET_CODE == "IRN" & GEAR_CODE %in% c("PS"), REPORTING_QUALITY := "4"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY) & FLEET_CODE == "IRN" & GEAR_CODE %in% c("PS"), REPORTING_QUALITY := "4"]

## Set all remaining records to good quality
## No apparent issue although difficult to assess when few records are available
FL_STD_DATA_SPECIES_TABLE[is.na(REPORTING_QUALITY), REPORTING_QUALITY := "0"]
FL_STD_DATA_SPECIES[is.na(REPORTING_QUALITY), REPORTING_QUALITY := "0"]


RAISE_CODE)][order(-FISH_COUNT)]
FLEET_CODE GEAR_CODE RAISE_CODE FISH_COUNT
<ord>     <ord>      <ord>      <num>
  1:        SYC       ELL         OS      12403
2:        LKA       G/L         OS       1016
3:        AUS       FLL         OS        989
4:        ZAF        LL         OS        709
5:        TZA       PSS         OS        566
6:        MOZ      HAND         OS        359
7:        MOZ       ELL         OS        242
8:        MDG      GILL         OS         84
9:        LKA      LLCO         OS         65
10:        MOZ       FLL         OS         57
11:        LKA      TROL         OS         44
12:        LKA      UNCL         OS         33
13:        COM      LLCO         OS          7
14:        LKA      HATR         OS          6
15:        MDG      LLCO         OS          5
16:      EUREU      HAND         OS          2
17:        TZA       FLL         OS          2