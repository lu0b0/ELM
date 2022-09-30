#!/bin/bash
# new Env('萝卜-饿了么');
# 环境变量 elmck  值：SID=xxxx; cookie2=xxxx;   （按格式来）
#pwd
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

if [ $_ftype == "" ]; then
	echo "不支持的架构$get_arch"
else
	echo "执行$_ftype"
    if [ -f "$PWD/ELM/elm-$_ftype" ]; then
        echo "$PWD/ELM/elm-$_ftype"
        eval "chmod +x ./ELM/elm-$_ftype"
        eval "./ELM/elm-$_ftype -t elm"
    else
        if [ ! -f "$PWD/elm-$_ftype" ]; then
            echo "在$PWD/ELM目录、$PWD目录下均未找到文件elm-$_ftype"
            exit 1
        fi
        echo "$PWD/elm-$_ftype"
        eval "chmod +x $PWD/elm-$_ftype"
        eval "$PWD/elm-$_ftype -t elm"
    fi
fi