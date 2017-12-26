#!/usr/bin/bash
  f=$1  
  # Change new line followed by "PhysicalObject or "Event or "Sound or "StillImage or "MovingImage to @&@"PhysicalObject or @&@"Event or @&@"Sound or @&@"StillImage or @&@"MovingImage, respectively. These should be the beginnings of records.
  # sed has memory limitations in some distributions. Use perl instead.
  #  sed -e ':a' -e 'N' -e '$!ba' -e 's/.\n\"PhysicalObject/@&@\"PhysicalObject/g' $f>$f.1
  perl -pe 's/.\n\"PhysicalObject/@&@\"PhysicalObject/g' $f>$f.1
  perl -pe 's/.\n\"Event/@&@\"Event/g' $f.1>$f.2
  rm $f.1
  perl -pe 's/.\n\"Sound/@&@\"Sound/g' $f.2>$f.3
  rm $f.2
  perl -pe 's/.\n\"StillImage/@&@\"StillImage/g' $f.3>$f.4
  rm $f.3
  perl -pe 's/.\n\"MovingImage/@&@\"MovingImage/g' $f.4>$f.5
  rm $f.4
  perl -pe 's/.\n\"Text/@&@\"Text/g' $f.5>$f.6
  rm $f.5
  # Change final new line to @&@ also.
  perl -p -e 's/\r\n$/@&@/ if eof' $f.6 > $f.7
  rm $f.6
  # Remove all remaining \r (carriage returns), \n (line feeds), \v (vertical tabs), \f (form feeds), \t (horizontal tabs)
  tr '\r\n\v\f\t' '.....' <$f.7 > $f.8
  rm $f.7
  # Change each @&@ to \r\n
  perl -p -e 's/@&@/\r\n/g' $f.8>$f
  rm $f.8