#!/bin/bash
if pgrep -x "wofi" > /dev/null
then
killall wofi
else
wofi --show drun -n
fi
