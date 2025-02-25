#!/bin/bash
cd ~/RNAseq/1_raw_data
for f in *.fastq ; STAR --runThreadN 10 --genomeDir ~/RNAseq/5_indices/GRCm39/ --outSAMstrandField intronMotif --outFilterScoreMinOverLread 0.66 --outFilterMatchNminOverLread 0.66 --outFilterIntronMotifs RemoveNoncanonical --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ~/RNAseq/2_aligned/"${f%.*}" --readFilesIn ~/RNAseq/1_raw_data/"$f" ; done
