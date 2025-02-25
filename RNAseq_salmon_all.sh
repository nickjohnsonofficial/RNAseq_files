#!/bin/bash

# useage: bash -i ~/scripts/RNAseq_salmon_all.sh 

# make the directory for the lightweight alignment
mkdir ~/RNAseq/2.5_Salmon
mkdir ~/RNAseq/2.5_Salmon/Quants

# perform the lightweight alignment using Salmon
conda activate salmon
cd ~/RNAseq/1_raw_data
for fq in ~/RNAseq/1_raw_data/*.fastq; do
bash ~/scripts/RNAseq_salmon.sh $fq
done

# MultiQC
#mkdir ~/RNAseq/4_results/multiqc_report
multiqc -n ~/RNAseq/3.5_Salmon/salmon_multiqc_report_rnaseq ~/RNAseq/4_results/fastqc/*.zip ~/RNAseq/3.5_Salmon/Quants/*

## Could be continued, but multiQC gave a lower alignment score than featurecounts/STAR
