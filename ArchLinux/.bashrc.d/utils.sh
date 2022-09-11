#!/usr/bin/bash

# Github proxy
ghProxyUrl=""
ghSSHUrl="git@git.zhlh6.cn"

function getGhProxyUrl() {
    ghProxyUrl="https://ghproxy.com/${1}"
}

function wgetgh() {
    getGhProxyUrl $1
    wget "${ghProxyUrl}"
}

function ghclone() {
    getGhProxyUrl $1
    git clone "${ghProxyUrl}"
}

function ghssh() {
    if [ "$1" == "add" ];then
        if [ -n "$2" ] && [ -n "$3" ];then
            git remote add ssh "${ghSSHUrl}:$2/$3.git"
        else
            echo "Please use give github username and name of repository"
        fi
    elif [ "$1" == "del" ];then
        if [ -n "$2" ];then
            git remote rm ssh
        fi
    else
        echo "Add"
    fi
}

# Other utils
function checkDirContainName() {
    echo -n "Checking $2..."
    if [ -z "$(cd $1 && ls -d *$2* 2> /dev/null)" ];then
        echo "not found"
        return 0
    else
        echo "found"
        return 1
    fi
}

# SMB utils
function mount_smb() {
	# $1 is mountpoint
	# $2 is target
	mountpoint ${1} &> /dev/null
	if [ $? -ne 0 ];then
	        sudo mount -t drvfs ${2} ${1}
	fi
}

# PATH utils
function pathreset() {
    export PATH="${PATH_BAK}"
}

function pathcat() {
    if [ -n "$1" ];then
        APPEND=""
        if [ "$1" == "pwd" ];then
            APPEND="${PWD}"
        elif [ -d "$1" ];then
            APPEND="$1"
        fi
        if [ -n "$2" ] && [ "$2" == "--back" ];then
            export PATH="${PATH}:${APPEND}"
        else
            export PATH="${APPEND}:${PATH}"
        fi
    fi
}

# Kernel build utils
buildEnvIsInited="false"
toolChainDir=""
armToolChain=""
aarch64ToolChain=""

function printBuildEnv() {
    echo "toolChain: ${toolChainDir}"
    echo "armToolChain: ${armToolChain}"
    echo "aarch64ToolChain: ${aarch64ToolChain}"
}

function checkToolChainDir() {
    echo "Checking toolchain..."
    RET=0
    checkDirContainName "$1" "gcc"
    if [ $? == 1 ];then
        RET=1
    fi
    checkDirContainName "$1" "clang"
    if [ $? == 1 ];then
        RET=1
    fi
    return $RET
}

function knl_build_env() {
    if [ "$1" == "init" ];then
	checkToolChainDir "${PWD}"
        if [ $? == 0 ];then
            echo "Can't find any toolchain dir in ${PWD}!"
            return
        fi
        if [ "${buildEnvIsInited}" == "true" ];then
            printBuildEnv
            return
        else
            buildEnvIsInited="true"
        fi

	export KBUILD_BUILD_USER="$(whoami)"

        toolChainDir="${PWD}"

        # Arm toolchain
        armToolChain="$(cd ${toolChainDir} && ls -d *-arm* 2> /dev/null)"
        if [ ! -z "${armToolChain}" ] && [ $(expr index "${armToolChain}" " ") == 0 ];then
            addon_path=${toolChainDir}/${armToolChain}/bin
            if [ "$(echo $PATH | grep $addon_path 2> /dev/null)" == "" ];then
                pathcat "${addon_path}"
            fi
        else
            armToolChain="not found"
        fi

        # Aarch64 toolchain
        aarch64ToolChain="$(cd ${toolChainDir} && ls -d *-aarch64* 2> /dev/null)"
        if [ ! -z "${aarch64ToolChain}" ] && [ $(expr index "${aarch64ToolChain}" " ") == 0 ];then
            addon_path=${toolChainDir}/${aarch64ToolChain}/bin
            if [ "$(echo $PATH | grep $addon_path 2> /dev/null)" == "" ];then
                pathcat "${addon_path}"
            fi
        else
            aarch64ToolChain="not found"
        fi

	printBuildEnv
    elif [ "$1" == "reset" ];then
        pathreset
        buildEnvIsInited="false"
        toolChainDir=""
        armToolChain=""
        aarch64ToolChain=""
	echo "PATH reset"
	echo "Toolchains reset"
    fi
}

T_ARCH=arm64
T_SUBARCH=arm64
T_CROSS_COMPILE=aarch64-linux-gnu-
T_CROSS_COMPILE_ARM32=arm-linux-gnueabi-
T_CC=clang
T_AR=llvm-ar
T_NM=llvm-nm
T_LD=ld.lld
T_OBJCOPY=llvm-objcopy
T_OBJDUMP=llvm-objdump
T_STRIP=llvm-strip

T_OUT=out
T_DEFCONFIG=vendor/violet-perf_defconfig

KNL_CONFIG=arch/${T_ARCH}/configs/${T_DEFCONFIG}

function knl_build_config() {
    ARCH=${T_ARCH} SUBARCH=${T_SUBARCH} make O=${T_OUT} ${T_DEFCONFIG}
}

function knl_build() {
    make O=${T_OUT} $@ \
         ARCH=${T_ARCH} \
         SUBARCH=${T_SUBARCH} \
         CROSS_COMPILE=${T_CROSS_COMPILE} \
         CROSS_COMPILE_ARM32=${T_CROSS_COMPILE_ARM32} \
         CC=${T_CC} \
         AR=${T_AR} \
         NM=${T_NM} \
         LD=${T_LD} \
         OBJCOPY=${T_OBJCOPY} \
         OBJDUMP=${T_OBJDUMP} \
         STRIP=${T_STRIP}
}
