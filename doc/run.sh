set -vex
perl ../fly.pl --configdir config/ --resultdir result --outputdir outdir
tar cjf report.fly.tar.bz2 outdir/
