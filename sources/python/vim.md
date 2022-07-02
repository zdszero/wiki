% vim
% zdszero
% 2022-05-03

## vim中使用python代码

```
py3 statement

py3 << EOF
    python statements
EOF
```

可以通过`py3eval()`将python中的eval结果转化为vim格式

## python中使用vim模块

* 访问vim中的变量
```python
vim.eval('g:var_name')
vim.vars    # g:variable
vim.vvars   # v:variable
```

* 使用命令

```python
vim.command(cmd)
try:
    vim.command("put a")
except vim.error:
    raise
```

* buffer对象

可能想要达成的操作包括：修改内容、获取b:vars、获取local options

```python
b = vim.buffer[bufnr]
b[n] = str
b[n:m] = [str1, str2, ...]
del b[n]
for b in vim.buffers:
    # handling
```

* range对象

可以修改range中的内容、获取range的首末行号

* current对象

```
vim.current.line	The current line (RW)		String
vim.current.buffer	The current buffer (RW)		Buffer
vim.current.window	The current window (RW)		Window
vim.current.tabpage	The current tab page (RW)	TabPage
vim.current.range	The current line range (RO)	Range
```

* window对象
* tabpage对象

* IO

python的stdout作为vim的echo，python的stderr作为vim的echoerr，目前不支持stdin。

* 缺陷

无法直接传递vim变量到pyhton执行的代码作为参数，需要在python代码内用`vim.eval()`来获取变量

`:py3 func(l:vim_var)`
