# Size-frequency  distributions in non standard areas

  for (i in 1:nrow(LIST_NON_STANDARD_AREAS_FILTERED)){
  
    area      = LIST_NON_STANDARD_AREAS_FILTERED[i, FISHING_GROUND_CODE]
    sfdata    = FL_YFT_IRREGULAR_GRIDS[FISHING_GROUND_CODE == area]
    sfdata[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]
    sfdata_gear = sfdata[, .(N = sum(FISH_COUNT)), keyby = .(FISHING_GROUND_CODE, GEAR_CODE, CLASS_MID)]
    sfdata_gear[, N_GEAR := sum(N), by = .(FISHING_GROUND_CODE, GEAR_CODE)]
    sfdata_gear[, N_REL := N/N_GEAR*100]
    sfdata_gear[, AREA_GEAR_CODE_N := paste0(FISHING_GROUND_CODE, " | ", GEAR_CODE, " | n = ", prettyNum(floor(N_GEAR), big.mark = ","))]
    
    sfdist = 
      ggplot(sfdata_gear, aes(x = CLASS_MID, y = N_REL)) + 
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
    facet_wrap(~AREA_GEAR_CODE_N)
  
  save_plot(paste0("../outputs/sfdist/SF_RELATIVE_AREA_", area, ".png"), sfdist, 8, 4.5)
  
  }

  # Non standard areas combined with size distributions
  
  for (i in 1:nrow(LIST_NON_STANDARD_AREAS_FILTERED)){
    
    area      = LIST_NON_STANDARD_AREAS_FILTERED[i, FISHING_GROUND_CODE]
    n_samples = LIST_NON_STANDARD_AREAS_FILTERED[i, N_SAMPLES]
    area_sf   = SF_NON_STANDARD_AREAS_SF %>% filter(CODE == area)
    minlong   = st_bbox(area_sf)$xmin
    maxlong   = st_bbox(area_sf)$xmax
    minlat    = st_bbox(area_sf)$ymin
    maxlat    = st_bbox(area_sf)$ymax
    
    sfdata    = FL_YFT_IRREGULAR_GRIDS[FISHING_GROUND_CODE == area]
    sfdata[, CLASS_MID := (CLASS_LOW + CLASS_HIGH)/2]
    sfdata_gear = sfdata[, .(N = sum(FISH_COUNT)), keyby = .(FISHING_GROUND_CODE, GEAR_CODE, CLASS_MID)]
    sfdata_gear[, N_GEAR := sum(N), by = .(FISHING_GROUND_CODE, GEAR_CODE)]
    sfdata_gear[, N_REL := N/N_GEAR*100]
    sfdata_gear[, GEAR_CODE_N := paste0(GEAR_CODE, " | n = ", prettyNum(floor(N_GEAR), big.mark = ","))]
    
    area_map = 
      ggplot() + 
      geom_sf(data = COUNTRY_AREAS_SF, fill = "lightgrey", color = "lightgrey") + 
      geom_sf(data = area_sf, fill = "#FCAE91", color = "black", linewidth = 0.5) + 
      geom_sf(data = IOTC_5x5_GRID_SF, fill = NA) + 
      labs(x = "", y = "", title = paste0(area)) + 
      scale_x_continuous(limits = c(minlong, maxlong)) +
      scale_y_continuous(limits = c(minlat, maxlat)) +
      theme_bw() + 
      theme(legend.position = "none", legend.title = element_blank()) +
      theme(panel.border = element_rect(fill = NA, colour = "black", linewidth = 1.2))
    
    sfdist = 
      ggplot(sfdata_gear, aes(x = CLASS_MID, y = N_REL)) + 
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
      facet_wrap(~GEAR_CODE_N)
    
    toto = ggarrange(area_map, sfdist, ncol = 2)
    
    save_plot(paste0("../outputs/combined/SF_RELATIVE_AREA_", area, ".png"), toto, 8, 4.5)
  }
  