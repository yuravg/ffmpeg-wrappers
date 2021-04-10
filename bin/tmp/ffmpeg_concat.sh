#!/usr/bin/env bash

#
# Usage ffmpeg -- Audio and Video encoder to concatenation files
#  Usage:
#   <script_name> <source_file_list> <output_file_name>
#
# example usage ffmpeg:
# ffmpeg -f concat -safe 0 -i mylist.txt -c copy output
# ffmpeg -f concat -i mylist.txt -c copy output -- to relative path
# where mylist.txt:
#   # this is a comment
#   file '/path/to/file1'
#   file '/path/to/file2'
#   file '/path/to/file3'

help() {
    echo "Usage:"
    echo " <script_name> <source_file_list> <output_file_name>"
    echo "Example:"
    echo " <script_name> list.txt output.mp4"
    echo "  list.txt:"
    echo "   file '/path/to/file1'"
    echo "   file '/path/to/file2'"
    echo "   file 'file3 -- relative'"
}

if [ ! -s "$1" ]; then
    echo "ERROR! Can't find file: '$1'"
    help
    exit 1
fi

if [ ! -n "$2" ]; then
    echo "ERROR! You mast set out file name!"
    help
    exit 2
fi

# for enable report: key -report
# https://trac.ffmpeg.org/ticket/1823
rpt_fname="$HOME"/tmp/ffmpeg-$2.log
# rpt_fname="$HOME"/tmp/ffmpeg-$(date +%Y-%m-%d--%H-%M-%S).log
export FFREPORT=file="$rpt_fname"

echo "+---------------------------------------------------------------+"
echo "| Run ffmpeg encoding                                           |"
echo "+---------------------------------------------------------------+"
echo "| Local directory is:                                           |"
echo "| $(pwd)"
echo "| Report file: $rpt_fname"
echo "+---------------------------------------------------------------+"
echo "|"
echo "| Source file : '$1'"
echo "| Output file : '$2'"
echo "|"
echo "| Run:"
echo "| ffmpeg -f concat -safe 0 -i $1 -c copy $2"
echo "|"
echo "+---------------------------------------------------------------+"
echo "|"

. ~/bin/fun_yesno

case "$4" in
    y|Y|yes|Yes|YES)
        ;;
    *)
        if ! fun_yesno "| Run converting" ; then
            echo "Exit without converting!"
            exit 0
        fi
        ;;
esac

echo "Running:"
echo ""
ffmpeg -f concat -safe 0 -i "$1" -c copy "$2"
echo "+---------------------------------------------------------------+"
echo "| Converting done.                                              |"
echo "+---------------------------------------------------------------+"
