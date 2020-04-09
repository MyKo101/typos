library(rlang)
library(devtools)
library(roxygen2)

# Load the functions
source("R/utils.R")
source("R/typo-functions.R")

#Create the exported typos
.clear_exported()

.typo_doc(nameS,names)
.typo_doc(`nameS<-`,`names<-`,back.tick=T)
.typo_doc(typoef,typeof)
.typo_doc(geom_warp,geom_wrap,ggplot2)
.typo_doc(fitler,filter,dplyr)

#sort documentation
devtools::document()
knitr::knit("README.Rmd",
            out="README.md")
rmarkdown::render("README.Rmd",
                  output_format="html_document",
                  output_file="index.html")

