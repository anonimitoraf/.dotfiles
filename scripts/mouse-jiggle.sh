#!/bin/bash
LENGTH=1
DELAY=5

while true
do
  for ANGLE in 0 90 180 270
  do
    xdotool mousemove_relative --polar $ANGLE $LENGTH
    echo "Jiggle! (then sleeping for ${DELAY} secs)"
    sleep $DELAY
  done
done
