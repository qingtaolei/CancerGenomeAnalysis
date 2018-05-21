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

if [ ! -d "Scripts" ]; then
 mkdir Scripts;
fi

if [ ! -d "Data" ]; then
 mkdir Data;
fi

if [ ! -d "log" ]; then
 mkdir log;
fi

if [ ! -d "tmpdir" ]; then
 mkdir tmpdir;
fi



#######################################

#cat test.sample | while read line
#for f in $(cat 16SsampleInfo.txt)i
line=$1;
cat sample_info.txt |\
awk 'NR=='"$line"'{print $0}' |\
while read line

do
        #fq1=$(echo $line | awk '{print $1}');
	#fq2=$(echo $line | awk '{print $2}');
	sample=$(echo $line | awk '{print $3}');
	#nt=$(echo $line | awk '{print $4}');
	#fasta=$(echo $line | awk '{print $5}');
	#echo /home/chenxingdong/public/Project/exomeseq.sh $fq1 $fq2 $sample $nt $fasta > scripts/$sample.sh
	echo $line | awk '{print "/home/qingtao/qingtao/panelTest/exomeseq.sh "$1" "$2" "$3" "$4" "$5" "$6}'| awk '{ sub("\r$", ""); print }'  > Scripts/$sample.sh
	#echo $sample
	sh Scripts/$sample.sh > log/$sample.log
	#qsub -pe blast 6 scripts/$sample.sh
done
