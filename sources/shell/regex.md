% regex
% zdszero
% 2022-05-07

## sed

### BRE ERE

BRE中关于**首位、字符集合、任意**不转义，包括字符`^ $ . * []`，ERE同perl中正则类似。

### replacement flags

```
g  # 表示行内全面替换。  
p  # 表示打印行。  
w  # 表示把行写入一个文件。  
x  # 表示互换模板块中的文本和缓冲区中的文本。  
y  # 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\1 # 子串匹配标记
&  # 已匹配字符串标记
```

### operations

```sh
# delete
sed '1d'
sed '4,$d'

# insert
sed '1,3i\haha'

# change
sed '1,3c\haha' # change the 1 to 3 lines into haha (1 line)

# subsititute
sed '1,3s/.*/haha/'
sed -n 's/test/TEST/p'# only display changed lines

# read
sed '/test/r file' filename # append filename to lines in file starting with test

# write
sed -n '/^hello/w file2' file # quitely find all lines starting with and write to file2

# combine several operations
sed 'expr1; expr2'
sed -e 'expr1' -e 'expr2'
sed 'expr1' | sed 'expr2'
```

## awk
