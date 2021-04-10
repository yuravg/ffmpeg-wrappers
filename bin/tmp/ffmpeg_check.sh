#!/usr/bin/env bash

#
# Usage ffmpeg -- to checking integrity Audio and Video content
#  Usage:
#    <script_name> <source_file_name> <output_log_file> <run_option>
#  Examle:
#   1. <script_name> <source_file_name>
#   2. <script_name> <source_file_name> '' y
#
# link: http://superuser.com/questions/100288/how-can-i-check-the-integrity-of-a-video-file-avi-mpeg-mp4
#

if [ ! -s "$1" ]; then
    echo "ERROR! Can't find file: '$1'"
    exit 1
fi

if [ ! -n "$2" ]; then
    flog=!error_"$1".$$.log
else
    flog="$2"
fi

echo "+---------------------------------------------------------------+"
echo "| Run ffmpeg checking                                           |"
echo "+---------------------------------------------------------------+"
echo "| Example usage: <scrip_name> <media_file> '' y                 |"
echo "+---------------------------------------------------------------+"
echo "| Local directory is:                                           |"
echo "| $(pwd)"
echo "+---------------------------------------------------------------+"
echo "|"
echo "| Input file  : '$1'"
echo "| Report file : $flog"
echo "|"
echo "| Run:"
echo "| ffmpeg -v error -i $1 -f null - 2>$flog"
echo "|"
echo "+---------------------------------------------------------------+"
echo "|"

. ~/bin/fun_yesno

case "$3" in
    y|Y|yes|Yes|YES)
        ;;
    *)
        if ! fun_yesno "| Run checking" ; then
            echo "Exit without checking!"
            exit 0
        fi
        ;;
esac

echo "Running:"
echo ""
buf=$HOME/tmp/$$ffmpeg_log.log

ffmpeg -v error -i "$1" -f null - 2>"$buf"

echo ""
if [ -s "$buf" ]; then
    echo "Log for file: $1 \n" > "$flog"
    cat "$buf" >> "$flog"
    echo "* ERROR detected!"
else
    echo "| Successful!"
fi

echo ""
echo "+---------------------------------------------------------------+"
echo "| Checking done.                                                |"
echo "+---------------------------------------------------------------+"
