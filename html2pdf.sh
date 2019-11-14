#!/bin/bash

if [ "$3" == "" ]
	then
	echo "
usage: $0 
	<input.html> *
	<cn/en> *
	<out.pdf> *
	<cover.pdf: optional>
	<backgound.pdf: optional>
"
	exit 1
fi

path=`readlink -f $(dirname $0)`
html2pdf_path=""
fontpath="$path/fonts"


# install font
if [ ! -f ~/.fonts/wqy-microhei.ttc ]; then
	wqy=`ls $fontpath/*wqy-microhei*tar.gz`
	echo installing wqy font...
	if [ ! -d ~/.fonts ]; then
		mkdir ~/.fonts
	fi
	tar zxf $wqy
	cp wqy-microhei/*.ttc  ~/.fonts
	rm -rf wqy-microhei
fi

# convert html to pdf
my_cover=""
my_background=""
if [ $# -eq 4 ];
then
	my_cover="cover $4"
fi
if [ $# -eq 5 ];
then
	my_background=$5
fi
my_html=$1
language=$2
my_pdf=$3
my_pdf_ori1="$3_ori1.pdf"
my_pdf_ori2="$3_ori2.pdf"
set -vex
wkhtmltopdf --page-size A4 --quiet --disable-external-links --print-media-type -O Portrait -T 20mm -R 10mm -B 30mm -L 10mm --outline-depth 3 $cover  toc --xsl-style-sheet $path/fonts/toc_$language.xsl --footer-center '[page]/[toPage]' --header-spacing 5 $my_html --page-offset -1 --footer-center '[page]/[toPage]' $my_pdf_ori1
mv $my_pdf_ori1 $my_pdf
echo $my_pdf
# use pdftk  to add backgound
# $pdftk_path $my_pdf_ori2 background $my_background output $my_pdf
# use gs to mrge multi pdfs to one pdf
#gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages -dCompressFonts=true -r150 -sOutputFile=../index.pdf $out
rm -f $my_pdf_ori1


