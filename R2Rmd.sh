#!/bin/bash

# Find the file's name to create the equivalent .Rmd filename
filename="$1"
if [ "${filename: -2}" == ".R" ]
    then filename=${1%??}
else filename="$1"
fi
f_Rmd="${filename}.Rmd"
touch "$f_Rmd"

# Put the contents of the .R file into the .Rmd file
cat "$1" > "$f_Rmd"

# Do various find and replace using regex to get to the correct format

# Hashtags to put before title of differing levels of importance
TITLE_1='#'  # regex: (^# ?[IVC]+?\n)
TITLE_2='###'  # regex: (^# ?[IVC]+(\..+?)\n)
TITLE_3='###'  # regex: (^# ?[a-z]\)\n)

# Function to replace regex ($1) matches with a given string ($2) in file ($3)
substitute(){
    echo "$(perl -0777pe "s/${1}/${2}/gm" "$3")" > "$3"
}

# Remove unnecessary white space
# (matches new lines before comment lines)
substitute "^\n+?#" "#" "$f_Rmd"
# (matches new lines after comment lines)
substitute "^(#.+?\n)\n+" "\$1" "$f_Rmd"

# Remove empty comment lines
# (matches hashtags followed by nothing or only whitespace until newline)
substitute "^#(\s+?)?\n" "" "$f_Rmd"

# Add hashtags before titles
# (matches what looks like a top title (ex: '# III'))
substitute "(^# ?[IVC]+?\n)" "${TITLE_1}\$1" "$f_Rmd"
# (matches what looks like a lower level title (ex: '# III.1.a)'))
substitute "(^# ?[IVC]+(\..+?)\n)" "${TITLE_2}\$1" "$f_Rmd"
# (matches what looks like a lower level title (ex: '# a)'))
substitute "(^# ?[a-z]\)\n)" "${TITLE_3}\$1" "$f_Rmd"

# Put together comments line that belong together
# (matches comments lines followed by a comment line starting with a lowercase)
# The match can do strange things, which is why it's in a while loop
# -P interpret as perl
# -z replace newlines with null chars so the file can be read as one line
# -c count the number of matches
while [ $(grep -Pzc '\n# ?(.*?)\s+?# ?([a-z])' "$f_Rmd") != 0 ]
do
    substitute "\n# ?(.*?)\s+?# ?([a-z])" "\n# \$1 \$2" "$f_Rmd"
done

# Add code tags
# (matches adjacent non-comment lines)
substitute "^(([^#].*?\n)+)" "\`\`\`{r}\n\$1\`\`\`\n\n" "$f_Rmd"

# Add whitespace to separate comments and remove hashtags
# (matches comment lines)
substitute "^# ?(.*?\n)" "\$1\n" "$f_Rmd"
