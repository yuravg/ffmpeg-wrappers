#!/usr/bin/env bash

#
# Usage ffmpeg -- Audio and Video encoder
#  Usage:
#  1. <script_name> <source_file_name> <output_file_name> <parameter> <run_option>
#  2. <script_name> input.wmv output.mp4
#  3. <script_name> input.wmv output.mp4 '' 'y'
#  4. <script_name> input.wmv output.mp4 '-c:v mpeg4' 'y'
#
# Example usage ffmpeg:
# ffmpeg -i test.wmv -c:v mpeg4 out_cod.mp4
# ffmpeg -i fname.mp4 -vf scale=1280:-1 -c:a copy fname.mp4
# ffmpeg -i in.mp4 -ss [start] -t [duration] -c copy out.mp4
#   -ss specifies the start time, e.g. 00:01:23.000 or 83 (in seconds)
#
# Usage:
# https://superuser.com/questions/323119/how-can-i-normalize-audio-using-ffmpeg
# https://gist.github.com/kylophone/84ba07f6205895e65c9634a956bf6d54

# FIXME: usage with options y with command: for i in *.mp4 ; do util_ffmpeg.sh $i ../$i ; done
# FIXME: when output file name with prefix '../', example: ../<name>

help() {
    echo "Usage:"
    echo " <script_name> <source_file_name> <output_file_name> <ffmpeg_options> <sript_option>"
    echo "Example:"
    echo " <script_name> input.wmv output.mp4"
    echo " <script_name> input.wmv output.mp4 '' 'y'"
    echo ""
    echo " TIPS(ffmpeg options):"
    echo "  'norm' - normalize mp3: "
    echo "  'v1280' - normalize to 1280x720"
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

options=""
if [ "$#" -gt 2 ]; then
    options=${*:3}
fi
if [ "$3" == "norm" ]; then
    options="-filter:a loudnorm"
fi
if [ "$3" == "v1280" ]; then
    options="-vf scale=1280:720 -c:a copy"
fi

echo "+---------------------------------------------------------------+"
echo "| Run ffmpeg encoding                                           |"
echo "+---------------------------------------------------------------+"
echo "| Local directory is:                                           |"
echo "| $(pwd)"
echo "| Report file: $rpt_fname"
echo "+---------------------------------------------------------------+"
echo "|"
echo "| Input file  : '$1'"
echo "| Output file : '$2'"
echo "| Options     : '$options'"
echo "|"
echo "| Command:"
echo "| ffmpeg -i $1 $options $2"
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

echo "Run:"
if [ "$#" -gt 2 ]; then
    echo " ffmpeg -i $1 $options $2"
    echo ""
    ffmpeg -hide_banner -i "$1" $options "$2"
else
    echo " ffmpeg -i $1 $2"
    echo ""
    ffmpeg -hide_banner -i "$1" "$2"
fi

echo "+---------------------------------------------------------------+"
echo "| Converting done.                                              |"
echo "+---------------------------------------------------------------+"

# TIPS:
# 1. For conver files by mask:
#    $ for i in *.mp4 ; do util_ffmpeg.sh $i ${i%.*}.mkv ; done
