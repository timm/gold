<a name=top>
<p align=center><a
href="https://github.com/timm/gold/blob/master/doc/01tour.md#top">tour</a> :: <a
href="https://github.com/timm/gold/doc/02doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/04functions.md#top">functions</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/06methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a> <br>
<img src="https://github.com/timm/gold/blob/master/etc/img/coins.png"></p>
<h1 align=center><a href="/README.md#top">GOLD: the GAWK object layer</a></h1>
<p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a> <br> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p>


# `Col` = Columns

`Col`s are superclasses for column headers

Columns have a default weight `w` 
of 1 (but  if their name includes 
`<`", then that weight is -1).

```awk
function Col(i,txt,pos) {
  Object(i)
  i.w   = txt ~ /</ ? -1 : 1
  i.txt = txt
  i.pos = pos
  i.n   = 0
}
```

Apart from "`<`" there are various other magic symbols
on columns names, For example, "`>`" means "maximize this
and "`?` " means "skip this data"
and "`!`" is a symbolic class and
and "`!<>`" denote classes or goals.

```awk
function ColSymbols(a) { 
  List(a)
  # category = pattern
  a["skip"]  = "\\?"
  a["num"]   = "[<>\\$]"
  a["goal"]  = "[<>!]"
  a["less"]  = "<"
}
```

Given a list of columns, we can extract the column indexes
of particular categories of patterns  using `of`.

```awk
function of(a,b,  cat,  i,cats) {
  ColSymbols(cats)
  for(i in a)
    if ( cats[cat] ~ a[i].txt ) b[i]
}
```
