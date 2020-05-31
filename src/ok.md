<a name=top>
<h1 align=center><a href="/README.md#top">GOLD: an object layer for GAWK</a></h1>
<p align=center>
<a
href="https://github.com/timm/gold/blob/master/doc/01tour.md#top">overview</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/01core.md#top">under.the.hood</a> :: <a
href="https://github.com/timm/gold/doc/02doco.md#top">lit.prog</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/06methods.md#top">packages</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a> 
<br>
<img src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<br>
<a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a>
</p><p align=center>
<a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a>
</p>

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
