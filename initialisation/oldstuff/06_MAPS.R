## YFT STOCK ASSESSMENT AREAS ####
YFT_SA_AREAS = 
ggplot() + 
  geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
  geom_sf(data = YFT_SA_AREAS_SF, aes(fill = CODE)) + 
  geom_sf_text(data = YFT_SA_AREAS_CENTROIDS_SF, size = 4, aes(label = CODE)) +
  labs(x = "", y = "") + 
  scale_fill_simpsons() + 
  scale_x_continuous(limits = c(20, 145)) +
  scale_y_continuous(limits = c(-60, 30)) +
  theme_bw() + 
  theme(legend.position = "none", legend.title = element_blank()) +
  theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))

save_plot("../outputs/maps/YFT_SA_AREAS.png", YFT_SA_AREAS, 8, 4.5)

# Standard areas
GRID_AREAS_01x01 = 
  ggplot() + 
  geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
  geom_sf(data = IOTC_1x1_GRID_SF) + 
  labs(x = "", y = "") + 
  scale_x_continuous(limits = c(20, 145)) +
  scale_y_continuous(limits = c(-60, 30)) +
  theme_bw() + 
  theme(legend.position = "none", legend.title = element_blank()) +
  theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))

save_plot("../outputs/maps/GRID_AREAS_01x01.png", GRID_AREAS_01x01, 8, 4.5)

GRID_AREAS_05x05 = 
  ggplot() + 
  geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
  geom_sf(data = IOTC_5x5_GRID_SF) + 
  labs(x = "", y = "") + 
  scale_x_continuous(limits = c(20, 145)) +
  scale_y_continuous(limits = c(-60, 30)) +
  theme_bw() + 
  theme(legend.position = "none", legend.title = element_blank()) +
  theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))

save_plot("../outputs/maps/GRID_AREAS_05x05.png", GRID_AREAS_05x05, 8, 4.5)

# Non standard areas

for (i in 1:nrow(LIST_NON_STANDARD_AREAS)){
  
  area      = LIST_NON_STANDARD_AREAS[i, FISHING_GROUND_CODE]
  n_samples = LIST_NON_STANDARD_AREAS[i, N_SAMPLES]
  area_sf   = SF_NON_STANDARD_AREAS_SF %>% filter(CODE == area)
  minlong   = st_bbox(area_sf)$xmin
  maxlong   = st_bbox(area_sf)$xmax
  minlat    = st_bbox(area_sf)$ymin
  maxlat    = st_bbox(area_sf)$ymax
  
  area_map = 
    ggplot() + 
    geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
    geom_sf(data = area_sf, fill = "#FCAE91", color = "black", linewidth = 0.5) + 
    geom_sf(data = IOTC_5x5_GRID_SF, fill = NA) + 
    labs(x = "", y = "", title = paste0(area, " | n = ", prettyNum(floor(n_samples), big.mark = ","))) + 
    scale_x_continuous(limits = c(minlong, maxlong)) +
    scale_y_continuous(limits = c(minlat, maxlat)) +
    theme_bw() + 
    theme(legend.position = "none", legend.title = element_blank()) +
    theme(panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))
  
  save_plot(paste0("../outputs/maps/AREA_", area, ".png"), area_map, 8, 4.5)
}
  
# Map showing the 5x5 grids to which size data reported with wrong 1x1 grid codes were allocated to

# TEMP_MAP_5x5_GRIDS_of_WRONG_1x1_GRIDS =
# ggplot() + 
#   geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
#   geom_sf(data = SF_1x1_GRIDS_NOT_IN_IO_SF, fill = "#FCAE91") + 
#   labs(x = "", y = "") + 
#   scale_x_continuous(limits = c(20, 145)) +
#   scale_y_continuous(limits = c(-60, 30)) +
#   theme_bw() + 
#   theme(legend.position = "none", legend.title = element_blank()) +
#   theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))
# 
# save_plot("../outputs/maps/MAP_5x5_GRIDS_of_WRONG_1x1_GRIDS.png", TEMP_MAP_5x5_GRIDS_of_WRONG_1x1_GRIDS, 8, 4.5)
