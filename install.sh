#!/usr/bin/env bash

# Installation script

echo "Installing 'ffmpeg' wrapper scripts"
echo ""

SCRIPT_NAME=$(basename "${BASH_SOURCE##*/}")

PATH2SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

PATH2INSTALL="/home/$(whoami)/bin"

help () {
    echo "Usage:"
    echo "  $SCRIPT_NAME [path2install]"
    echo
    echo "ARGS:"
    echo "    <path2install>"
    echo "            Installation path for scripts,"
    echo "            by default $PATH2INSTALL"
}

help
echo

if [ "$1" != "" ]; then
    PATH2INSTALL="$1"
    if [ ! -d "$PATH2INSTALL" ]; then
        echo "ERROR! Can't find the directory: $PATH2INSTALL!"
        exit 1
    fi
fi

echo "Installation path: '$PATH2INSTALL':"
echo ""
echo "List of script to install:"

for i in "$PATH2SCRIPT"/bin/*; do
    echo " $i"
done
echo ""

yes_no () {
    while :
    do
        echo "$* (y/n)?"
        read -r yn
        case $yn in
            y|Y|yes|Yes|YES)
                return 0
                ;;
            n|N|no|No|NO)
                return 1
                ;;
            *)
                echo Please answer Yes or No.
                ;;
        esac
    done
}

if ! yes_no "Would you like run the installation?"; then
    echo "Exit without installatioin!"
    exit 0
fi

for i in "$PATH2SCRIPT"/bin/*; do
    FNAME=$(basename ${i##*/})
    if [ -f "$i" ]; then
        cp -v "$i" "$PATH2INSTALL/$FNAME"
    fi
done
