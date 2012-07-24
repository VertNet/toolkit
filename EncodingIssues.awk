#!/usr/bin/awk -f
BEGIN {
out_file = "EncodingIssuesResults.txt"
x=0
FS=","
}
$0 ~ "\xEF" { x=x+1; print $0 >out_file }
END { print x " lines have a Unicode encoding problem (an exposed \xEF character)." }