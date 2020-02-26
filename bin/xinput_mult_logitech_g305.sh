#!/bin/bash

# Default of 2.4 seems to be adequate on Debian-based machines.
XIN_MULT=${XIN_MULT:-2.4}

xinput set-prop \
  $(xinput list \
      | grep "Logitech USB Receiver Mouse" \
      | grep -oP "id=([0-9]+)" \
      | grep -oP "[0-9]+") \
  "Coordinate Transformation Matrix" \
  $XIN_MULT 0 0 0 $XIN_MULT 0 0 0 1
