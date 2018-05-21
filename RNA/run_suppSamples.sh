module load hisat2 
module load samtools
hisat2 -p 6 -x /media/public/reference/Human/UCSC/hg19/HISATIndex/genome -1  Sample_RN1705230094LR01/RN1705230094LR01_combined_R1.trimed.fastq.gz -2  Sample_RN1705230094LR01/RN1705230094LR01_combined_R2.trimed.fastq.gz | samtools view -bS - | samtools sort - -o /home/qingtao/qingtao/esccrna/mapping/RN1705230094LR01.sort.bam

module load subread
featureCounts --primary -a /media/public/reference/Human/UCSC/hg19/Annotation/genes.gtf -o RN1705230094LR01.codingRNA.featureCounts /home/qingtao/qingtao/esccrna/mapping/RN1705230094LR01.sort.bam
featureCounts --primary -a /media/public/reference/Human/Annotation/GRCh37/gencode.v19.long_noncoding_RNAs.gtf -o RN1705230094LR01.ncRNA.featureCounts /home/qingtao/qingtao/esccrna/mapping/RN1705230094LR01.sort.bam
