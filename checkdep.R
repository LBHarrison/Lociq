#!/usr/bin/env Rscript
checklist <- c("remotes", "pacman", "optparse", "plyr", "tidyr", "dplyr", "Hmisc", "DECIPHER", "corrplot")

if(nchar(paste(checklist[which(checklist %in% rownames(installed.packages()) == TRUE, arr.ind = TRUE)], collapse = ", ")) <= 1){
checktest <- 0
result1 <- paste0("No packages were installed, please install packages individually and observe any error messages / missing dependencies")
} else {
result1 <- paste("The following packages are available for use: ", paste(checklist[which(checklist %in% rownames(installed.packages()) == TRUE, arr.ind = TRUE)], collapse = ", "))
checktest <- 1
}

if(checktest <- 0){
checktest <- 0 
result2 <- ""
} else {
if(nchar(paste(checklist[which(checklist %in% rownames(installed.packages()) != TRUE, arr.ind = TRUE)], collapse = ", ")) <= 1){
result2 <- paste0("All R packages in the install queue are available for use")
} else {
result2 <- paste0("The following packages are not currently available and may require manual installation: ", paste(checklist[which(checklist %in% rownames(installed.packages()) != TRUE, arr.ind = TRUE)], collapse = ", "))
}
}

cat("","","",result1,"",result2,"","",sep="\n")
