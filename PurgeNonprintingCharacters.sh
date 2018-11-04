#!/usr/bin/bash
  f=$1  
  # Change new line followed by "PhysicalObject or "Event or "Sound or "StillImage or 
  # "MovingImage to qjq"PhysicalObject or qjq"Event or ||"Sound or qjq"StillImage or 
  # qjq"MovingImage, respectively. These should signify the beginnings of records.
  # Using sed the basic pattern would be:
  #   sed -e ':a' -e 'N' -e '$!ba' -e 's/.\n\"PhysicalObject/qjq\"PhysicalObject/g' $f>$f.1
  # But sed has memory limitations in some distributions. Use perl instead.
  perl -0777 -pe 's/[\s]+\"PhysicalObject/qjq\"PhysicalObject/g' $f>$f.1
  perl -0777 -pe 's/[\s]+\"Event/qjq\"Event/g' $f.1>$f.2
  rm $f.1
  perl -0777 -pe 's/[\s]+\"Sound/qjq\"Sound/g' $f.2>$f.3
  rm $f.2
  perl -0777 -pe 's/[\s]+\"StillImage/qjq\"StillImage/g' $f.3>$f.4
  rm $f.3
  perl -0777 -pe 's/[\s]+\"MovingImage/qjq\"MovingImage/g' $f.4>$f.5
  rm $f.4
  perl -0777 -pe 's/[\s]+\"Text/qjq\"Text/g' $f.5>$f.6
  rm $f.5
  # Change new line in the last line to qjq.
  perl -0777 -pe 's/[\s]$/qjq/g if eof' $f.6>$f.7
  rm $f.6
  # Substitute a space for each remaining \r (carriage return), \n (line feed), 
  # \v (vertical tab), \f (form feed), and \t (horizontal tab)
  tr '\r\n\v\f\t' '     ' <$f.7 > $f.8
  rm $f.7
  # Substitute every series of spaces followed by a double quote with just a double quote.
  perl -0777 -pe 's/[[:space:]]*\"/\"/g' $f.8>$f.9
  rm $f.8
  # Change each qjq to \r\n
  perl -0777 -pe 's/qjq/\r\n/g' $f.9>$f
  rm $f.9
