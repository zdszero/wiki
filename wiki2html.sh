#!/bin/bash

# reference: https://gist.github.com/maikeldotuk/54a91c21ed9623705fdce7bab2989742

INPUT=$1
OUTPUT=$2
TEMPLATE=$3

HAS_MATH=$(grep -o "\$.\+\$" "$INPUT")
if [ -n "$HAS_MATH" ]; then
    MATH="--mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
else
    MATH=""
fi

# [test](test.md) -> <link href="test.html">
# [test](test) -> <link href="test.html">
sed -r 's/(\[.+\])\((.+)\.md\)/\1(\2.html)/g' < $INPUT | pandoc $MATH --template=$TEMPLATE -f markdown -t html --toc > $OUTPUT
