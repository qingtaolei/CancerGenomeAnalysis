#!/bin/bash

############################################
tumor_bam=$1
normal_bam=$2
sample=$3
nt=$4
ref=$5

############################################
##module load
#module load bwa
#module load fastqc
#module load samtools 
#module load picard
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


##VarScan2
start_time_mod=$(date +%s)
#$samtools mpileup -q 30 -f $ref/hg19_nochr.fa $normal_bam > "Results"/${sample}.normal.pipleup
#$samtools mpileup -q 30 -f $ref/hg19_nochr.fa $tumor_bam > "Results"/${sample}.tumor.pipleup
java -Xmx12g -jar $varscan/VarScan.jar somatic  "Results"/${sample}.normal.pipleup "Results"/${sample}.tumor.pipleup  --min-coverage 3 --min-coverage-normal 3 --min-coverage-tumor 3 --min-var-freq 0.01 --min-avg-qual 20 --mpileup 1 --output-vcf 1 --output-snp "Results"/${sample}.VarScan2.snp.txt --output-indel "Results"/${sample}.VarScan2.indel.txt --strand-filter 1 --p-value 0.05


#$samtools mpileup -f $ref/hg19_nochr.fa  -q 30 -B $normal_bam  $tumor_bam | $java -Xmx12g -jar $varscan/VarScan.v2.3.9.jar somatic --min-coverage 8 --min-coverage-normal 8 --min-coverage-tumor 5 --min-var-freq 0.08 --min-avg-qual 20 --mpileup 1 --output-vcf 1 --output-snp "Results"/$sample.VarScan2.snp.txt --output-indel "Results"/$sample.VarScan2.indel.txt --strand-filter 1 --p-value 0.05
end_time_mod=$(date +%s)
#echo "Module VarScan2 Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile


java -Xmx12g -jar $varscan/VarScan.jar copyCaller  "Results"/${sample}.normal.pipleup "Results"/${sample}.tumor.pipleup  --output-file "Results"/${sample}.VarScan2.copynumber 

java -Xmx12g -jar $varscan/VarScan.jar copyCaller  "Results"/${sample}.normal.pipleup "Results"/${sample}.tumor.pipleup  --output-file "Results"/${sample}.VarScan2.copynumber


start_time_mod=$(date +%s)
java -Xmx12g -jar $varscan/VarScan.jar  processSomatic  "Results"/${sample}.VarScan2.snp.txt.vcf
java -Xmx12g -jar $varscan/VarScan.jar  processSomatic  "Results"/${sample}.VarScan2.indel.txt.vcf

end_time_mod=$(date +%s)
#echo "Module All Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile



