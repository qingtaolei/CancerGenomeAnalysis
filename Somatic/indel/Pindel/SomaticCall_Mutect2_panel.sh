#!/bin/bash

############################################
tumor_bam=$1
normal_bam=$2
sample=$3
nt=$4
ref=$5
bed=$6
############################################
##module load
#module load bwa
#module load fastqc
#module load samtools 
#module load picard
#gatk="/home/chenxingdong/software/GenomeAnalysisTK-3.8-0"
#samtools="/home/chenxingdong/software/samtools-0.1.19/samtools"
#varscan="/home/chenxingdong/software"
#java="/home/chenxingdong/software/jre1.8.0_144/bin/java"
gatk="/opt/softwares/GATK-3.6.0"
samtools="/opt/softwares/samtools-1.3.1/samtools"
############################################
# Log file 
logfile="$sam.$(date +"%Y%m%d%H%M").log"
echo $bed
#====== bianll======
logfile="$sampleName.$(date +"%Y%m%d%H%M").log"

set -x
exec >$logfile
start_time=$(date +%s)
startdate=$(date -d @$start_time)


##VarScan2
#start_time_mod=$(date +%s)
#$samtools mpileup -f $ref/hg19_nochr.fa  -q 50 -B $normal_bam  $tumor_bam | $java -Xmx12g -jar $varscan/VarScan.v2.3.9.jar somatic --min-coverage 8 --min-coverage-normal 8 --min-coverage-tumor 6 --min-var-freq 0.08 --min-avg-qual 20 --mpileup 1 --output-vcf 1 --output-snp "Results"/$sample.VarScan2.snp.txt --outputindel "Results"/$sample.VarScan2.indel.txt --strand-filter 1 --p-value 0.05
#end_time_mod=$(date +%s)
#echo "Module VarScan2 Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile

##MuTect2
#if [ ! -n $interval ]; then  
#  target="-L "$interval  
#else  
#  target=""  
#fi
start_time_mod=$(date +%s)
java -Xmx100g -Djava.io.tmpidir=tmpdir/${sample}_tmp -jar $gatk/GenomeAnalysisTK.jar -T MuTect2 -nct $nt -R $ref/hg19_nochr.fa -I:tumor $tumor_bam -I:normal $normal_bam --dbsnp $ref/dbsnp_132_b37.leftAligned.vcf --cosmic $ref/b37_cosmic_v54_120711.vcf -L $bed -o "Results"/$sample.mutect2.panel.vcf

end_time_mod=$(date +%s)
echo "Module MuTect2 Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile



