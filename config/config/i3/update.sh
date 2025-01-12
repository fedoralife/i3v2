#!/bin/bash

cmd=$(</home/codedemon/.config/i3/main.txt)
exec kitty -e bash -c "$cmd"


echo "UPDATE COMPLETE"

sleep 1000
