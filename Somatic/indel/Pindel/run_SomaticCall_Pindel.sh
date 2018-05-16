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
if [ ! -d "log" ]; then
 mkdir log;
fi

#######################################

cat sample_info.txt | while read line
do
        #fq1=$(echo $line | awk '{print $1}');
	#fq2=$(echo $line | awk '{print $2}');
	sample=$(echo $line | awk '{print $3}');
	#nt=$(echo $line | awk '{print $4}');
	#fasta=$(echo $line | awk '{print $5}');
	#echo /home/chenxingdong/public/Project/exomeseq.sh $fq1 $fq2 $sample $nt $fasta > scripts/$sample.sh
	echo '#PBS -l nodes=compute_node_3:ppn=12' > Scripts/$sample.somatic.pindel.sh
	echo '#PBS -l walltime=144:00:00' >> Scripts/$sample.somatic.pindel.sh
	echo '#PBS -j oe' >> Scripts/$sample.somatic.pindel.sh
	echo '#PBS -N Pindel' >> Scripts/$sample.somatic.pindel.sh
	echo $line | awk '{print "/home/libin/Projects/qtPindel201711/SomaticCall_Pindel.sh "$1" "$2" "$3" "$4" "$5}'| awk '{ sub("\r$", ""); print }'  >> Scripts/$sample.somatic.pindel.sh
	qsub  Scripts/$sample.somatic.pindel.sh
done
