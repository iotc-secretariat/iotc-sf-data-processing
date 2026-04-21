# Install/load libraries required for analysis
pacman::p_load(
  "tidyverse",
  "openxlsx",
  "ggsci", 
  "ggpubr", 
  "lubridate", 
  "rmarkdown",
  "knitr",
  "bookdown",
  "officer",
  "lubridate",
  "DT", 
  "flextable", 
  "ows4R", 
  "fdisf",       #pak::pak("https://github.com/fdiwg/fdisf")
  "fdisfdata",    #pak::pak("https://github.com/fdiwg/fdisfdata")
  "fdi4R", 
  "sf"
  )

# Set ggplot chart theme
theme_set(theme_bw())



# Convert fdi4R::intersections to DT
intersections = as.data.table(intersections)
