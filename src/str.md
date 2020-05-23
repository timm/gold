<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top">GOLD: the Gawk object layer</a></h1> 
<p align=left> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a> </p><p align=left> 
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img 
    src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a></p><br clear=all>


# String functions

## oo(lst,[prefix])

<img align=right src="../etc/img/binoculars.png" width=100>
The "binoculars" function.

Recursively prints a list, indenting at each new level.
If `prefix` is supplied, print that string first.
List contents are sorted either numerically or
alphanumerically, depending on the list's keys.

```awk
function oo(x,p,    pre,   i,txt) {
  txt = pre ? pre : (p AU.dot)
  ooSortOrder(x)
  for(i in x)  {
    if (isarray(x[i]))   {
      print(txt i"" )
      oo(x[i],"","|  " pre)
    } else
      print(txt i (x[i]==""?"": ": " x[i])) }
}
function ooSortOrder(x, i) {
  for (i in x)
   return PROCINFO["sorted_in"] =\
     typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}
```