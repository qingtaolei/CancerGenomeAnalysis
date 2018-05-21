################mkdir##################
if [ ! -d "QC" ]; then  
 mkdir QC;
 mkdir QC/qc_stat;
 mkdir QC/clip_stat;
 mkdir QC/FastQC;
 mkdir QC/fastqc_table;
 mkdir QC/mapping_stat;
fi

if [ ! -d "Results" ]; then
 mkdir Results;
fi

if [ ! -d "Analysis" ]; then
 mkdir Analysis;
fi
#######################################

cat somatic_call_sample.txt | while read line
do
        #fq1=$(echo $line | awk '{print $1}');
	#fq2=$(echo $line | awk '{print $2}');
	sample=$(echo $line | awk '{print $3}');
	#nt=$(echo $line | awk '{print $4}');
	#fasta=$(echo $line | awk '{print $5}');
	#echo /home/chenxingdong/public/Project/exomeseq.sh $fq1 $fq2 $sample $nt $fasta > scripts/$sample.sh
	echo $line | awk '{print "/home/qingtao/qingtao/panelTest/SomaticCall_Pindel.sh "$1" "$2" "$3" "$4" "$5}'| awk '{ sub("\r$", ""); print }'  > Scripts/$sample.somatic.pindel.sh
	sh Scripts/$sample.somatic.pindel.sh
done
