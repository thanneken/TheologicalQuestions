#!/usr/bin/env bash
BASEPATH='/home/thanneken/git/'
FILE='TheologicalQuestions'
teitopdf \
	--localsource=${BASEPATH}teic/TEI/P5 \
	--profiledir=${BASEPATH}TheologicalQuestions/stylesheets/profiles \
	--profile=theologicalquestions \
	${BASEPATH}TheologicalQuestions/source/${FILE}.xml 
mv -v ${BASEPATH}TheologicalQuestions/source/${FILE}.xml.pdf ${BASEPATH}TheologicalQuestions/derivatives/${FILE}.pdf
rm -R ${BASEPATH}TheologicalQuestions/source/Pictures
