#!/usr/bin/perl -w
=head1 Name
	ilikeorangeapple@gmail.com or https://github.com/orangeSi
=head1 Useage
	convert document to html file
	perl fly.pl
				 --configdir 	<str> config dir
				 --resultdir   	<str> result dir
				 --outputdir  	<str> outdir

=cut

use Getopt::Long;
use Switch;
use FindBin qw($Bin);
use File::Basename qw(basename dirname);

my ($Step,$rdir,$odir);
GetOptions(
	"configdir:s"=>\$configdir,
	"resultdir:s"=>\$rdir,
	"outputdir:s"=>\$odir,
);

if(!$configdir or !$rdir or !$odir){
	die `pod2text $0`;
}
`mkdir -p $odir/html && mkdir -p $odir/html/css && mkdir -p $odir/html/png && cp $Bin/base.css $odir/html/css`;
my $html;
open HTML,">$odir/html/report.html" or die "$!";
#my @samples=glob("$rdir/Separate/*");
#my $sample_stat="$rdir/Abstract/Sample.statistics.xls";
#if(@samples ==0){die "In $rdir,sample is not exist!\n";}

if( -e $configdir){
	$html.=&lovefree($configdir);
}else{
	die "$configdir not exist\n";
}



### get hash form xls
sub gethash{
	my $in=shift;
	my %hstat;
	$input=`ls $in 2>/dev/null`;
	if($?){
		print "error:not exists $in\n";
		exit;
	}
	open IN,"$input" or die "gethash:$input not exist\n";
	my $row;
	$/="\n";
	while(<IN>){
		chomp;
		$row+=1;
		my @tmp=split(/\t+/,$_);
		if(@tmp==1){print "warn: make sure $input seperated by \\t\n"}
		my $col;
		for my $k(@tmp){
			$col++;
			$hstat{$row}{$col}=$k;
		}
		#print "input is$input;row is$row;\n";
	}
	close IN;


	return (%hstat);
}


### hash -> table
sub generate_table{
	my $stat=shift;
	my $tmp="<table align=\"center\" width=\"auto\" cellspacing=\"0\" style=\"word-break:break-all\">";
	my $rowflag=0;
	my $rows=scalar(keys %$stat);

	my $singleclass="singleclass1";
	my $doubleclass="doubleclass1";
	my $tailsingle="tailsingle1";
	my $taildouble="taildouble1";
	my $flag;

	foreach my $r (sort {$a<=>$b} keys %$stat){
		$rowflag++;
		if($r==1){$tmp.="\n<tr bgcolor=\"orange\" align=\"center\" >\n";}else{ $tmp.="\n<tr align=\"center\" >\n";}
		my $check_diff_sample=1;
		foreach my $c (sort {$a<=>$b} keys %{$$stat{$r}}){
			if($$stat{$r}{$c} ne " "){
				$check_diff_sample=0;	
			}

		}
#		print "check_diff_sample is $check_diff_sample\n";
		if($check_diff_sample){
#			foreach my $c (sort {$a<=>$b} keys %{$$stat{$r}}){
#				$tmp.="\n<td class=\"seprateclass\">$$stat{$r}{$c}</td>\n";
			#
#			}
#			print "next\n";
#			next
			if($flag){$flag=0}else{$flag=1}
			if($flag){			
				$singleclass="singleclass2";
				$doubleclass="doubleclass2";
				$tailsingle="tailsingle2";
				$taildouble="taildouble2";
			}else{

				$singleclass="singleclass1";
				$doubleclass="doubleclass1";
				$tailsingle="tailsingle1";
				$taildouble="taildouble1";
			}

			next

		}
		foreach my $c (sort {$a<=>$b} keys %{$$stat{$r}}){
			if($rowflag==1){
				$tmp.="\n<td class=\"headerclass\">$$stat{$r}{$c}</td>\n"
			}elsif($rowflag==$rows){
				if($rowflag %2){

					$tmp.="\n<td class=\"$tailsingle\">$$stat{$r}{$c}</td>\n"
				}else{
					$tmp.="\n<td class=\"$taildouble\">$$stat{$r}{$c}</td>\n"
				}
			}else{
				if($rowflag %2){
					$tmp.="\n<td class=\"$singleclass\">$$stat{$r}{$c}</td>\n"
				}else{
					$tmp.="\n<td class=\"$doubleclass\">$$stat{$r}{$c}</td>\n"
				}
			}
		}
		$tmp.="</tr>";
	}
	$tmp.="</table>";
	return ($tmp);

}


