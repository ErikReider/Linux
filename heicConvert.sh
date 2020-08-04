#!/bin/bash
echo "Path: $1";
for f in $1/*.heic
do
echo "Working on file $f"
heif-convert $f $f.jpg
done
