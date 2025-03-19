#!/bin/bash
for fq in base_dir/RNAseq/0_zips/*.gz; do
bash base_dir/scripts/C_unzip_seq.sh $fq
done
for fq in base_dir/RNAseq/1_raw_data/*.fastq; do
echo "running analysis on $fq"
bash base_dir/scripts/D_RNAseq_analysis_1.sh $fq
done
# count mapped reads
echo "Counting mapped reads"
gtf=base_dir/Genome_Indices/GRCm39/GTF/Mus_musculus.GRCm39.111.gtf
counts_out=base_dir/RNAseq/3_counts/featurecounts.txt
bams=base_dir/RNAseq/2_aligned/*out.bam
#n=find . -type f | wc -l
#temp_arr=(1:$n)

featureCounts -T 12 -p --countReadPairs -B -P -d 50 -D 600 -s 2 -t exon -g gene_id -a $gtf -o $counts_out $bams
mv base_dir/RNAseq/3_counts/featurecounts.txt.summary base_dir/RNAseq/4_results/
cd base_dir/RNAseq/2_aligned
shopt -s nullglob
numfiles=(*)
numfiles=${#numfiles[@]}
last_field=($((x=6, x+$numfiles)))
first_last_fields=($(seq 7 1 $last_field))
keepers=f1
keepers+=" ${first_last_fields[@]}"
cut -${keepers// /,} base_dir/RNAseq/3_counts/featurecounts.txt > base_dir/RNAseq/3_counts/featurecounts.Rmatrix.txt
sed -i -e 's/\/home\/pharmacology\/RNAseq\/2_aligned\///g' ~/RNAseq/3_counts/featurecounts.Rmatrix.txt
sed -i -e 's/_Aligned.sortedByCoord.out.bam//g' ~/RNAseq/3_counts/featurecounts.Rmatrix.txt
sed -i '1d' ~/RNAseq/3_counts/featurecounts.Rmatrix.txt
tail -n +2 "~/RNAseq/3_counts/featurecounts.Rmatrix.txt" > "~/RNAseq/3_counts/featurecounts.Rmatrix.txt.tmp" && mv "~/RNAseq/3_counts/featurecounts.Rmatrix.txt.tmp" "~/RNAseq/3_counts/featurecounts.Rmatrix.txt"

# MultiQC
mkdir ~/RNAseq/4_results/multiqc_report
multiqc -n ~/RNAseq/4_results/multiqc/multiqc_report_rnaseq ~/RNAseq/4_results/fastqc/*.zip ~/RNAseq/5_logs/*Log.final.out ~/RNAseq/4_results/featurecounts.txt.summary


#
ml R/4.2.0
R
Rscript ~/scripts/E_RNAseq_analysis_2.R
