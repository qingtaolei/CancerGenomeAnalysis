#!/bin/bash
f=$1; 
ls /media/public/Project_s599r04001/*/*_R1.fastq.gz| awk '{sub(/_combined_R1.fastq.gz/,"",$1); print $1}' |uniq | \
awk 'NR=='"$f"'{print $0}' |\
perl -e 'chomp($f=<>);
$f=~m/\/media\/public\/Project_s599r04001\/.+\/(.+)/;
$spl=$1;
$cmd="module load hisat2 \
module load samtools\
hisat2 -p 6 -x /media/public/reference/Human/UCSC/hg19/HISATIndex/genome -1 ".$f."_combined_R1.fastq.gz -2 ".$f."_combined_R2.fastq.gz | samtools view -bS - | samtools sort - -o /home/qingtao/qingtao/esccrna/mapping/".$spl.".sort.bam";
system("$cmd"); 
'

