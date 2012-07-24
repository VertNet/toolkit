BEGIN {
out_file = "LineIssues.txt"
x=0
FS=","
}
$1 !~ /PhysicalObject/ { x=x+1; print NR, $0 >out_file }
END { print x " issue lines" }

#!where $1 is the field basisOfRecord