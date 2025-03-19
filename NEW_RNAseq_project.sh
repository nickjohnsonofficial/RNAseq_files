#!/bin/bash
mkdir  -p RNAseq/0_zips RNAseq/1_raw_data RNAseq/2_aligned RNAseq/3_counts RNAseq/4_results RNAseq/5_logs
cp -r ~/Genome_Indices/GRCm39/ ~/RNAseq/6_indices
bash RNAseq_analysis_all.sh
