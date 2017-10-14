#!/bin/bash

file=$1

if [ "${file: -2}" == ".R" ]
then filename=${file%??}
else filename=$file
fi

python R2Rmd.py $file "${filename}.Rmd"

/usr/bin/Rscript -e "library(rmarkdown); render(\"${filename}.Rmd\", output_format = 'html_document')"

rm "${filename}.Rmd"
