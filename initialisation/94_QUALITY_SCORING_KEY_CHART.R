
# Read QUALITY SCORE KEY
QUALITY_SCORE_KEY = data.table(read.xlsx("../inputs/QUALITY_SCORING_KEY.xlsx", sep.names = " "))[Dataset == "Size frequencies"]

QUALITY_SCORE_KEY_FT = 
  QUALITY_SCORE_KEY %>%
  flextable() %>% 
  flextable::font(part = "all", fontname = "calibri") %>% 
  flextable::fontsize(part = "all", size = 10) %>% 
  border_inner() %>% 
  border_outer(border = fp_border(width = 2)) %>% 
  flextable::align(i = c(3, 4), j = 3:4, align = "center", part = "body") %>%
  flextable::align(j = 1:4, part = "header", align = "center") %>%
  bg(i = c(1), j = 3:4, bg = colors_for_quality(0)$FILL) %>%
  bg(i = c(2), j = 3:4, bg = colors_for_quality(2)$FILL) %>%      
  bg(i = c(3), j = 3:4, bg = colors_for_quality(6)$FILL) %>%        #"#953735FF"
  bg(i = c(4), j = 3:4, bg = colors_for_quality(8)$FILL) %>%       
  color(i = 3:4, j = 3:4, color = "white", part = "body") %>%
  hline(i = 2:nrow(QUALITY_SCORE_KEY) - 1, border = fp_border(width = 1)) %>%
  vline(j = 1:(ncol(QUALITY_SCORE_KEY) - 1), border = fp_border(style = "solid")) %>%
  merge_h_range(i = 3:4, j1 = "By species", j2 = "By gear", part="body") %>%
  merge_v(j = "Dataset", part = "body") %>%
  autofit() %>%
  bg(part = "header", bg = "lightgrey", i = 1) %>%
  bg(part = "body", bg = "lightgrey", j = 1) %>%
  fix_border_issues(part = "all")

# Export as image
save_as_image(QUALITY_SCORE_KEY_FT, "../inputs/charts/QUALITY_SCORE_KEY_FT.png")
