[home](http://github.com/timm/gold/README.md) :: <img align=right width=300 src="http://github.com/timm/gold//blob/master/etc/img/gold.png">
[lib1] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer

[home](http://github.com/timm/gold/README.me) ::
[lib] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer
----- 

# Col

```awk
@include "iterate"
@include "poly"
```

```awk
function Col(i,pos,txt) {
  Object(i)
  is(i,"Col") 
  i.n = 0 
}
```

```awk
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
function NumLike (i, x, _y,_z, z,v,nom,denom) {
    if (x < i.mu - 4*i.sd) return 0
    if (x > i.mu + 4*i.sd) return 0
    z = 10^-64
    v = i.sd^2 
    nom = 2.7181^(-1*(x-i.mu)^2/(2*v+z)) 
    denom = (2*3.141*v)^.5 
    return nom/(denom + z)
}
function ok_num(   j,a,n) {
  Num(n)
  split("9 2 5 4 12 7 8 11 9 3 7 4 12 5 4 10 9 6 9 4",a)
  for(j in a) add(n, a[j])
  ok(n.n == 20)
  ok(n.mu == 7)
  ok( within(3.060, n.sd, 3.061))
}
```

```awk
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
function SymLike(i,x,prior,m,  n) {
  n = (x in i.seen ? i.seen[x] : 0) 
  return (n + m*prior)/(i.n + m)
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
```

```awk
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
  ok(i.klass == 4)
  ok(2 in i.nums)
  ok(1 in i.syms)
  ok(i.header[3] == "<weight")
}
```

```awk
function Rows(i) {
  Object(i)
  is(i,"Rows")
  has(i,"cols","Cols")
  has(i,"rows") 
}
function RowsRead(i,f,   it) {
  Use(it,f)
  while (loop(it)) 
    RowsAdd(i,it.has)
}
function RowsLike(i,row,m,n,k,nh,val,inc,
                    prior,out,col) {
  prior = (len(i.rows) + k) / (n + k*nh)
  out = log(prior)
  for(col in i.cols.x) {
    val = row[i.cols.all[col].pos]
    if (val != "?") {
      inc = like(i.cols.all[col],val, prior, m)
      out += log(inc)
  }}
  return out
}
function RowsAdd(i,a){
  if (i.cols.new)
    ColsAdd(i.cols, a) 
  else
    havess(i.rows,"Row",a,i)
}
function data(f,   d) {
  d=GOLD.dot
  return d d "/data/" f d "csv"
}
function ok_use(   n,f, it) {
  Use(it,data("weather"))
  while (loop(it)) {
    if(!n) n = length(it.has)
    ok(n == length(it.has))
  }
}

function ok_rows(i) {
  Rows(i)
  RowsRead(i, data("weather") )
  print("i",length(i.rows))
  ok(14 == length(i.rows))
  ok( 9 == i.cols.all[i.cols.klass].seen["yes"])
}
```

```awk
function Row(i,a,rows,    j) {
  Object(i)
  is(i,"Row")
  for(j in a)  
    add(rows.cols.all[j], i.cells[j] = a[j])
}
```

```awk
function Classes(i,  file) {
  Object(i) 
  is(i,"Classes")
  has(i,"every")
  has(i,"some")
  i.file = file
  i.n = 0
  i.m=2
  i.k=1
  hass(i,"use","Use",file)
}
function ClassesGuess(i,row,    all,most,y,ybest,tmp) {
  List(all)
  most = -10**32
  for(y in i.some) {
    tmp = RowsLike(i.some[y], row, i.n, i.m, i.k, len(i.some))
    all[y] = tmp
    if (tmp > most) {
      ybest = y
      most =tmp
  }}
  return ybest
}
function ClassesLoop(i,    cols0,k,a) {
  if (! loop(i.use))
    return 0
  if (!length(i.every)) {
     has(i,"every","Rows")
     add(i.every, i.use.has)
  } else {
    i.n++
    k = i.use.has[i.every.cols.klass] 
    if(! (k in i.some)) {
      has(i.some, k, "Rows")
      add(i.some[k], i.every.cols.header)
    }
    add(i.every, i.use.has)
    add(i.some[k], i.use.has) 
  }
  return 1
}

function ok_classes(   c) {
  Classes(c, data("weather"))
  while( loop(c) ) ;
  ok( 2 == length(c.some) )
  ok( 5 == length(c.some["no"].rows) )
  ok( 9 == length(c.some["yes"].rows) )
  ok(14 == length(c.every.rows) )
}
```

```awk
function Abcd(i) {
  Object(i)
  is(i,"Abcd")
  has(i,"known")
  has(i,"a")
  has(i,"b")
  has(i,"c")
  has(i,"d")
  i.yes = i.no = 0
}
function AbcdAdd(i,want, got,   x) {
  if (++i.known[want] == 1) i.a[want]= i.yes + i.no 
  if (++i.known[got]  == 1) i.a[got] = i.yes + i.no 
  want == got ? i.yes++ : i.no++ 
  for (x in i.known) 
    if (want == x) 
      want == got ? i.d[x]++ : i.b[x]++
    else 
      got == x    ? i.c[x]++ : i.a[x]++
}
function AbcdReport(i,   
                    x,p,q,r,s,ds,pd,pf,
                    pn,prec,g,f,acc,a,b,c,d) {
  p = " %4.2f"
  q = " %4s"
  r = " %5s"
  s = " |"
  ds= "----"
  printf(r s r s r s r s r s q s q s q s q s q s q s " class\n",
        "num","a","b","c","d","acc","pre","pd","pf","f","g")
  printf(r s r s r s r s r s q s q s q s q s q s q s "-----\n",
         "----",ds,ds,ds,ds,ds,ds,ds,ds,ds,ds)
  for (x in i.known) {
    pd = pf = pn = prec = g = f = acc = 0
    a = i.a[x]
    b = i.b[x]
    c = i.c[x]
    d = i.d[x]
    if (b+d > 0     ) pd   = d     / (b+d) 
    if (a+c > 0     ) pf   = c     / (a+c) 
    if (a+c > 0     ) pn   = (b+d) / (a+c) 
    if (c+d > 0     ) prec = d     / (c+d) 
    if (1-pf+pd > 0 ) g=2*(1-pf) * pd / (1-pf+pd) 
    if (prec+pd > 0 ) f=2*prec*pd / (prec + pd)   
    if (i.yes + i.no > 0 ) 
       acc  = i.yes / (i.yes + i.no) 
    printf( r s        r s r s r s r s p s p s  p s p s p s p s  " %s\n",
          i.yes+i.no,a,  b,  c,  d,  acc,prec,pd, pf, f,  g,  x) }
}

function ok_abcd(   a,y,m,n,j) {
  Abcd(a)
  y="yes"
  m="maybe"
  n="no"
  for(j=1;j<=6;j++) AbcdAdd(a,y,y)
  for(j=1;j<=2;j++) AbcdAdd(a,n,n)
  for(j=1;j<=2;j++) AbcdAdd(a,m,m)
  AbcdAdd(a,m,n)
  AbcdReport(a)
  oo(a)
}
```

```awk
function main(file,   i) {
  Classes(i,file)
  while(it());
}

BEGIN { oks() }
```
