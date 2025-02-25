rm(list = ls())
path = "~/Deconvolution/"
setwd(path)
bulk_DEGs <- read.csv("DEGs.csv")
bulk_DEGs <-bulk_DEGs[!is.na(bulk_DEGs),]
bulk_DEGs <- bulk_DEGs[bulk_DEGs$padj<0.1,]
bulk_DEGs <- bulk_DEGs[order(-bulk_DEGs$log2FoldChange),]
bulk_DEGs_sup <- bulk_DEGs[bulk_DEGs$log2FoldChange>0,]
bulk_DEGs_deep <- bulk_DEGs[bulk_DEGs$log2FoldChange<0,]
bulk_DEGs_sup <- bulk_DEGs_sup$X
bulk_DEGs_deep <- bulk_DEGs_deep$X
path = "~/Deconvolution/AllenBrainMap_MouseCortexAndHippo_SMART-seq/"
setwd(path)
metadata <- read.csv("metadata.csv")
library(data.table)
counts <- fread("matrix.csv", data.table=FALSE)
rownames(counts) <- counts$sample_name
counts <- counts[,-!names(counts) %in% c("sample_name")]
counts <- as.matrix(counts)
transposed_counts <- t(counts)
rm(counts)
gc()
library(Seurat)
sc_data <- CreateSeuratObject(counts=transposed_counts,meta.data = metadata, min.cells = 0, min.features = 0, project = "AllenBrainMap_MouseCortexHippo_SMART-seq-2019_with_10x_SMART-seq-2020-taxonomy")
rm(transposed_counts,metadata)
gc()
str(sc_data@meta.data)
table(sc_data$region_label)
