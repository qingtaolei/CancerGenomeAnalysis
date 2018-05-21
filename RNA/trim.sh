#!/bin/bash
f=$1; 
ls /mnt/disk2/*/*/*_R1.fastq.gz | awk '{sub(/_R1.fastq.gz/,"",$1); print $1}' |uniq | \
awk 'NR=='"$f"'{print $0}' |\
perl -e 'chomp($f=<>);
$cmd="module load fastqc\
java -Xmx2048m -classpath  /opt/softwares/trimmomatic-0.36/trimmomatic-0.36.jar org.usadellab.trimmomatic.TrimmomaticPE -threads 6 -trimlog ".$f.".trim.log -phred33 -trimlog ./trimlog ".$f."_R1.fastq.gz ".$f."_R2.fastq.gz  ".$f."_R1.trimed.fastq.gz ".$f."_R1.fastqonly.fastq.gz  ".$f."_R2.trimed.fastq.gz ".$f."_R2.fastqonly.fastq.gz ILLUMINACLIP:/opt/softwares/trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:40:15 LEADING:20 TRAILING:20 HEADCROP:0  SLIDINGWINDOW:4:15 MINLEN:36";
system("$cmd"); 
'

