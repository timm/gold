#!/usr/bin/env bash

gold2md()  { 
  a="</button>"
  b="<button class=\"button button1\">"
  c="<button class=\"button button2\">"
  cat <<-EOF
	---
	title: $1
	---

	$b<a href="/simpleai/index>home">home</a>$a
	$c<a href="/simpleai/INSTALL>install">install</a>$a
	$b<a href="/simpleai/ABOUT>doc">about</a>$a
	$c<a href="http://github.com/timm/gold/issues>discuss">discuss</a>$a
	$b<a href="/simpleai/LICENSE">license</a>$a
	EOF
  
  gawk '
 /^# vim:/ {next}
 /^#!/     {next}
  NR==1                    { print "\n# '$1'\n"; next }
  /^}/                     { print; print "```\n";  next }
  /^@include/              { print "```awk"; print; print "```"; next }
  /^(func|BEGIN|END).*}$/  { print "```awk"; print; print "```"; next }
  /^(func|BEGIN|END)/      { print "```awk"; print; next }
                           { print $0 } '
}

Docs=$HOME/opt/gold/docs
mkdir -p  $Docs

for f in $*; do
  Stem=$(basename $f ".gold")
  echo "$f ==> $Docs/$Stem.md"
  cat $f | gold2md $f > $Docs/$Stem.md
done
