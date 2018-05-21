#convert vcf to tsv
@files=<.vcf>;

foreach $f(@file){
	$f=~m/(.+\.(\w+))\.somatic.vcf/;
	$type=$1;
	$nam=$2;
	open IN, $f;
	open OUT, ">".$1."tsv";
    while(my $line=<IN>){
	chomp($line);
	if($line=~m/#CHROM/){print OUT "chr\tstart\tend\tID\tref_allele\talt_allele\tQUAL\tFILTER\tINFO\tFORMAT\tTUMOR\n";}
	if($line!~m/#/){
		@elem=split("\t",$line);
		if($type=="SI"){
			print OUT $elem[0]."\t".$elem[1]."\t".$elem[1]."\t".join("\t",@elem[2..9]);
		}
		if($type=="D"){
			$elem[7]=~m/.+SVLEN=-(\w+);.+/;
			print OUT $elem[0]."\t".$elem[1]."\t".$elem[1]+$1-1."\t".join("\t",@elem[2..9]);
		}
	}

}