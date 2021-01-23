#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
${BASEPATH}/teic/Stylesheets/bin/teitolatex \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.latex
