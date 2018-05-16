#ls ../../Results/*tumor*_SI | awk -F "tumor" '{print "somatic_filter.pl  "$1"normal.txt "$1"tumor.txt"}'
open IN1, @ARGV[0];#normal
open IN2, @ARGV[1];#tumor
open OUT, ">".@ARGV[2].".somatic.vcf";#sample_type

my %normal;
while(my $line1=<IN1>){
	chomp($line1);
	@elem1=split("\t",$line1);
	$pos1=$elem1[0]."_".$elem1[1];#."_".$elem1[3]."_"$elem1[4];
	$normal{$pos1}=1;
	#print $normal{$pos1}."\n";
}

while(my $line2=<IN2>){
	chomp($line2);
	if($line2=~m/#CHROM/){print OUT $line2."\n";}
	if($line2!~m/#/){
		@elem2=split("\t",$line2);
		$pos2=$elem2[0]."_".$elem2[1];#."_".$elem2[3]."_"$elem2[4];
		$elem2[9]=~m/(\d\/\d):\d+,(\d+)/;
		if((($1 eq "0/1")||($1 eq "1/1"))&&($2 ge 5)){
			print $normal{$pos2}."\n";
			unless(exists($normal{$pos2})){
				print OUT $line2."\n";
			}
		}
	}
}

