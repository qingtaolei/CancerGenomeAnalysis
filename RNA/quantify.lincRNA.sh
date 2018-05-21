#!/bin/bash
f=$1; 
ls /home/qingtao/qingtao/esccrna/mapping/*.sort.bam | awk '{sub(/.sort.bam/,"",$1); print $1}' |uniq | \
awk 'NR=='"$f"'{print $0}' |\
perl -e 'chomp($f=<>);
$f=~m/\/home\/qingtao\/qingtao\/esccrna\/mapping\/(.+)/;
$spl=$1;
$cmd="module load stringtie\
module load samtools\
#samtools flagstat  ".$f.".sort.bam > ".$f.".bamstat\
stringtie ".$f.".sort.bam -G /media/public/reference/Human/Annotation/GRCh37/gencode.v19.long_noncoding_RNAs.gtf -e  -o /home/qingtao/qingtao/esccrna/mapping/".$spl.".ncRNA.gtf";
system("$cmd"); 
'

