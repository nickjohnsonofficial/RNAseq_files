#!/bin/bash
echo "Unpacking zips"
cd ~/RNAseq/0_zips
fq=$1
gunzip $fq
base=`basename $fq .fastq.gz`
mv ${base}.fastq ~/RNAseq/1_raw_data
#for f in *.gz ; do gunzip -c "$f" > ~/RNAseq/1_raw_data/"${f%.*}" ; done
