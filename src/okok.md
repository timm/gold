<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top"></a></h1> 
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
<a href="https://doi.org/10.5281/zenodo.3841466"><img 
   src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
</p><br clear=all>


</p><br clear=all>

</p><br clear=all>

# Testing the test engine

```awk
@include "ok"

BEGIN {  tests("okok","_ok") }

function _ok(f,  m,n) {
  ok(f, 1==2)
}
```
