#!/bin/bash
cd ~/RNAseq/1_raw_data
fastqc *.fastq
mkdir ~/RNAseq/4_results/fastqc/
mv *fastqc* ~/RNAseq/4_results/fastqc/
cd ~/RNAseq/4_results/fastqc
for f in *.zip ; do unzip -c "$f" > ~/RNAseq/4_results/fastqc/"${f%.*}" ; done
