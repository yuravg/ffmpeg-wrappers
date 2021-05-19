#!/usr/bin/env bash

# Installation script

echo "Uninstall 'ffmpeg' wrapper scripts"
echo ""

SCRIPT_NAME=$(basename "${BASH_SOURCE##*/}")
help () {
    echo "Usage:"
    echo "  $SCRIPT_NAME [uninstall_path]"
    echo
    echo "ARGS:"
    echo "    <uninstall_path>"
    echo "            Uninstall path for scripts,"
    echo "            by default $PATH2INSTALL"
}

PATH2SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

PATH2INSTALL="${HOME}/bin"

help
echo

if [ "$1" != "" ]; then
    PATH2INSTALL="$1"
    if [ ! -d "$PATH2INSTALL" ]; then
        echo "ERROR! Can't find the directory: $PATH2INSTALL!"
        exit 1
    fi
fi

echo "Uninstall path: '$PATH2INSTALL':"
echo ""
echo "List of script to uninstall:"

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

if ! yes_no "Would you like run uninstall?"; then
    echo "Exit without uninstall!"
    exit 0
fi

for i in "$PATH2SCRIPT"/bin/*; do
    FNAME=$(basename ${i##*/})
    if [ -f "$i" ]; then
        rm -v "$PATH2INSTALL/$FNAME"
    else
        echo "Can't find file: $PATH2INSTALL/$FNAME"
    fi
done
