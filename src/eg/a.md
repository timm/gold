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
