#!/bin/bash

############################################
normal_bam=$1
tumor_bam=$2
sample=$3
nt=$4
ref=$5

############################################
##module load
#module load bwa
#module load fastqc
#module load samtools 
#module load picard
module load delly
gatk="/opt/softwares/GATK-3.6.0"
#samtools="/opt/softwares/samtools-1.3.1/samtools"
samtools="/opt/softwares/samtools-1.6/samtools"
varscan="/opt/softwares/VarScan2"
#java="/home/chenxingdong/software/jre1.8.0_144/bin/java"
############################################
# Log file 
cd /home/qingtao/qingtao/panelTest 
#====== bianll======
logfile="log/${sample}.$(date +"%Y%m%d%H%M").log"

set -x
exec >$logfile
start_time=$(date +%s)
startdate=$(date -d @$start_time)

Type=("DEL" "DUP" "INV" "BND" "INS")

for name in ${Type[@]}
do
delly call -t $name  -o ${sample}.${name}.bcf -g /media/public/reference/gatk/hg19_nochr.fa $tumor_bam $normal_bam 
#delly call -t DUP  -o PGx28.DUP.bcf -g /media/public/reference/gatk/hg19_nochr.fa $tumor_bam $normal_bam
#delly call -t INV  -o PGx28.INV.bcf -g /media/public/reference/gatk/hg19_nochr.fa $tumor_bam $normal_bam
#delly call -t BND  -o PGx28.BND.bcf -g /media/public/reference/gatk/hg19_nochr.fa $tumor_bam $normal_bam
#delly call -t INS  -o PGx28.INS.bcf -g /media/public/reference/gatk/hg19_nochr.fa $tumor_bam $normal_bam
delly filter -t $name -f somatic -o ${sample}.${name}.filter.bcf  ${sample}.${name}.bcf
/opt/softwares/delly/src/bcftools/bcftools  view ${sample}.${name}.filter.bcf > ${sample}.${name}.delly.vcf
done
end_time_mod=$(date +%s)
#echo "Module All Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile



