#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
echo "Step 1: convert tei to epub"
${BASEPATH}/teic/Stylesheets/bin/teitoepub3 \
	--verbose \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.epub
if which ebook-convert; then 
	echo "Step 2: convert epub to mobi"
	ebook-convert \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.epub \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.mobi
else
	echo "Calibre ebook-convert tool for generating .mobi for Kindle not found, skipping..."
fi
# --coverimage=/home/thanneken/git/TheologicalQuestions/source/media/Cover-Magdalene-1200x1800.jpg \
