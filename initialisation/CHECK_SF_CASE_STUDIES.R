
# Sample of 405 measured in fork length
FL = SF_RAW_DATA_SPECIES[MEASURE_TYPE_CODE == "FL" & FLEET_CODE == "JPN" & GEAR_CODE == "LL" & YEAR == 1965 & FISHING_GROUND_CODE == "A220100"]

FL[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

summary(FL$CLASS_MID)

#FL = SF_RAW_DATA_SPECIES[, .(N = sum(FISH_COUNT)), keyby = .(YEAR, CLASS_LOW, CLASS_HIGH)]

FL = FL_STD_DATA_SPECIES[FLEET_CODE == "JPN" & GEAR_CODE == "LL" & YEAR == 1965 & FISHING_GROUND_CODE == "A220100", .(N = sum(FISH_COUNT)), keyby = .(YEAR, CLASS_LOW, CLASS_HIGH)]

FL[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

summary(FL$CLASS_MID)

ggplot(FL, aes(x = CLASS_MID, y = N)) + 
  geom_line(linewidth = 1) + 
  xlab("Fork length (cm)") + ylab("Samples") +
  theme(axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 10), 
        axis.title.y = element_text(size=10), 
        strip.text.x = element_text(size = 10), 
        plot.margin = margin(.2, .3, .1, 0, "cm"), 
        legend.position = "none",
        legend.title = element_blank()) +
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(~YEAR, scales = "free_y")
