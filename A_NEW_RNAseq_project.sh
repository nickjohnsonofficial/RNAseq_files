#!/bin/bash
### IMPORTANT: Define your base directory before you run this script! ###
base_dir="path/to/chosen/directory/"
mkdir -p base_dir/RNAseq/0_zips RNAseq/1_raw_data RNAseq/2_aligned RNAseq/3_counts RNAseq/4_results RNAseq/5_logs
cp -r base_dir/Genome_Indices/GRCm39/ base_dir/RNAseq/6_indices
bash base_dir/scripts/B_RNAseq_analysis_all.sh
