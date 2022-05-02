% utils
% zdszero
% 2022-05-02

## PurePath

### 访问个别部分

* `parts`: 路径中各个目录和文件名的元组
* `parent`：父路径
* `parents`: 用`parents[i]`返回第i个父目录
* `name`：文件名
* `suffix`：后缀名
* `suffixes`: 后缀名列表
* `stem`：name去除suffix的部分

### 方法

* `as_posix() -> str`
* `as_uri() -> str`
* `is_absolute() -> bool`
* `is_relative_to(str) -> bool`
* `relative_to(str) -> PurePath`：计算两个路径间的相对路径
* `match(pat: str) -> bool`

## 实际路径Path

PurePath可以只能以字符串的方式对路径进行操作，并不能获得路径（即目录和文件）的具体信息，获得具体信息要用Path。

### 方法

* 基本
    * `cwd() -> PosixPath or WindowsPath`
    * `home()`
    * `expanduser()`
    * `resolve() -> Path`：获取绝对路径
    * `exists() -> bool`
    * `rename() -> Path`：重命名，如果存在相同文件且权限足够，则替换
* 操作文件
    * 获取文件属性
        * `stat() -> os.Stat`
        * `owner()`
        * `gourp()`
        * `chmod()`
        * `lchmod()`
        * `lstat()`
    * 链接
        * `symlink_to()`
        * `hardlink_to()`
        * `unlink()`
    * 目录
        * `rmdir()`：移除一个空目录
        * `touch()`
    * 文件
        * `open()`：以传统打开文件的方式操作这个文件
        * `read_bytes() -> bytes()`
        * `write_bytes()`
        * `read_text()`
        * `write_text()`
* 查找、遍历
    * `glob(pat: str)`
    * `rglob(pat: str)`：查找所有子目录，在pat前自动加上`**/`
    * `iterdir()`
* 判断文件类型
    * `is_dir()`
    * `is_file()`
    * `is_mount()`
    * `is_symlink()`
    * `is_socket()`
    * `is_fifo()`
    * `is_block_device()`
    * `is_char_device()`
    * `same_file(other_path)`

## subprocess
