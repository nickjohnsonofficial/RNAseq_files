#!/bin/bash
## This script takes a fastq file of RNA-Seq data, runs FastQC and outputs a counts file for it.
## USAGE: sh rnaseq_analysis_on_input_file.sh <name of fastq file>
## RNAseq analysis on input files
cd ~/RNAseq/1_raw_data
fq=$1
## run FastQC and move output to the appropriate folder
echo "Assessing quality of file $fq"
fastqc $fq
mkdir -p ~/RNAseq/4_results/fastqc
mv *fastqc* ~/RNAseq/4_results/fastqc/
cd ~/RNAseq/4_results/fastqc
for f in *.zip ; do unzip -c "$f" > ~/RNAseq/4_results/fastqc/"${f%.*}" ; done
if [[ $fq == *"_R1_001"* ]]; then
  echo "Sample name is $fq"  
  base=`basename $fq _R1_001.fastq`         
  genome=/home/pharmacology/Genome_Indices/GRCm39
  gtf=/home/pharmacology/Genome_Indices/GRCm39/GTF/Mus_musculus.GRCm39.111.gtf
  align_out=/home/pharmacology/RNAseq/2_aligned/${base}_
  counts_input_bam=/home/pharmacology/RNAseq/2_aligned/${base}_Aligned.sortedByCoord.out.bam
  ## run STAR
  echo "Aligning $fq to genome"
  STAR --runThreadN 12 --genomeDir $genome --sjdbGTFfile $gtf --outSAMstrandField intronMotif --outFilterScoreMinOverLread 0.66 --outFilterMatchNminOverLread 0.66 --outFilterIntronMotifs RemoveNoncanonical --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $align_out --readFilesIn ~/RNAseq/1_raw_data/${base}_R1_001.fastq ~/RNAseq/1_raw_data/${base}_R2_001.fastq
  mkdir -p ~/RNAseq/4_results/STARgenome ~/RNAseq/4_results/SJ
  cd ~/RNAseq/2_aligned
  mv *Log* ~/RNAseq/5_logs
  mv *SJ* ~/RNAseq/4_results/SJ
  mv *STARgenome* ~/RNAseq/4_results/STARgenome
  ## create BAM index
  echo "Creating BAM index"
  samtools index $counts_input_bam
  mkdir -p ~/RNAseq/4_results/Alignment_Quality
  mv ~/RNAseq/2_aligned/*bai* ~/RNAseq/4_results/Alignment_Quality
fi








#Zhu, A., Ibrahim, J.G., Love, M.I. (2018) Heavy-tailed prior distributions for sequence count data: removing the noise and preserving large differences. Bioinformatics. 10.1093/bioinformatics/bty895

