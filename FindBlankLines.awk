#!/usr/bin/awk -f
BEGIN {
x=0
FS=","
}
$0 ~ /^$/{x=x+1; print NR, $0}
END { print x " blank lines" }