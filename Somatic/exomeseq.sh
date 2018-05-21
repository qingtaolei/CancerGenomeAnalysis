#!/bin/bash
############################################
fastq_1=$1;
fastq_2=$2;
group=$3;
sample=$3;
sam=$3;
nt=$4;
fasta=$5;
############################################
##module load
module load bwa
module load fastqc
module load samtools 
pl="ILLUMINA" #platform

#bwa="/home/chenxingdong/software/bwa-0.7.16a/bwa";
#fastqc="/home/chenxingdong/software/FastQC/fastqc";
#samtools="/home/chenxingdong/software/samtools-0.1.19/samtools";
picard="/opt/softwares/picard-tools-2.5.0/picard.jar"
gatk="/opt/softwares/GATK-3.6.0"
trimmomatic="/opt/softwares/trimmomatic-0.36/trimmomatic-0.36.jar"
adapter="/opt/softwares/trimmomatic-0.36/adapters/TruSeq3-SE.fa"
#java="/home/chenxingdong/software/jre1.8.0_144/bin/java"
ref="/media/public/reference/gatk/"
cd /home/qingtao/qingtao/panelTest
data="Data"
############################################
# Log file 
logfile=$sample.$(date +"%Y%m%d%H%M").log


set -x
exec >$logfile
start_time=$(date +%s)
startdate=$(date -d @$start_time)

##run fastqc for raw sequencing data
start_time_mod=$(date +%s)


#run fastqc
start_time_mod=$(date +%s)
#fastqc -t $nt -o "QC/FastQC" ${fastq_1}
#fastqc -t $nt -o "QC/FastQC" ${fastq_2}
end_time_mod=$(date +%s)
if [ "$OSTYPE" = "darwin"* ]; then start_date=$(date -j -f "%s" $start_time_mod); else start_date=$(date -d @$start_time_mod); fi
if [ "$OSTYPE" = "darwin"* ]; then end_date=$(date -j -f "%s" $end_time_mod); else end_date=$(date -d @$end_time_mod); fi
echo "Module fastQC Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile


#run trim
#######################################
#FastQ trim
#java -jar /opt/softwares/trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 $dataDir/"$f"$suffix    $workDir/"$f".trimed$suffix    ILLUMINACLIP:/opt/softwares/trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:18
#java -jar /opt/softwares/trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 $dataDir/"$f"$suffix    $workDir/"$f".trimed$suffix    ILLUMINACLIP:/opt/softwares/trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:18
start_time_mod=$(date +%s)
#java -Xmx2048m -classpath  $trimmomatic org.usadellab.trimmomatic.TrimmomaticPE -threads $nt -trimlog $sample.trim.log -phred33 -trimlog "./trimlog" $fastq_1 $fastq_2  ${data}/${sample}_R1.trimed.fastq.gz ${data}/${sample}_R1.fastqonly.fastq.gz ${data}/${sample}_R2.trimed.fastq.gz ${data}/${sample}_R2.fastqonly.fastq.gz ILLUMINACLIP:${adapter}:2:40:15 LEADING:20  TRAILING:20 HEADCROP:0 SLIDINGWINDOW:4:15 MINLEN:36
end_time_mod=$(date +%s)
echo "Module Trimmomatic Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile

##################################### 


# ******************************************
# 1. Mapping reads with BWA-MEM. Output coordinate-sorted BAM file.
# ******************************************
start_time_mod=$(date +%s)
#bwa mem -M -R '@RG\tID:$group\tSM:$sample\tPL:$pl' -t $nt ${fasta} ${data}/${sample}_R1.trimed.fastq.gz ${data}/${sample}_R2.trimed.fastq.gz | samtools view -bSu - >  "Results"/$sample.bam
# samtools  view -F 4 -b "Results"/$sample.bam | samtools sort - -o "Results"/$sample.mapped.sorted.bam
#$samtools  view -F 4 -b "Results"/$sample.sam | $samtools sort - "Results"/${sam}.sorted.bam
end_time_mod=$(date +%s)
if [ "$OSTYPE" = "darwin"* ]; then start_date=$(date -j -f "%s" $start_time_mod); else start_date=$(date -d @$start_time_mod); fi
if [ "$OSTYPE" = "darwin"* ]; then end_date=$(date -j -f "%s" $end_time_mod); else end_date=$(date -d @$end_time_mod); fi
echo "Module BWA Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile

