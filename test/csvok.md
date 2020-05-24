<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p><a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p><p><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a><hr> <a
href="https://github.com/timm/gold/blob/master/doc/11classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/12methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/13testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/doc/14doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/15tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/16examples.md#top">egs</a></p><br clear=all>


```awk
@include "csv"
@include "str"

function main(  n,raw,f,s) {
  raw= AU.up  "/test/data/raw/" 
  f  = raw "weather" AU.dot "csv"
  while(csv(a,f))  {
    if(! n++) {oo(a) } else {print(length(a))}
  }
}
BEGIN { main() }
```
