#!/bin/bash
#command:
f=$1;
cat samples.txt| awk '{sub(/_combined_R1.fastq.gz/,"",$1); print $1}' |uniq | \
awk 'NR=='"$f"'{print $0}' |\
perl -e 'chomp($f=<>);
$f=~m/\/media\/public\/Project_s599e03006\/.+\/(.+)/;
$spl=$1;
$cmd="
module load bwa\
module load samtools\

bwa aln /media/public/reference/gatk/hg19_nochr.fa -t 6  ".$f."_combined_R1.fastq.gz  > ./Results/".$1."_1.sai \
bwa aln /media/public/reference/gatk/hg19_nochr.fa -t 6  ".$f."_combined_R2.fastq.gz  > ./Results/".$1."_2.sai \
bwa sampe /media/public/reference/gatk/hg19_nochr.fa -r \"\@RG\\tID:".$1."\\tLB:".$1."\\tPU:".$1."\\tPL:Illumina 1.9\\tSM:".$1."\" ./Results/".$1."_1.sai ./Results/".$1."_2.sai ".$f."_combined_R1.fastq.gz ".$f."_combined_R1.fastq.gz | samtools view -bSu - > ./Results/".$1.".rg.sort.bam \
samtools flagstat Results/".$1.".rg.sort.bam > QC/mapping_stat/".$1.".bam.stat \
samtools  view -F 4 -b ./Results/".$1.".rg.sort.bam | samtools sort - ./Results/".$1.".rg.mapped.sorted \
java -Xmx8g -jar /opt/softwares/picard-tools-1.90/MarkDuplicates.jar TMP_DIR=./tmp INPUT=./Results/".$1.".rg.mapped.sorted.bam OUTPUT=./Results/".$1.".rg.sorted.dedup.bam METRICS_FILE=./Results/".$1.".metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true \
java -Xmx8g -jar /opt/softwares/picard-tools-1.90/BuildBamIndex.jar INPUT=./Results/".$1.".rg.sorted.dedup.bam \
java -Xmx12g -Djava.io.tmpdir=./tmpdir -jar /opt/softwares/GenomeAnalysisTK-3.1-1/GenomeAnalysisTK.jar -T RealignerTargetCreator -log ./log/".$1."_real.log -R /media/public/reference/gatk/hg19_nochr.fa -I ./Results/".$1.".rg.sorted.dedup.bam -o ./Results/".$1.".intervals -known /media/public/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19_nochr.vcf --filter_mismatching_base_and_quals \
java -Xmx12g -Djava.io.tmpdir=./tmpdir -jar /opt/softwares/GenomeAnalysisTK-3.1-1/GenomeAnalysisTK.jar -rf NotPrimaryAlignment -log ./log/".$1."_indel_real.log -I ./Results/".$1.".rg.sorted.dedup.bam -R /media/public/reference/gatk/hg19_nochr.fa -T IndelRealigner -targetIntervals ./Results/".$1.".intervals -o ./Results/".$1.".rg.sorted.dedup.realign.bam -known /media/public/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19_nochr.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4 ";
system($cmd);'
