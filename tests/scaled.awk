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
function doming(f, i,n,rows,j) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i)
  n=keysorT(i.rows,rows,"y")
  for(j=1;j<=10;j++) print RowShow(rows[j],i)
  print ""
  for(j=n-10;j<=n;j++) print RowShow(rows[j],i)
}
function ranging(f,    c,i,j,n,s,order,out,len) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i,order)
  #SomeBins(i.cols[4])
  #print(9)
  Nb(n,i.cols, i.rows)
  #oo(i.cols[4])
  NbPlans(n, out)
  oo(out)
}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        ranging("auto93")
        rogues()  }

