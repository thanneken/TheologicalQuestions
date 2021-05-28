#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
xmlstarlet val -e -d ${BASEPATH}TheologicalQuestions/source/tei_tq.dtd ${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml
${BASEPATH}/teic/Stylesheets/bin/teitohtml5 \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/TheologicalQuestions.xml \
	${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.html
xmllint --format --recover --encode UTF-8 ${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions.html > ${BASEPATH}TheologicalQuestions/derivatives/TheologicalQuestions-pretty.html
