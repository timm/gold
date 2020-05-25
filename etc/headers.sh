
t="GOLD: an object layer for GAWK"
b="https://img.shields.io/badge"
u='https://github.com/timm/gold'
r="$u/blob/master"
i='https://i2.wp.com/auk-ward.co.uk/wp-content/uploads/2017/02/auk-ward-icon.png?fit=472%2C472'
i="$r/etc/img/coins.png"

cat <<EOF>/tmp/head$$
<a name=top>
<p align=center><a
href="$r/doc/01tour.md#top">tour</a> :: <a
href="$r/doc/01core.md#top">core</a> :: <a
href="$r/doc/03testing.md#top">testing</a> :: <a
href="$u/doc/02doco.md#top">lit.prog</a> :: <a
href="$r/doc/05classes.md#top">classes</a> :: <a
href="$r/doc/06methods.md#top">methods</a> :: <a
href="$r/doc/06methods.md#top">packages</a> :: <a
href="$r/doc/07tips.md#top">tips</a> :: <a
href="$r/doc/08examples.md#top">exampples</a> <br>
<img src="$i"></p>
<h1 align=center><a href="$f/README.md#top">$t</a></h1>
<p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="$b/license-mit-red">   
<img src="$b/language-gawk-orange">    
<img src="$b/purpose-ai,se-blueviolet">
<img src="$b/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a> <br> <a
href="$r/LICENSE.md#top">license</a> :: <a
href="$r/INSTALL.md#top">install</a> :: <a
href="$r/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="$u/issues">issues</a> :: <a
href="$r/CITATION.md#top">cite</a> :: <a
href="$r/CONTACT.md#top">contact</a></p>
EOF

one() {
  if [ "$0" -nt "$1" ]; then
    >&2 echo "# $1 ..."
    cat $1 | gawk '
       BEGIN { RS = "^$"
               f  = "'/tmp/head$$'"
               getline top < f
               close(f)
               FS="\n"
               RS="" }
       NR==1 { print top 
               if($0 ~ /name=top>/) next  }
       1     { print ""; print $0 }
       ' > /tmp/$$new
    cp /tmp/$$new $1
   fi
}

while read x ; do
  one $x
done
