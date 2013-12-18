#!/usr/bin/bash
  f=$1
  # Remove all empty lines from the file.
  # sed '/^$/d' $f1>$f1.stripped
  sed -e ':a' -e 'N' -e '$!ba' -e '/^$/d' $f1>$f1.stripped