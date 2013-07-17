#!/usr/bin/awk -f
BEGIN {
x=0
FS=","
}
#! $1 is the supposed to be the type field.
$1 !~ /PhysicalObject|type|Event|Sound|StillImage|MovingImage/ { x=x+1; print NR, $0 }
END { print x " lines have a new line in the content" }

