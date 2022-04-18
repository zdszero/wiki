#!/bin/bash

# reference: https://gist.github.com/maikeldotuk/54a91c21ed9623705fdce7bab2989742

SYNTAX=$2
EXTENSION=$3
OUTPUTDIR=$4
INPUT=$5

# Added ones
TEMPLATE_PATH=$7
TEMPLATE_DEFAULT=$8
TEMPLATE_EXT=$9
ROOT_PATH=$10

# [ "$ROOT_PATH" -eq "-" ]] && ROOT_PATH=''


FILE=$(basename "$INPUT")
FILENAME=$(basename "$INPUT" ."$EXTENSION")
FILEPATH=${INPUT%$FILE}
OUTDIR=${OUTPUTDIR%$FILEPATH*}
# OUTPUT="${OUTDIR}/${FILENAME}${TEMPLATE_EXT}"
OUTPUT="${OUTDIR}/${FILENAME}.html"
CSSFILENAME=$(basename "$6")
FULL_TEMPLATE="${TEMPLATE_PATH}/${TEMPLATE_DEFAULT}"

HAS_MATH=$(grep -o "\$\$.\+\$\$" "$INPUT")
if [ -n "$HAS_MATH" ]; then
    MATH="--mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
else
    MATH=""
fi

# >&2 echo "MATH: $MATH"

# sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g' <"$INPUT" | pandoc $MATH --template="$FULL_TEMPLATE" -f "$SYNTAX" -t html -c "$CSSFILENAME" -M root_path:"$ROOT_PATH" | sed -r 's/<li>(.*)\[ \]/<li class="todo done0">\1/g; s/<li>(.*)\[X\]/<li class="todo done4">\1/g' > /tmp/crap.html

sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g' < $INPUT | pandoc --template=$FULL_TEMPLATE -f markdown -t html --template=$FULL_TEMPLATE --toc > $OUTPUT

# With this you can have ![pic of sharks](file:../sharks.jpg) in your markdown file and it removes "file" 
# and the unnecesary dot html that the previous command added to the image. 
# sed 's/file://g' < /tmp/crap.html | sed 's/jpg.html/jpg/g' > "$OUTPUT.html"