### config -> html
sub lovefree{
	my $configdir=shift;
	my $tmp;
	my @path=glob("$configdir/[0-9].*.txt");
	my $f;
	for my $p(@path){
		my $base=`basename $p`;
		$base=~ /^(\d+)/;
		$f=$1-1;
		my ($second,$third,$forth,$fifth);
		my $old=0;
		open CONFIG,"$p" or die "lovefree:$p not exist\n";
		$/="ilikeorange";
		<CONFIG>;
		my $foryou;	
		while(<CONFIG>){
			chomp;
			my @apples=split(/ilikeapple/,$_);
			my $first=shift @apples;
			my $indexs;
#			$first || next;
#			print "first is$first;nextis$apples[0];nextis$apples[1];line is$_;\n\n";
			my ($xx,$index,$flag,$check)=split(/\s+/,$first);	
#			print  "index is $index\n";
#if(!$flag){print "flag is $k\n";my $next=<CONFIG>;print "flag1 isnot $next\n";my $next=<CONFIG>;print "flag2 isnot $next\n";}
			#print "k is $k;xx is $xx;index is $index;flag is $flag;check is $check;line is $_\n";
#			print "seq is $/;\nline is $_\n";
#			if(!$flag){print "flag is $flag \n";}
			if($flag==1){
				$check=~ s/\s+$//g;
				my @tmp=split(/,/,$check);		
				for my $k(@tmp){
					$k || next;
					my $tmp_dir;
					if($k=~ /^config/){$tmp_dir=$configdir}else{$tmp_dir=$rdir}
#					my @k_tmp=split(/\n/,`ls $tmp_dir/$k 2>/dev/null`);
					my $tmptt=`ls $tmp_dir/$k 2>/dev/null`;
					my @k_tmp=split(/\s+/,$tmptt);
					#print "1 is $k_tmp[0];2 is $k_tmp[1];\n";
					foreach my $tmpcheck(@k_tmp){
						$tmpcheck=~ s/\s+//g;
#						print "tmpcheck is $tmpcheck\n";
						if( -e $tmpcheck ){	
							$flag=0;last
						}
					}

				}
			}
			if($flag==1){$foryou=1;next}
			switch ($index){
				case 0 {if($index < $old){$second=0;$third=0;$forth=0;$fifth=0}$f++;$old=$index}
				case 1 {if($index > $old){$second=0}elsif($index < $old){$third=0;$forth=0;$fifth=0}$second++;$old=$index}
				case 2 {if($index > $old){$third=0}elsif($index < $old){$forth=0;$fifth=0;}$third++;$old=$index}
				case 3 {if($index > $old){$forth=0}elsif($index < $old){$fifth=0}$forth++;$old=$index}	
				case 4 {if($index > $old){$fifth=0}$fifth++;$old=$index}	
				case -1 {}
				else    {die "error!index is not acceptable in $p;\n  index is $index;first is $first\n";exit }
			}

			for my $k($f,$second,$third,$forth,$fifth){
				$k || next ;
				$indexs.="$k.";
			}

#			print "indexs is$indexs;\n";
#			if(!$indexs){print "file is$k;\nline is$_;\n";}
			$indexs=~ s/\.$//;
			for my $k(@apples){
				$k=~ s/\s*$//;
				$k=~ s/\n/<br>/g;
				$k=~ /^\s*(\S+)\s+(.*)/;
				my $tag=$1;
				my $value=$2;
				if(!$value){die "content is null for $k;value is $_;next line is ",<CONFIG>,"\n";}
				if($value=~ /config/){$tmp_dir=$configdir}else{$tmp_dir=$rdir}
				#$tag || print "apple is$k;\ntag is$tag;\nvalue is$value;\n";;
#				if(!$tag){print "k is$k;\n";}	

				#print "k is$k;tag is$tag;value is$value;\n";
				switch ($tag){
					case "p"		{$value=~ s/^[\d\.]+/$indexs/;$tmp.="<h1><p id=\"p$indexs\" class=\"p\">$value</p></h1>\n" }
					case "p2"		{$value=~ s/^[\d\.]+/$indexs/;$tmp.="<h2><p id=\"p$indexs\" class=\"p2\">$value</p></h2>\n"}
					case "p3"		{$value=~ s/^[\d\.]+/$indexs/;$tmp.="<h3><p id=\"p$indexs\" class=\"p3\">$value</p></h3>\n"}
					case "p4"         	{$value=~ s/^[\d\.]+/$indexs/;$tmp.="<h4><p id=\"p$indexs\" class=\"p4\">$value</p></h4>\n"}
					#case "pindex"		{$value=~ s/^[\d\.]+/$indexs/;my @nums=$indexs=~ /(\d)/g;my $num=scalar @nums;my $space="&nbsp;"x$num;$tmp.="<p  class=\"pindex\">${space}$value</p>\n"}
					case "plist"		{
#									my $len=length($value);
#									print "len is $len\n";
						$value=~ s/\n\s+/\n/g;$value=~ s/\|\s+/\|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/g;
						$value=~ s/\[/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\[/g;
						$tmp.="<p class=\"plist\">$value</p>\n";
					}
					case "psoft"		{
						$value=~ s/^([^:]+:)/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>$1<\/B>/;$value=~ s/<br>([^:]+:)/<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>$1<\/B>/g;
						$tmp.="<p class=\"pfasta\">$value</p>";

					}
					case "pbold"      	{$tmp.="<p class=\"pbold\">$value</p>\n"}
					case "pcontent"		{$tmp.=&getpcontent($value);}
					case "pfasta"		{$value=~ s/^/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/;$value=~ s/<br>/<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/g;$tmp.="<p class=\"pfasta\">$value</p>\n"}##
					case "pintro"		{$tmp.="<p class=\"pintro\">$value</p>\n"}##
					case "table"		{my %table=&gethash("$tmp_dir/$value");$tmp.=&generate_table(\%table);$/="ilikeorange"}
					case "tabledetail"  	{$tmp.=&gettabledetail($value);}
					#case "pngdetail"	{$value=~ s/^/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/;$tmp.="<p class=\"pngdetail\">$value</p>\n"}##
					case "pngdetail"	{$value=~ s/^/&nbsp;&nbsp;/;$value=~ s/\\n/<br>&nbsp;&nbsp;/g;$tmp.="<p class=\"pngdetail\">$value</p>\n"}##
					case "pngs"		{
						#       pngs 			1	2	Separate/xxxx/1.Cleandata/*{base,qual}.png
						#       pngs                    0       xx.png									
						my $pngs_tmp=&getpngs($value);
						if(!$pngs_tmp){print "skip: $value is not exists in $p\n";$pngs_tmp=""}
						$tmp.=$pngs_tmp;
					}
					#case "SNP"          	{$tmp.=&getsnp($value);$/="ilikeorange";}
					#case "INDEL"          	{$tmp.=&getindel($value);$/="ilikeorange";}
					#case "SV"          	{$tmp.=&getsv($value);$/="ilikeorange";}


					else			{die "tag error;tag is$tag;config is $base;k is $k\n;next line is "+<CONFIG>+"\n"; }

				}
				#print "\ntmp is $tmp\n";

			}

		}
		close CONFIG;
		if($foryou){$f=$f -1}
	}
	print HTML "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><link href='css/base.css' rel='stylesheet' type='text/css' /></head><body>$tmp</body></html>\n";


}

close HTML;
print "done\n";
sub getpcontent(){
	my $value=shift;
	$value=~ s/^/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/;
	$value=~ s/<br>/<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/g;
	return "<p class=\"pcontent\">$value</p>\n";

}
sub gettabledetail(){
	my $value=shift;
	return "<p class=\"tabledetail\">$value</p>\n";
}

sub getsnp(){
	my $value=shift;
	#Combination/SNP/SNP_*/*total.cds.stat
	my @snps=glob("$tmp_dir/$value");
	my $tmp;
	foreach my $k(@snps){
		my $snpdir=dirname($k);
		my $pcontent=`cat $snpdir/pcontent`;
		$tmp.=&getpcontent($pcontent);
		my $stat=`ls $snpdir/*total.cds.stat`;
		#	print "is $tmp_dir $stat\n";
		my %table=&gethash("$stat");
		$tmp.=&generate_table(\%table);
		my $detail=`cat $snpdir/detail`;
		$tmp.=&gettabledetail($detail);
		print "getsnp done\n";	
	}

	return $tmp;
}

sub getindel(){
	my $value=shift;
	my @indels=glob("$tmp_dir/$value");
	my $tmp;
	foreach my $k(@indels){
		my $indeldir=dirname($k);
		my $base=`basename $indeldir`;
		$base=~ s/\s*$//g;
		my $pcontent=`cat $indeldir/pcontent`;
		$tmp.=&getpcontent($pcontent);
		$tmp.=&gettabledetail("InDel类型统计结果:");
		my %table=&gethash("$indeldir/*InDel_type.stat.xls");
		$tmp.=&generate_table(\%table);
		$tmp.=&gettabledetail(`cat $indeldir/*InDel_type.stat.xls.readme`);
		$tmp.="<br><br>";
		$tmp.=&gettabledetail("InDel引起的基因突变类型结果统计:");
		my %table2=&gethash("$indeldir/*InDel_mutation.stat.xls");
		$tmp.=&generate_table(\%table2);
		$tmp.=&gettabledetail(`cat $indeldir/*InDel_mutation.stat.xls.readme`);
		$tmp.=&gettabledetail("各样品Indel数目统计:");
		$tmp.=&getpngs("0	Combination/InDel/$base/*InDel_number.png");
	}
	return $tmp;
}
sub getsv(){
	my $input=shift;
	my $tmp;
	foreach my $k(`ls $input`){
		my $vs=basename $k;
		$vs=~ /^([^-]+)-(.*)$/;
		my $ref=$1;
		my $sample=$2;
		if(!$ref || !$sample){
			die "$input/$k format error~\n";
		}
		$tmp.=&getpcontent("");


	}

}

sub getpngs(){
	my $value=shift;
	my $tmp;

	$value=~ /^\s*(\d+)/;
	if($1){
		$value=~ /^\s*(\d+)\s+(\d+)/;
		my $limit_disply=$2;
		my $sample_index;
#									print "limit_disply is $limit_disply;vaule is $value\n";
		$value=~ /(\S+)\/xxxx/;
		#print "\n1 is$rdir/$1;\n";
		my @samples=split(/\s+/,`ls $tmp_dir/$1/ 2>/dev/null`);
		for my $xx(@samples){
			chomp $xx;
			$xx || next;
			$sample_index++;
			#print "xx is$xx;\n";
			my $tmpxx=$value;
			$tmpxx=~ s/^\d+\s+\d+\s+//;
			$tmpxx=~ s/\s+//g;
			$tmpxx=~ s/xxxx/$xx/;
			`ls $tmp_dir/$tmpxx 2>/dev/null`;
			if($?){next}
			if($sample_index >$limit_disply){
#												$tmp.="<p class=\"pbold\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;样品名 $xx:<br>"
				$tmp.="<p class=\"pngdetail\" align=\"center\">注：其余样品图片见相应目录</p>";last;
			}else{
				$tmp.="<p class=\"pbold\" align=\"center\">$xx</p><br>";
			}

			#print "xx is$xx;is $tmpxx;\n";
			my $pngsnum=`cd  $tmp_dir;ls -l $tmpxx 2>/dev/null |wc -l 2>/dev/null`;
			chomp $pngsnum;
			my $pngflag;
#										print "zz;pngnum is $pngsnum;tmp_dir is $tmp_dir;tmpxx is $tmpxx;value is $value\n";
			for my $png(split(/\s+/,`cd  $tmp_dir;ls $tmpxx 2>/dev/null`)){
				chomp $png;
				$png || next;
				#	print "png is$png;\n";
				my $tmpbase=`cd  $tmp_dir;basename $png`;$tmpbase=~ s/\s*$//;

				`cp $tmp_dir/$tmpxx $odir/html/png`;
				$pngflag++;
				#print "cc\n";
				if($sample_index >$limit_disply){
					#	print "xx\n";		
					$tmp.="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$png;"
				}else{
					#	print "yy\n";
					if($pngsnum %2){
						$tmp.="<p align=\"center\"><img src=\"png/$tmpbase\" width=\"60%\"  title=\"png/$tmpbase\" /></p>"
					}else{
						$tmp.="<img src=\"png/$tmpbase\" width=\"45\%\"  title=\"png/$tmpbase\" />";
						if(!($pngflag %2)){$tmp.="<br>"}	
					}
				}
			}
			if($sample_index >$limit_disply){
				$tmp.="</p>";
			}
#										$tmp.="<br>\n";

		}

	}else{
		#$vaule=~ /^\d+\s+(.*)/;
		$value=~ s/^\d+\s+//;

		my @pnglist=split(/,/,$value);
		for my $k(@pnglist){
			$k || next;
#											print "\nk is $k\n";
			my $tmp_png=$k;
			$k=`cd $tmp_dir;ls $k 2>/dev/null`;
			if($?){
				die "$tmp_dir/$tmp_png is not found!\n";
			}
			$k=~ s/\s+$//;
			my $tmpbase=`cd  $tmp_dir;basename $k`;$tmpbase=~ s/\s*$//;
			`cp $tmp_dir/$k $odir/html/png`;
			if($?){
				die "die:cp $tmp_dir/$k $odir/html/png\n";
			}
			$tmp.="\n<p class=\"img\"  align=\"center\" ><img src=\"png/$tmpbase\" width=\"70%\" title=\"png/$tmpbase\" /></p><br>\n"
		}

	}

	return $tmp;

}

