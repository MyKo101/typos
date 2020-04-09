library(rlang)
library(devtools)
library(roxygen2)

.clear_exported()

source("R/utils.R")
source("R/typo-functions.R")

.typo_doc(nameS,names)
.typo_doc(`nameS<-`,`names<-`,back.tick=T)
.typo_doc(typoef,typeof)
.typo_doc(geom_warp,geom_wrap,ggplot2)
.typo_doc(fitler,filter,dplyr)

devtools::document()
knitr::knit("README.Rmd")

devtools::load_all()


help("Exported-typos")
