#!/bin/sh


# sdk dir
GOSDK_HOME=~/.gosdk/sdk/
# current sdk dir
GOSDK_CURRENT=~/.gosdk/sdk/current


# err code
# [1] not select version
# [2] download error


# 全局入口
gosdk(){
    currentVersion=$(readlink ${GOSDK_CURRENT} 2>/dev/null)
    remoteGo="https://golang.google.cn/dl/"

__gosdk_local_list(){
    echo "local go version"
    echo "========================================================================"
    for i in `ls -1 ${GOSDK_HOME} | grep -v current` ; do
        if [ "${i}" = "${currentVersion}" ]; then
            echo "\t$i [*] "
        else
            echo "\t$i"
        fi       
    done
    echo "========================================================================"
}

__gosdk_remote_list(){
    echo "========================================================================"
    curl "${remoteGo}" -s | grep "id=\"go" | cut -d "\"" -f 4
    echo "========================================================================"
}

__gosdk__init(){
    [ ! -d ${GOSDK_HOME} ] && mkdir -p ${GOSDK_HOME}
    export GOROOT=${GOSDK_CURRENT}
    export PATH=${PATH}:${GOROOT}/bin/
}



__gosdk__download(){
    version=$1
    if [ "${version}" = "" ]; then
        echo "please input a version to download"
        return 1
    fi

    read -p "download arch is [amd64|arm64|386]" dArch
    read -p "download os is [darwin|linux|windows|freebsd]" dOs

    if [ "${dArch}" = "" ]; then
      dArch=$(arch)
    fi

    if [ "${dOs}" = "" ]; then
      dOs=$(uname -s)
    fi
    dArch=$(echo $dArch| tr "A-Z" "a-z")
    dOs=$(echo $dOs| tr "A-Z" "a-z")

    case ${dArch} in
    x86_64)
      dArch="amd64"
      ;;
    esac

    dExt=""
    case ${dOs} in
      darwin|linux)
        dExt=".tar.gz"
        ;;
      windows)
        dExt=".zip"
        ;;
    esac

    fileName="${version}.${dOs}-${dArch}${dExt}"
    dUrl="https://dl.google.com/go/${fileName}"
    tempDir=$(mktemp -d)
    cd ${tempDir} &>/dev/null

    wget ${dUrl}
    if [ "${dExt}" = ".tar.gz" ]; then
      tar vxf ${fileName} && mv go ${GOSDK_HOME}/${version}
    fi


    cd -&>/dev/null
    rm -rf ${tempDir}
}


__gosdk__use(){
    version=$1

    if [ "${version}" = "" ]; then
        echo "please select a version"
        __gosdk_local_list
        return 1
    fi
    # version not exists do download
    if [ ! -d "${GOSDK_HOME}${version}" ]; then
        if [ ! `__gosdk__download "${version}"` ]; then
            return 2
        fi
    fi
    # use version is current version 
    if [ "${version}" = "${currentVersion}" ]; then
         return 0
    fi

    rm ${GOSDK_CURRENT} &>/dev/null

    cd ${GOSDK_HOME}; ln -s ${version} ${GOSDK_CURRENT}; cd &>/dev/null
    return 0
}

# set -x
case $1 in
    l|list)
        if [ "$2" = "local" ]; then
            __gosdk_local_list
        else
            __gosdk_remote_list
        fi
    ;;
    u|use)
        version=$2
        __gosdk__use ${version}
    ;;
    d|download)
        version=$2
        __gosdk__download ${version}
    ;;
    init)
        __gosdk__init
    ;;
    *)
cat <<EOF
gosdk is a CLI library for go sdk download & change.

Usage:
   [command]

Available Commands:
  list          list remote or local go version
  init          init set goroot path env
  use           change go sdk version
  download      download new go version
  help          Help about any command

Use " [command] --help" for more information about a command.
EOF
    ;;
esac
}
