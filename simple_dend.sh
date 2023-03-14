#!/usr/bin/env Rscript

args=commandArgs(trailingOnly=TRUE)
selected.plasmid <- as.character(args)[1]

load(paste0("./", selected.plasmid,"/data/Step5.Rdata"))

library(circlize)
library(dendextend)

mx.lociq.mlst <- as.data.frame.matrix(table(cumulative.loci$plasmid, cumulative.loci$locus_and_variant))
mx.lociq.mlst <- mx.lociq.mlst[-1,-1]
dend.lociq <- as.dendrogram(hclust(dist(mx.lociq.mlst, method = "binary"))) %>% set("labels_cex", c(0.2, 0.2))
svg(filename="plasmidDendro.svg", width = 7, height = 7)
circlize_dendrogram(dend.lociq)
dev.off()
