#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
echo "Step 1: convert tei to epub"
${BASEPATH}/teic/Stylesheets/bin/teitoepub3 \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.epub
echo "Step 2: convert epub to mobi"
ebook-convert \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.epub \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.mobi

