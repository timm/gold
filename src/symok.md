<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p align=left> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a> </p><p align=left> 
<a href="https://doi.org/10.5281/zenodo.3841466"><img 
   src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a></p><br clear=all>


```awk
@include "ok"
@include "str"
@include "sym"
@include "poly"
@include "list"

BEGIN {  tests("symbol","_like,_sym") }

function _like(f,    s,a,m) {
  srand(1)
  split("abbccccdddddddd",a,"")
  Sym(s)
  m=1000
  while(m--) inc(s,any(a))
  ok(f, s.all.a < s.all.d)
}
```

Walk up a list of random symbols, adding to a `Sym`
counter. Then walk down, removing symbols. Check
that we get to the same entropy, both ways.

```awk
function _sym(f,     s,a,i,e,sym) {
  srand()
  s= "abbccccdddddddd"
  s= s s s s s
  s= s s s s s
  print(length(s))
  split(s,a,"")
  Sym(sym)
  for(i=1;i<=length(a);i += 1) { 
    inc(sym,a[i])
    if((i%10)==0)  
      e[i] = var(sym)  
  }
  for(i=length(a);i>=1; i-= 1) {
    if((i%10)==0)  
       ok(f i, near(var(sym), e[i])) 
    dec(sym,a[i]) 
  }
}
```
