import sys
import re

# Handle arguments

if not 1 <= len(sys.argv)-1 <= 2:
    print('Error:')
    print('This takes 1 or 2 arguments, {} given'.format(len(sys.argv)-1))
    print('Usage : R2Rmd.py [input_path] [optionnal: output_path]');
    sys.exit()

input_path = sys.argv[1]
if len(sys.argv)-1 == 1:  # if only the input file has been specified
    # check whether there is or not a .R extension
    reg = re.findall('(.+?).R\Z',input_path)
    if reg:
        output_path = reg[0] + '.Rmd'
    else:
        output_path = input_path + '.Rmd'
else:
    input_path = sys.argv[1]
    output_path = sys.argv[2]


# Put all the contents of the file into a string that can be regexed
f_in = ''
with open(input_path, 'r') as f :
    for line in f:
        for char in line:
            f_in += char


# Do various find and replace using regex to get to the correct format

# Hashtags to put before title of differing levels of importance
TITLE_1 = '#'  # regex: (^# ?[IVC]+?\n)
TITLE_2 = '###'  # regex: (^# ?[IVC]+(\..+?)\n)
TITLE_3 = '###'  # regex: (^# ?[a-z]\)\n)

# Remove unnecessary white space
# (matches new lines before comment lines)
f_in = re.sub('^\n+?#','#', f_in, flags=re.MULTILINE)
# (matches new lines after comment lines)
f_in = re.sub('^(#.+?\n)\n+','\g<1>', f_in, flags=re.MULTILINE)

# Remove empty comment lines
# (matches hashtags followed by nothing or only whitespace until newline)
f_in = re.sub('^#(\s+?)?\n', '', f_in, flags= re.MULTILINE)

# Add hashtags before titles
# (matches what looks like a top title (ex: '# III'))
f_in = re.sub('(^# ?[IVC]+?\n)', '%s\g<1>'%TITLE_1, f_in, flags=re.MULTILINE)
# (matches what looks like a lower level title (ex: '# III.1.a)'))
f_in = re.sub('(^# ?[IVC]+(\..+?)\n)', '%s\g<1>'%TITLE_2, f_in, flags=re.MULTILINE)
# (matches what looks like a lower level title (ex: '# a)'))
f_in = re.sub('(^# ?[a-z]\)\n)','%s\g<1>'%TITLE_3, f_in, flags=re.MULTILINE)

# Put together comments line that belong together
# (matches comments lines followed by a comment line starting with a lowercase)
while len(re.findall('^# ?(.*?)\s+?# ?([a-z])', f_in, flags=re.MULTILINE)):
    f_in = re.sub('^# ?(.*?)\s+?# ?([a-z])','# \g<1> \g<2>', f_in, flags=re.MULTILINE)

# Add code tags
# (matches adjacent non-comment lines)
f_in = re.sub('^(([^#].*?\n)+)','```{r}\n\g<1>```\n\n', f_in, flags=re.MULTILINE)

# Add whitespace to separate comments and remove hashtags
# (matches comment lines)
f_in = re.sub('^# ?(.*?\n)','\g<1>\n', f_in, flags=re.MULTILINE)


# Put the translation into the output file
with open(output_path, 'w') as f_out:
    f_out.write(f_in)

print('Done !')
