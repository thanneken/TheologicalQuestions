#!/usr/bin/env bash
echo "Validating text.xml against structure.dtd"
xmlstarlet val -e -d structure.dtd text.xml
echo "Deriving text.html if text.xml is newer"
if [[ text.xml -nt text.html || html.xsl -nt text.html ]]; then
	java -jar /home/thanneken/git/teic/Stylesheets/lib/saxon9he.jar -xsl:html.xsl -s:text.xml -o:text.html -dtd:on
else
	echo "text.html is newer than text.xml"
fi
echo "Deriving pdf if text.xsl is newer" 
if [[ text.xml -nt text.pdf || latex.xsl -nt text.pdf ]]; then
	java -jar /home/thanneken/git/teic/Stylesheets/lib/saxon9he.jar -xsl:latex.xsl -s:text.xml -o:text.latex -dtd:on
	xelatex text.latex
	xelatex text.latex
	echo "Cleaning up intermediate files"
	rm -v text.aux
	rm -v text.latex 
	rm -v text.log
	rm -v text.toc
else
	echo "text.pdf is newer than text.xml"
fi
if [[ text.xml -nt text.epub ]]; then
	BASEPATH='/home/thanneken/git/'
	echo "Step 1: convert tei to epub"
	${BASEPATH}/teic/Stylesheets/bin/teitoepub3 \
		--localsource=${BASEPATH}teic/TEI/P5 \
		--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
		--profile=theologicalquestions \
		text.xml \
		text.epub
	echo "Step 2: convert epub to mobi"
	ebook-convert text.epub text.mobi
else
	echo "text.epub is newer than text.xml"
fi
