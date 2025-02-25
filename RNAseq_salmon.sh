#!/bin/bash

#salmon index -t ~/Genome_Indices/GRCm39/Fasta/Mus_musculus.GRCm39.cdna.all.fa -i ~/RNAseq/3.5_Salmon/mouse_index

# Making sure the genome indices is the 'transcriptome' I need for Salmon. I think it is.

cd ~/RNAseq/1_raw_data
fq=$1
if [[ $fq == *"_R1_001"* ]]; then
  echo "Sample name is $fq"  
  base=`basename $fq _R1_001.fastq`
  echo "Processing sample $base"
  salmon quant -i ~/RNAseq/3.5_Salmon/mouse_index -l A \
  -1 ${base}_R1_001.fastq \
  -2 ${base}_R2_001.fastq \
  -p 8 --validateMappings -o ~/RNAseq/2.5_Salmon/Quants/${base}_quant
fi

#salmon index -t transcripts.fastq -i transcripts_index --type quasi -k 31 # k of 31 for sequences longer than 75bp (current libraries contain 150bp sequences)









#Patro, R., Duggal, G., Love, M. I., Irizarry, R. A., & Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nature Methods.
