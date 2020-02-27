#!/bin/bash

pkgs=(.)
for pkg in "${pkgs[@]}" ; do

  files=$(find . -name Dockerfile)

  for file in "${files[@]}"; do
    # echo "$file\n"
    dir=$(echo "${file}" | sed 's/\/Dockerfile$//g' | sed 's/^.\///g')
    # echo $dir
    #dirs=$(echo $dir | sed 's|(./)||g')
    path=$(echo $dir | sed 's|/|-|g')
    echo $path
  done
done
