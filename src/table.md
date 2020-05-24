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
href="https://github.com/timm/gold/doc/02doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/04functions.md#top">functions</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/06methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a></p><br clear=all>


# `Table` = Tables of Data

Tables have `Row`s and columns (which can be `Num`eric or `Sym`bolic).
```awk
@include "num"
@include "sym"
@include "row"
```
`Row`s store example data
and columns store summaries on a vertical slice of that data.

```awk
function Table(i, headers,rows,c,r) {
  Object(i)
  i.is = "Table"
  has(i, "cols")
  has(i, "rows")
  has(i, "headers")
  has(i, "class")
  # if headers or rows are empty, these 2 lines do nothing
  for(c in headers) TableHeader(i, headers[c],c)
  for(r in rows)    TableRow(i, rows[r] )
}
```

Updating tables means updating the `Row`s and columns. The first how
is the `headers` list which is a list of names from the columns.

```awk
function TableInc(i,row,      c) {
  if (row.is == "Row") # for rows, use on cell values
    return TableAdd(i, row.cells)
  if (length(i.cols))   # if we have the header row
    TableRow(i,row)     # then add a data row
  else                  # else
    for(c in row)       # add the header row
      TableHeader(i, row[c], c) 
}
```
`TableIncs`
keeps  separate statistics for each
class of row within the data (as well as updating
stats on all the data). 

```awk
function TableIncs(i,row,     k) {
  if (row.is == "Row") # for rows, use on cell values
    return TableIncs(i, row.cells)
  if (length(i.cols))     # we are reading data
  {
    k = row[i.theClass]  # then update the "k" class
    if ( ! (k in i.class) )
      has(i.class,k,"Table",i.headers)
    TableInc(i.class[k],row) 
  } 
  TableInc(i,row) # update statistics on all the data
}
```

Low-level workers. Just update the header of a single column,
or a single row.

```awk
function TableHeader(i,txt,pos) {
  i.headers[pos] = txt
  if (txt ~ AU.ch.klass) i.theClass=pos
  hass(i.cols,
       "",
       txt ~ AU.ch.numeric ? "Num" : "Sym",
       txt, 
       pos)
}
function TableRow(i,row,  r,c) {
  r = has(i.rows,"","Row")
  for(c in i.cols.all)  
    i.rows[r].cells[c] = add(i.cols.all[c], row[c]) 
}
```
Note one trick in `TableRow`:
we update `cells[c]` with whatever is
returned after `add`ing the value to the column header. 
With this approach,
column headers can not only summarize they data, they can also
be used to pre-process data to
(e.g.) coercing strings to numbers
(in `Num` columns).
