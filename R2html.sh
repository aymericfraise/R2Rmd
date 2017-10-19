#!/bin/bash

file="$1"

if [ "${file: -2}" == ".R" ]
then filename=${file%??}
else filename=$file
fi

#python R2Rmd.py $file "${filename}.Rmd"
bash R2Rmd.sh "$file"

/usr/bin/Rscript -e "library(knitr); knitr::knit2html(\"${filename}.Rmd\")"

rm "${filename}.Rmd"
