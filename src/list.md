<a name=top><p align=center><img src="https://github.com/timm/gold/blob/master/etc/img/coins.png"></p>
<h1 align=center><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p align=center><a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p><p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a><br> <a
href="https://github.com/timm/gold/blob/master/doc/01tour.md#top">tour</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/02functions.md#top">functions</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/04methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/doc/06doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a></p><br clear=all>


# List Functions
  
```awk
function push(a,i) { a[length(a)+1] = i; return i } 
function any(a, i) { return a[1+int(rand()*length(a))]}
```
