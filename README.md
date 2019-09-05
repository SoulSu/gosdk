
### golang sdk download & version control tool


[![Build Status](https://api.cirrus-ci.com/github/SoulSu/gosdk.svg)](https://cirrus-ci.com/github/SoulSu/gosdk)


golang sdk 版本管理小工具

可以自由下载 golang sdk 版本

#### 终端简介

[![asciicast](https://asciinema.org/a/266086.svg)](https://asciinema.org/a/266086)

#### 安装方法


```bash
git clone https://github.com/SoulSu/gosdk.git ~/.gosdk/gosdk/
```


在 .zshrc 或者 .bashrc 中添加如下初始化脚本
```bash
[ -f ${HOME}/.gosdk/gosdk/gosdk.sh ] && source ${HOME}/.gosdk/gosdk/gosdk.sh && gosdk init
```


#### 使用方法

##### 查看本地版本

`gosdk l local`

##### 使用指定版本

`gosdk u go1.12.7`

##### 下载指定版本

`gosdk d go1.12.7`

##### 初始化 GOROOT 环境变量

`gosdk init`