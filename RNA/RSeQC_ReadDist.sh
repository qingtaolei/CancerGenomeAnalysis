#!/bin/bash
dataDir="/media/public/IBFC2017340"
workDir="/home/qingtao/qingtao/singlecell2017"
suffix=".sort.bam"
refData="/media/public/reference/Human/UCSC/hg19/HISATIndex/genome"
gtf="/media/public/reference/Human/UCSC/hg19/Annotation/genes.gtf"
rseqcref="/media/public/reference/RSeQC/hg19.refseq.bed12"
f=$1;
cat sample.txt | awk '{sub(/'$suffix'/,"",$1); print $1}' |\
awk 'NR=='"$f"'{print $0}' |\
while read f
do
    module load RSeQC/2.3.7
    module load hisat2
    module load samtools
    module load stringtie
    # Ѳ׊ǀ¹
    #fastqc -o $workDir/QC/fastqc $dataDir/"$f"$suffix
    #java -jar /opt/softwares/trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 $dataDir/"$f"$suffix    $workDir/"$f".trimed$suffix    ILLUMINACLIP:/opt/softwares/trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:18
    # mapping
    #hisat2 -x $refData -U $workDir/"$f".trimed$suffix   | samtools view -bS - |  samtools sort - -o $workDir/mapping/"$f".sort.bam
    # עˍ²¢¼ǋ㲭´������
    #samtools  flagstat  $workDir/mapping/"$f".sort.bam > $workDir/QC/bamstat/"$f".bamstat
    #stringtie $workDir/mapping/"$f".sort.bam -G $gtf -e -o $workDir/quant/"$f".gtf
    #geneBody_coverage.py -i mapping/"$f".sort.bam -r "$rseqcref" -o "$f".gb
    read_distribution.py -i  mapping/"$f".sort.bam  -r /media/public/reference/RSeQC/hg19.refseq.bed12 > "$f".readdist.txt
done

