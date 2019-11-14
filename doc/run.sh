# if Switch.pm is missing, yum install -y perl-Switch in centos
# conda install -c anaconda libgcj-cos6-x86_64
#cd /root/miniconda3/x86_64-conda_cos6-linux-gnu/sysroot/usr/lib64/; ln -sf libgcj.so.10 libgcj.so.7rh
#export LD_LIBRARY_PATH=/root/miniconda3/x86_64-conda_cos6-linux-gnu/sysroot/usr/lib64/:$LD_LIBRARY_PATH
set -vex

export PERL5LIB=$PWD/../:$PERL5LIB
base=$PWD
/usr/bin/perl5.16.3 ../fly.pl --configdir config/ --resultdir result --outputdir $base/outdir
sh ../html2pdf.sh  outdir/html/report.html  cn outdir/html/report.pdf
tar cjf report.fly.tar.bz2 outdir/
