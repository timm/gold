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


# `Col` = Columns

`Col`s are superclasses for column headers

Columns have a default weight `w` 
of 1 (but  if their name includes 
`<`", then that weight is -1).

```awk
func Col(i,txt,pos) {
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
func ColSymbols(a) { 
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
func of(a,b,  cat,  cats) {
  ColSymbols(cats)
  for(i in a)
    if ( cats[cat] ~ a[i].txt ) b[i]
}
```
