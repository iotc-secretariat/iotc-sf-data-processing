# Libraries
library(knitr)
library(officer)
library(officedown)
library(rmarkdown)
library(flextable) # datasets airquality and mtcars
library(dplyr)     # For %>% 
library(this.path)

# Set the Working Directory
setwd(here())
# Generic report
render("IOTC_REPORT.Rmd", output_file = "EXAMPLE_IOTC_REPORT_OUTPUT.docx")

