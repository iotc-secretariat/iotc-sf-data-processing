

# Iranian case study
FL_IRN_PS = YFT_FL_STD_WPTT26_REGULAR_TO_CWP55_GRIDS[FLEET_CODE == "IRN" & GEAR_CODE == "PS", .(N = sum(FISH_COUNT)), keyby = .(YEAR, GEAR_CODE, SCHOOL_TYPE_CODE, CLASS_LOW, CLASS_HIGH)]

FL_IRN_PS[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

ggplot(FL_IRN_PS, aes(x = CLASS_MID, y = N)) + 
  geom_line(linewidth = 1) + 
  xlab("Fork length (cm)") + ylab("% of samples") +
  theme(axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 10), 
        axis.title.y = element_text(size=10), 
        strip.text.x = element_text(size = 10), 
        plot.margin = margin(.2, .3, .1, 0, "cm"), 
        legend.position = "none",
        legend.title = element_blank()) +
  coord_cartesian(xlim = c(50, 200)) + 
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(~YEAR, scales = "free_y")

# TWN gillnet fisheries
FL_TWN_GILL = FL_STD_DATA_SPECIES[FLEET_CODE %in% c("TWN") & GEAR_CODE %in% c("GILL"), .(N = sum(FISH_COUNT)), keyby = .(YEAR, CLASS_LOW, CLASS_HIGH)]

FL_TWN_GILL[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

ggplot(FL_TWN_GILL, aes(x = CLASS_MID, y = N)) + 
  geom_line(linewidth = 1) + 
  xlab("Fork length (cm)") + ylab("% of samples") +
  theme(axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 10), 
        axis.title.y = element_text(size=10), 
        strip.text.x = element_text(size = 10), 
        plot.margin = margin(.2, .3, .1, 0, "cm"), 
        legend.position = "none",
        legend.title = element_blank()) +
  coord_cartesian(xlim = c(50, 200)) + 
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(~YEAR, scales = "free_y")

# EUREU and HAND fisheries
FL_REU_HAND = FL_STD_DATA_SPECIES[FLEET_CODE %in% c("EUREU") & GEAR_CODE %in% c("HAND"), .(N = sum(FISH_COUNT)), keyby = .(YEAR, CLASS_LOW, CLASS_HIGH)]

FL_REU_HAND[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

ggplot(FL_REU_HAND, aes(x = CLASS_MID, y = N)) + 
  geom_line(linewidth = 1) + 
  xlab("Fork length (cm)") + ylab("% of samples") +
  theme(axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 10), 
        axis.title.y = element_text(size=10), 
        strip.text.x = element_text(size = 10), 
        plot.margin = margin(.2, .3, .1, 0, "cm"), 
        legend.position = "none",
        legend.title = element_blank()) +
  coord_cartesian(xlim = c(50, 200)) + 
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(~YEAR, scales = "free_y")

# Seychelles fresh longliners

FL_YFT_SYC_FLL = FL_YFT_GRIDS_TO_CWP55[FLEET_CODE == "SYC" & GEAR_CODE == "ELL", .(N = sum(FISH_COUNT)), keyby = .(YEAR, CLASS_LOW, CLASS_HIGH)]

FL_YFT_SYC_FLL[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]

ggplot(FL_YFT_SYC_FLL, aes(x = CLASS_MID, y = N)) + 
  geom_line(linewidth = 1) + 
  xlab("Fork length (cm)") + ylab("Samples") +
  theme(axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 10), 
        axis.title.y = element_text(size=10), 
        strip.text.x = element_text(size = 10), 
        plot.margin = margin(.2, .3, .1, 0, "cm"), 
        legend.position = "none",
        legend.title = element_blank()) +
  #coord_cartesian(xlim = c(50, 200)) + 
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(~YEAR, scales = "free_y")
