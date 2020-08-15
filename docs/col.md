# Col

```awk
@include "iterate"
@include "poly"

function Col(i,pos,txt) {
  Object(i)
  is(i,"Col") 
  i.n = 0 
}

#----------------------------------
function Num(i,pos,txt) {
  Col(i,pos,txt)
  is(i,"Num")
  i.w   = txt ~ /</ ? -1 : 1
  i.mu = i.m2 = 0
  i.hi = -10^32
  i.lo =  10^32
}
function NumAdd(i,x,   d) {
  if (x=="?") return x
  i.n++
  if (x<i.lo) i.lo = x
  if (x>i.hi) i.hi = x
  d = x - i.mu
  i.mu += d/i.n
  i.m2 += d*(x - i.mu)
  if (i.m2 <0) 
    i.sd = 0
  else 
    i.sd = i.n < 2 ? 0 : (i.m2/(i.n - 1))^0.5
}
function ok_num(   j,a,n) {
  Num(n)
  split("9 2 5 4 12 7 8 11 9 3 7 4 12 5 4 10 9 6 9 4",a)
  for(j in a) add(n, a[j])
  ok(n.n == 20)
  ok(n.mu == 7)
  ok( within(3.060, n.sd, 3.061))
}

#----------------------------------
function Sym(i,pos,txt) {
  Col(i,pos,txt)
  is(i,"Sym")
  has(i,"seen")
  i.mode = ""
  i.most = 0
}
function SymAdd(i,x,  new) {
  if (x=="?") return x
  i.n++
  new = ++i.seen[x]
  if (new > i.most) {
    i.most = new
    i.mode = x  }
}
function SymEnt(i,    e,j,p) {
  for(j in i.seen) {
   p = i.seen[j]/i.n
   if(p>0)
     e -= p*log(p)/log(2) }
  return e
}
function ok_sym(   a,j,s) {
  Sym(s)
  split("a b b c c c c",a)
  for(j in a) add(s, a[j])
  ok(s.mode == "c")
  ok(within(1.378, SymEnt(s),  1.379))
}

#----------------------------------
function Cols(i, a) {
  Object(i)
  is(i,"Cols")
  has(i,"all")
  has(i,"x")
  has(i,"header")
  has(i,"y")
  has(i,"nums")
  has(i,"syms")
  i.klass=""
  i.new=1
  if(length(a)) ColsAdd(i,a)
}
function ColsAdd(i,a,   txt,pos,nump,goalp) {
  i.new = 0
  for(pos in a) {
    txt   = a[pos]
    nump  = txt ~ /[\$<>]/ 
    goalp = txt ~ /[!<>]/
    i.header[pos] = txt
    i[ nump  ? "nums" : "syms" ][pos]
    i[ goalp ? "y"    : "x"    ][pos]
    havess(i.all, nump ? "Num" : "Sym", pos, txt)
    if (txt ~ /!/) 
      i.klass=pos 
}}
function ok_cols(i,a) {
  split("name $age <weight !class",a)
  Cols(i,a)
  oo(i)
}
function Rows(i,a) {
  Object(i)
  is(i,"Rows")
  has(i,"cols","Cols")
  has(i,"rows") 
  if(length(a))
    ColsAdd(i.cols, a)
}
function RowsRead(i,f,   a) {
  while (csv(a,f)) 
    RowsAdd(i,a)
}
function RowsAdd(i,a){
  i.cols.new ?  ColsAdd(i.cols, a) : havess(i.rows,"Row",a,i)
}
function Row(i,a,rows,    j) {
  Object(i)
  is(i,"Row")
  for(j in a)  
    add(rows.cols.all[j], i.cells[j] = a[j])
}

#----------------------------------
function Classes(i,  file) {
  Object(i) #s
  is(i,"Classes")
  has(i,"all")
  has(i,"some")
  i.file = file
  i.new = 1
  i.n = 0
}
function ClassesIt(i,    cols0,k,a) {
  if (! cols(cols0, i.file, a) )
    return 0
  if(i.new) {
     i.new = 0
     has(i,"all","Rows",a)
  } else {
    i.n++
    k = a[i.all.cols.klass] 
    if(! (k in i.some))
      has(i.some, k, "Rows", i.all.cols.header)
    add(i.all, a)
    add(i.some[k], a) }
  return 1
}
function main(file,   i) {
  Classes(i,file)
  while(it());
  oo(i)
}

BEGIN { oks() }
