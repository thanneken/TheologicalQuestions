#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
teitoepub3 \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.epub
