#!/bin/sh

for f in source/*
do
  ln -nsf "`pwd`"/"$f" "$HOME"/."`basename "$f"`"
done

