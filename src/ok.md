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
<a href="https://zenodo.org/badge/latestdoi/3841466"><img 
   src="https://zenodo.org/badge/3841466.svg" alt="DOI"></a>
</p><br clear=all>


# Unit test functions

```awk
@include "maths"

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) 
      print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/    ) 
      print "#W> Rogue: " s>"/dev/stderr"
}

function tests(what, all,   f,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { 
    f = a[i]; 
    @f(f) 
  }
  rogues()
}

function near(got,want,     epsilon) {
   epsilon = epsilon ? epsilon : 0.001
   return abs(want - got)/(want + 10^-32)  < epsilon
}

function ok(f,yes,    msg) {
  msg = yes ? "PASSED!" : "FAILED!"
  print "#TEST:\t" msg "\t" f
}
```
