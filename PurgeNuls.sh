#!/usr/bin/bash
  f=$1
  # remove all remaining \0 (nulls)
  tr -d '\0' <$f > $f.1
  rm $f
  mv $f.1 $f
  