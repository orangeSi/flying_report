set -vex
export PERL5LIB=$PWD/../:$PERL5LIB
base=$PWD
perl ../fly.pl --configdir config/ --resultdir result --outputdir $base/outdir
tar cjf report.fly.tar.bz2 outdir/