# ******************************************
# 2. Metrics
#
# Alignment summary. 
# ******************************************
start_time_mod=$(date +%s)
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${sentieonDir}/${sam}.sorted.bam --algo MeanQualityByCycle ${sentieonDir}/${sam}_mq_metrics.txt --algo QualDistribution ${sentieonDir}/${sam}_qd_metrics.txt --algo GCBias --summary ${sentieonDir}/${sam}_gc_summary.txt ${sentieonDir}/${sam}_gc_metrics.txt --algo AlignmentStat ${sentieonDir}/${sam}_aln_metrics.txt --algo InsertSizeMetricAlgo ${sentieonDir}/${sam}_is_metrics.txt --algo CoverageMetrics --omit_base_output ${sentieonDir}/${sam}_coverage_metrics
#$SENTIEON_INSTALL_DIR/bin/sentieon plot metrics -o ${sentieonDir}/${sam}_metrics_report.pdf gc=${sentieonDir}/${sam}_gc_metrics.txt qd=${sentieonDir}/${sam}_qd_metrics.txt mq=${sentieonDir}/${sam}_mq_metrics.txt isize=${sentieonDir}/${sam}_is_metrics.txt 
#echo $samtools flagstat "Results"/$sample.bam > "QC/mapping_stat"$sample.bam.stat
end_time_mod=$(date +%s)
if [ "$OSTYPE" = "darwin"* ]; then start_date=$(date -j -f "%s" $start_time_mod); else start_date=$(date -d @$start_time_mod); fi
if [ "$OSTYPE" = "darwin"* ]; then end_date=$(date -j -f "%s" $end_time_mod); else end_date=$(date -d @$end_time_mod); fi
echo "Module metrics Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile


# ******************************************
# 3. Remove Duplicate Reads
#
# This step will mark and remove duplicates.
# If only marking without removal is desired, remove -rmdup option in the second command.
# ******************************************
start_time_mod=$(date +%s)
#java -Xmx8g -jar $picard MarkDuplicates TMP_DIR=./tmp INPUT="Results"/$sample.mapped.sorted.bam OUTPUT="Results"/$sample.sorted.dedup.bam METRICS_FILE="Results"/$sample.sorted.dedup.metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true
#java -Xmx8g -jar $picard BuildBamIndex INPUT="Results"/$sample.sorted.dedup.bam

#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i ${sentieonDir}/${sam}.sorted.bam --algo LocusCollector --fun score_info ${sentieonDir}/${sam}_score.txt
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i ${sentieonDir}/${sam}.sorted.bam --algo Dedup --rmdup --score_info ${sentieonDir}/${sam}_score.txt --metrics ${sentieonDir}/${sam}_dedup_metrics.txt ${sentieonDir}/${sam}.sorted.deduped.bam 
end_time_mod=$(date +%s)
if [ "$OSTYPE" = "darwin"* ]; then start_date=$(date -j -f "%s" $start_time_mod); else start_date=$(date -d @$start_time_mod); fi
if [ "$OSTYPE" = "darwin"* ]; then end_date=$(date -j -f "%s" $end_time_mod); else end_date=$(date -d @$end_time_mod); fi
echo "Module dedup Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile

# ******************************************
# 5. Indel realigner
#
# This step produces InDel-realigned BAM file.
# ******************************************
start_time_mod=$(date +%s)
java -Xmx12g -Djava.io.tmpdir=./tmpdir -jar $gatk/GenomeAnalysisTK.jar -T RealignerTargetCreator -log ./log/$sample.real.log -R $fasta -I "Results"/$sample.sorted.dedup.bam -o "Results"/$sample.intervals -known ${ref}/Mills_and_1000G_gold_standard.indels.hg19_nochr.vcf --filter_mismatching_base_and_quals
java -Xmx12g -Djava.io.tmpdir=./tmpdir -jar $gatk/GenomeAnalysisTK.jar -rf NotPrimaryAlignment -log ./log/$sample_indel_real.log -I "Results"/$sample.sorted.dedup.bam -R $fasta -T IndelRealigner -targetIntervals "Results"/$sample.intervals -o "Results"/$sample.sorted.dedup.realign.bam -known ${ref}/Mills_and_1000G_gold_standard.indels.hg19_nochr.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${sentieonDir}/${sam}.sorted.deduped.bam --algo Realigner -k $db_1000G -k $db_mills ${sentieonDir}/${sam}.sorted.deduped.realigned.bam
end_time_mod=$(date +%s)
if [ "$OSTYPE" = "darwin"* ]; then start_date=$(date -j -f "%s" $start_time_mod); else start_date=$(date -d @$start_time_mod); fi
if [ "$OSTYPE" = "darwin"* ]; then end_date=$(date -j -f "%s" $end_time_mod); else end_date=$(date -d @$end_time_mod); fi
echo "Module realign Started: "$start_date"; Ended: "$end_date"; Elapsed time: "$(($end_time_mod - $start_time_mod))" sec">>$logfile
