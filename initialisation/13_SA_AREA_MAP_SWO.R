# IOTC Stock Assessment Area of Swordfish ####
# Previous assessment carried out in 2023 (WPB21)
IOTC_SWO_SA_AREAS = st_read("../inputs/shapes/SWO_SA_SPATIAL_layers.gpkg", layer = "iotc_swo_sa_areas_wpb21")

# Create the spatial object for the SA labels
IOTC_SWO_SA_AREAS_LABELS = st_point_on_surface(IOTC_SWO_SA_AREAS) %>% select(code, label_en, name_en, geom) %>% mutate(code = str_to_sentence(gsub("SA_SWO_", "", code)))

# Swordfish SA Area Map ####

IOTC_SWO_STOCK_ASSESSMENT_AREA_MAP = 
  ggplot() + 
  theme_bw() + 
  geom_sf(data = un_countries_lowres, color = "darkgrey") + 
  #geom_sf(data = IOTC_AREA, fill = NA, linewidth = .5) + 
  geom_sf(data = IOTC_SWO_SA_AREAS, aes(fill = code), color = "black") + 
  geom_sf_text(data = IOTC_SWO_SA_AREAS_LABELS, aes(label = code), size = 4) +
  ggsci::scale_fill_simpsons() +  
  scale_x_continuous(limits = c(20, 145)) +
  scale_y_continuous(limits = c(-60, 30)) +
  labs(x = "", y = "") +
  theme(legend.position = "none", legend.title = element_blank()) +
  theme(panel.grid.major = element_line(color = gray(0.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))

ggsave("../outputs/maps/IOTC_SWO_STOCK_ASSESSMENT_AREA_MAP.png", IOTC_SWO_STOCK_ASSESSMENT_AREA_MAP, width = 8, height = 5)

# Swordfish SA Area Map | Northwest ####

  j = 1

for (i in IOTC_SWO_SA_AREAS$code){

SWO_SA_REGION_MAP = 
  ggplot() + 
  theme_bw() + 
  geom_sf(data = IOTC_SWO_SA_AREAS %>% filter(code == i), aes(fill = code), color = "black") + 
  geom_sf(data = CWP %>% filter(CWP_CODE %in% intersection_sa_swo_grid55[code1 == i, code2]), fill = NA) + 
  geom_sf(data = un_countries_lowres, color = "darkgrey") + 
  scale_fill_manual(values = pal_simpsons()(7)[j]) +  
  scale_x_continuous(limits = c(20, 145)) +
  scale_y_continuous(limits = c(-60, 30)) +
  labs(x = "", y = "") +
  theme(legend.position = "none", legend.title = element_blank()) +
  theme(panel.grid.major = element_line(color = gray(0.5), linetype = "dashed", linewidth = 0.3), panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))

  j = j + 1
ggsave(paste0("../outputs/maps/IOTC_SWO_STOCK_ASSESSMENT_AREA_MAP_", i, ".png"), SWO_SA_REGION_MAP, width = 8, height = 5)

}
