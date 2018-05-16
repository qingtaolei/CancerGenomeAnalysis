
open IN1, @ARGV[0];#normal
open OUT, ">".@ARGV[1].".vcf";

while(my $line1=<IN1>){
	chomp($line1);
	if($line1=~m/#CHROM/){print OUT $line1."\n";}
	if($line1!~m/#/){
		@elem1=split("\t",$line1);
		#$pos2=$elem2[0]."_".$elem2[1];
		$elem1[9] =~ m/.\/.:.,(.+)/;
		print $elem1[9]."\t".$1."\n";
		if($1 > 9){
			print OUT  $line1."\n";
		}
	}
}

