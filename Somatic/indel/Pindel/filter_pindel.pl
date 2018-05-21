#print $ARGV[0];
open IN, $ARGV[0];
open OUT, ">".$ARGV[0].".tsv";
print OUT "chr\tstart\tend\tref_allele\talt_allele\n";
while(my $line=<IN>){
		chomp($line);
		#print $line."\n";
		if($line!~m/^#.+/){
		 @elem=split("\t",$line);
		 $elem[9]=~m/.\/.:.,(\d+)/;	
		#print $1."\n";
		 if($1 ge 3){
			print $1."\n";
			print OUT $elem[0]."\t".$elem[1]."\t".$elem[1]."\t".$elem[3]."\t".$elem[4]."\n";
		 }
		}
}
