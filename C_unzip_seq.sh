#!/bin/bash
echo "Unpacking zips"
cd ${rnaseq_dir}/0_zips
fq=$1
gunzip $fq
base=`basename $fq .fastq.gz`
mv ${base}.fastq ${rnaseq_dir}/1_raw_data
#for f in *.gz ; do gunzip -c "$f" > ~/RNAseq/1_raw_data/"${f%.*}" ; done
