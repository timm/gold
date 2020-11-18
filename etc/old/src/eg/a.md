<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

```awk
function has0(i,k)         { i[k]["\t"]; delete i[k]["\t"]   }
function has( i,k,f)       { has0(i,k);  if(f) @f(i[k])      }
function haS( i,k,f,x1)    { has0(i,k);  if(f) @f(i[k],x1)   }
function hAS( i,k,f,x1,x2) { has0(i,k);  if(f) @f(i[k],x1,x2)}

function Rows(i, a) {
  has(i,"cols")
  has(i,"rows")
  for(j in a) hAS(i.cols,j,"Num",j,a[j]) 
}
function Col(i,pos,txt) {
  i.pos = pos
  i.txt = txt
  i.n   = 0
}
function Num(i,pos,txt) { Col(i,pos,txt) }
function demo(   a,i,j) { 
  a[1]="jane"
  a[2]="john"
  Num(j,23,"apple")
  print(j.n,j.txt)
  Rows(i,a)
  i.rows[1]=1
  i.rows[2]=2
  print(length(i.rows)) 
}
BEGIN { demo() }
```
