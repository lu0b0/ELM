#!/bin/bash
# new Env('萝卜-饿了么');
# 环境变量 elmck  值：SID=xxxx; cookie2=xxxx;   （按格式来）
#pwd

eval "rm -rf ./ELM"

_ftype=""
get_arch=`arch`
echo $get_arch
if [[ $get_arch =~ "x86_64" ]];then
	_ftype="amd64"
elif [[ $get_arch =~ "x86" ]];then
	_ftype="386"
elif [[ $get_arch =~ "i386" ]];then
	_ftype="386"
elif [[ $get_arch =~ "aarch64" ]];then
	_ftype="arm64"
elif [[ $get_arch =~ "arm" ]];then
	_ftype="arm"
else
	_ftype=""
fi

download_elm(){
echo "开始下载elm二进制文件到$PWD/ELM目录"
curl -sS -o $PWD/ELM/elm-$_ftype --create-dirs https://ghproxy.com/https://raw.githubusercontent.com/lu0b0/ELM/main/ELM/elm-$_ftype
echo "下载完成，如需重新下载或更新请先删除该文件"
if [ -f "$PWD/ELM/elm-$_ftype" ]; then
    echo "$PWD/ELM/elm-$_ftype"
    eval "chmod +x ./ELM/elm-$_ftype"
    eval "./ELM/elm-$_ftype -t elm"
fi
}

if [ $_ftype == "" ]; then
	echo "不支持的架构$get_arch"
else
	echo "执行$_ftype"
    if [ -f "$PWD/ELM/elm-$_ftype" ]; then
        echo "$PWD/ELM/elm-$_ftype"
        eval "chmod +x ./ELM/elm-$_ftype"
        eval "./ELM/elm-$_ftype -t elm"
    elif [ -f "$PWD/elm-$_ftype" ]; then
        echo "$PWD/elm-$_ftype"
        eval "chmod +x $PWD/elm-$_ftype"
        eval "$PWD/elm-$_ftype -t elm"
    else
        echo "在$PWD/ELM目录、$PWD目录下均未找到文件elm-$_ftype,尝试拉取远程仓库文件elm-$_ftype"
        download_elm
    fi
fi
