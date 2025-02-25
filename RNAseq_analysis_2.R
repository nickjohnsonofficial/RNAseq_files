rm(list = ls())
var<- readline(prompt = "How many conditions do you have?");
var <- as.integer(var);
Design <- c("~")
for (I in c(1:var)) {
  J <- I*2
  K <- I*2+1
  L <- readline(prompt = "Name this Condition:")
  Design[J] <- L
  Design[K] <- "+"
}
Design <- head( Design, -1)
Design <- t(Design)
#Design <- Design[, -c(K), drop = FALSE]
Design <- print(Design, quote=FALSE)
write.table(Design, "~/RNAseq/4_results/Design.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote=FALSE)
rm(I,J,K,L)
sampleNames <- list.files(path="~/RNAseq/2_aligned/", all.files=FALSE, full.names=FALSE)
sampleNames <- gsub("_Aligned.sortedByCoord.out.bam", "", sampleNames)
metaData <- matrix("",length(sampleNames)+1,var+1)
for (I in c(1:length(sampleNames))) {
  J <- I+1
  metaData[J,1] <- sampleNames[I]
  print(metaData[J,1])
  print("Assign a value for the following Conditions:")
  for (K in c(1:var)) {
    L <- K+1
    M <- K*2
    metaData[1,L] <- Design[M]
    print(Design[M])
    N <- readline(prompt = ":")
    metaData[J,L] <- N
  }
}
rm(I,J,K,L,M,N,sampleNames,var)

write.table(metaData, "~/RNAseq/4_results/metaData.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote=FALSE)
coldata <-read.delim('~/RNAseq/4_results/metaData.txt',sep='\t',row.names=1)
cts <- read.delim('~/RNAseq/3_counts/featurecounts.Rmatrix.txt',sep='\t',row.names='Geneid',check.names=FALSE)
library("DESeq2")
fileName <- "~/RNAseq/4_results/Design.txt"
#d<-as.matrix(read.table("~/RNAseq/4_results/Design.txt",header=FALSE,sep="\t"))
dds <- DESeqDataSetFromMatrix(countData = cts,colData = coldata,design = ~ Day + Location + Treatment)
keep <- rowSums(counts(dds)) >= 10 # pre-filter the data set to remove rows with less than 10 reads
dds <- dds[keep,] # remove the filtered rows from the data set
dds$condition <- factor(dds$condition, levels = c("Vehicle","Boldine"))
dds <- DESeq(dds) # PERFORM THE DIFFERENTIAL EXPRESSION ANALYSIS
res <- results(dds) # write the results to a table
resLFC <- lfcShrink(dds, coef="Coefficient_You_Want_To_Shrink", type="apeglm") # shrink desired coefficient
resOrdered <- res[order(res$pvalue),] # order the list by p-value
res05 <- results(dds, alpha=0.05)
resSig <- subset(resOrdered, pvalue < 0.05)
write.csv(as.data.frame(resOrdered), file="~/RNAseq/4_results/DESeq_results_resSig.csv")