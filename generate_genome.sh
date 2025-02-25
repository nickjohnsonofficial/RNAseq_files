#!/bin/bash

# Generate genome indices

STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir ~/Genome_Indices/GRCm39/ \
--genomeFastaFiles ~/Genome_Indices/GRCm39/Fasta/Mus_musculus.GRCm39.dna.toplevel.fa \
--sjdbGTFfile ~/Genome_Indices/GRCm39/GTF/Mus_musculus.GRCm39.111.gtf \
--sjdbOverhang 99
