rm(list = ls()) # clear environment

cts <- read.delim('~/RNAseq/3_counts/rnaseq_counts.Rmatrix.txt',sep='\t',row.names='Geneid')

coldata <- read.delim('annotation',sep='\t',row.names=1)

library("DESeq2")

dds <- DESeqDataSetFromMatrix(countData = cts,colData = coldata,design = ~ Condition1 + Condition2 + ...)

dds # provides summary of data set

keep <- rowSums(counts(dds)) >= 10 # pre-filter the data set to remove rows with less than 10 reads

dds <- dds[keep,] # remove the filtered rows from the data set

dds$condition <- factor(dds$condition, levels = c("Control","Treated"))

dds <- DESeq(dds) # PERFORM THE DIFFERENTIAL EXPRESSION ANALYSIS

res <- results(dds) # write the results to a table

res # view a summary of the results

resultsNames(dds) # view a list of your coefficients

resLFC <- lfcShrink(dds, coef="Coefficient_You_Want_To_Shrink", type="apeglm") # shrink desired coefficient

resOrdered <- res[order(res$pvalue),] # order the list by p-value

res05 <- results(dds, alpha=0.05)

summary(res05) # view a summary of genes with changes with a p-value < 0.05

resSig <- subset(resOrdered, pvalue < 0.05)

write.csv(as.data.frame(resOrdered(or resSig)), file="file_name.csv")

library(EnhancedVolcano)

pdf("graph_name.pdf")

EnhancedVolcano(resLFC, lab = rownames(resLFC), x = 'log2FoldChange', y = 'pvalue', title = 'Title')

dev.off()

library(enrichR)

websiteLive <- getOption("enrichR.live")

if (websiteLive) {
  listEnrichrSites()
  setEnrichrSite("Enrichr") # Human genes   
}

if (websiteLive) dbs <- listEnrichrDbs()

if (websiteLive) head(dbs)

dbs <- c("GO_Biological_Process_2023", "GO_Cellular_Component_2023", "GO_Molecular_Function_2023", "Reactome_2022", "WikiPathway_2021_Human")

dat = readLines("list_of_gene_names.csv")

if (websiteLive) {enriched <- enrichr(dat, dbs)}

Query <- if (websiteLive) enriched[["GO_Biological_Process_2023"]]

write.csv(as.data.frame(Query), file="GO_BP_2023.csv")

pdf("GO_BP_2023.pdf")

if (websiteLive) {plotEnrich(enriched[[1]], showTerms = 20, numChar = 40, y = "Count", orderBy = "P.value")}

dev.off()

# repeat for each library