#!/usr/bin/bash
  f=$1  
  # Change new line followed by "PhysicalObject or "Event or "Sound or "StillImage or 
  # "MovingImage to ??"PhysicalObject or ��"Event or ��"Sound or ��"StillImage or 
  # ��"MovingImage, respectively. These should signify the beginnings of records.
  # Using sed the basic pattern would be:
  #   sed -e ':a' -e 'N' -e '$!ba' -e 's/.\n\"PhysicalObject/��\"PhysicalObject/g' $f>$f.1
  # But sed has memory limitations in some distributions. Use perl instead.
  perl -0777 -pe 's/[\s]+\"PhysicalObject/��\"PhysicalObject/g' $f>$f.1
  perl -0777 -pe 's/[\s]+\"Event/��\"Event/g' $f.1>$f.2
  rm $f.1
  perl -0777 -pe 's/[\s]+\"Sound/��\"Sound/g' $f.2>$f.3
  rm $f.2
  perl -0777 -pe 's/[\s]+\"StillImage/��\"StillImage/g' $f.3>$f.4
  rm $f.3
  perl -0777 -pe 's/[\s]+\"MovingImage/��\"MovingImage/g' $f.4>$f.5
  rm $f.4
  perl -0777 -pe 's/[\s]+\"Text/��\"Text/g' $f.5>$f.6
  rm $f.5
  # Change new line in the last line to ��.
  #   perl -0777 -pe 's/[\s]$/��/g if eof' $f.6>$f.7
  # Substitute a space for each remaining \r (carriage return), \n (line feed), 
  # \v (vertical tab), \f (form feed), and \t (horizontal tab)
  tr '\r\n\v\f\t' '     ' <$f.6 > $f.7
  rm $f.6
#  perl -0777 -pe 's/[[:space:]]*\"/\"/g' $f.7>$f.8
#  rm $f.7
  # Change each �� to \r\n
  perl -0777 -pe 's/��/\r\n/g' $f.7>$f.8
  rm $f.7
  perl -0777 -pe 's/[[:space:]]*$// if eof' $f.8>$f
  rm $f.8