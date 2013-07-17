#!/usr/bin/bash
  f=$1
  # remove all remaining \v (vertical tabs), \f (form feeds)
  tr '\v\f' '..' <$f > $f.1
  rm $f
  mv $f.1 $f
  