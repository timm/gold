# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "scale"

function combo(i,j,k,x,   a,b) {
  Sym(i)
  Sym(j)
  split("ddddccccc", a, "")
  split("dddd", b, "")
  for(x in a) add(i, a[x])
  for(x in b) add(j, b[x])
  if( SymSeperate(i,j,k)) print 10 
  print(SymEnt(i), SymEnt(j), SymEnt(k))
}

### main
function main(f,    c,i,j,n,s,order,len) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i,order)
  len=length(i.rows)
  for(j in i.rows) { print i.rows[j].group  } # j } # i.rows[j].group }
}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

