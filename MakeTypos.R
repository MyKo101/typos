
#Load utils
source("R/utils.R")
cat("\nutils functions loaded")

#Create the exported typos
.clear_exported()
cat("\nExported function file cleared")

cat("\nLoading in the current list of typos")
#Add in the current list of typos
.typo_doc(nameS,names)
.typo_doc(`nameS<-`,`names<-`,back.tick=T)
.typo_doc(typoef,typeof)
.typo_doc(geom_warp,geom_wrap,ggplot2)
.typo_doc(fitler,filter,dplyr)
.typo_doc(transmutate,mutate,dplyr)
.typo_doc(lenght,length)

