# vim: filetype=awk ts=2 sw=2 sts=2  et :

#<
SCALE: StoChAstic LandscapE analysis
(c) 2020 MIT License, Tim Menzies timm@ieee.org
Optimization via discretization and contrast sets.

def. scale (v):
-   To climb up or reach by means of a ladder;
-   To attack with or take by means of scaling ladders;
-   To reach the highest point of (see also SURMOUNT)

                              Hooray!   .
                                 -. _ O /
                                     _ '
                                    / \
                                    ())
         _ _      _..--.. .-' _-.     .-d-b-.
     --'   _ _.-'        _ _.. _.  _  .'        _.   _.
        .-'                  a:f          ,-'
#>

BEGIN {   
  Gold.scale.Tab.samples = 64
  Gold.scale.Some.div.min = 0.5
  Gold.scale.Some.div.epsilon = 0.35
}

### shortcuts
function xx(i,z,  f) { f=does(i,"X"); return @f(i,z) }
function yy(i,    f) { f=does(i,"Y"); return @f(i) }
function card(i,    f) { f=does(i,"Card"); return @f(i) }
function add(i,x,  f) { f=does(i,"Add"); return @f(i,x) }
function discretize(i,x,  f) { f=does(i,"Discretize"); return @f(i,x) }

### columns
## generic column
function Col(i,pos,txt) {
  Obj(i)
  is(i, "Col")
  i.pos=pos
  i.txt=txt
  i.n  =0
  i.w  =txt ~ /</ ? -1 : 1 }

## columns whose data we will ignore
function Skip(i,pos,txt) { Col(i,pos,txt); is(i,"Skip") }
function _Add(i,x)       { return x }
function _Card(i) { return 0 }

## columns of symbols which we will summaries
function Sym(i,pos,txt) {
  Col(i, pos,txt)
  is(i,  "Sym")
  has(i,"seen")
  has(i,"bins")
  i.mode=i.most="" }

function _Card(i) { return length(i.seen) }
function _Add(i,x,    d,n) {
  if (x!="?") {
    i.n++
    n = ++i.seen[x]
    if(n>i.most) { i.most=n; i.mode=x} }
  return x }

function _Discretize(i,x) { if(x!="?") return x }

function _Ent(i,      p,e,x) {
  for(x in i.seen) 
    if((p=i.seen[x] / i.n)>0)
      e -= p*log(p)/log(2);
  return e }

function _Seperate(i,j,k,       ei,ej,both,parts) {
  _Combine(i,j,k) 
  ei = _Ent(i)
  ej = _Ent(j)
  both = _Ent(k)
  parts = (ei*i.n + ej*j.n)/k.n 
  return  abs(both - parts)/both > 0.05 }

##columns of numbers, from which we will keep a sample
function Some(i,pos,txt) {
  Col(i,pos,txt)
  is(i,"Some")
  i.ok= 1
  i.want=128 # number of samples
  i.lo =  1E30
  i.hi = -1E30
  has(i,"bins")
  has(i,"all") }

function _Card(i) { return 1+length(i.bins) }

function _Add(i,x,    len,pos) {
  if (x != "?") {
    i.n++
    len=length(i.all)
    if  (i.n < i.want)   
       pos=len + 1 
    else 
       if (rand() < i.want/i.n) 
         pos=int(len*rand()) ;
    if (pos) {
      if (x < i.lo) i.lo = x
      if (x > i.hi) i.hi = x
      i.ok=0
      i.all[pos]=x }}
  return x }

function _Ok(i) { i.ok = i.ok ? i.ok : asort(i.all) }

function _Mid(i,lo,hi) { return  _Per(i,.5,lo,hi) }

function _Sd(i,lo,hi) {
  return (  _Per(i,.9,lo,hi) -  _Per(i,.1,lo,hi))/2.54 }

function _Per(i,p,lo,hi) { 
   _Ok(i)
  lo = lo?lo:1
  hi = hi?hi:length(i.all)
  return i.all[ int(lo + p*(hi-lo)) ] }

function _Norm(i,x,   n) {
  if (x=="?") return x
  x= (x-i.lo) / (i.hi - i.lo +1E-32)
  return x<0 ? 0 : (x>1 ? 1 : x) }

function _Discretize(i,x,     j) {
  if (x!="?") {
    _Bins(i)
    for(j=1; j<=length(i.bins); j++) 
      if( x<=i.bins[j] ) {x=j; break}
    x=j }
  return x}
     
function _Bins(i,     eps,min,b,n,lo,hi,b4,len,merge) {
  if (!length(i.bins)) {
     _Ok(i)
    eps = Gold.scale.Some.div.epsilon
    min = Gold.scale.Some.div.min
    eps = _Sd(i)*eps
    len = length(i.all)
    n   = len^min
    while(n < 4 && n < len/2) n *= 1.2
    n   = int(n)
    lo  = 1
    b   = b4 = 0
    for(hi=n; hi <= len-n; hi++) {
      if (hi - lo > n) 
        if (i.all[hi] != i.all[hi+1])  
          if ((i.all[hi] - i.all[lo]) >= eps)  
            if (b4==0 || (   _Mid(i,lo,hi) - b4) >= eps) {
              i.bins[++b]   = i.all[hi]
              b4  = _Mid(i,lo,hi)
              lo  = hi
              hi += n }}}}

  
### rows of data
function Row(i,a,t,     j) {
  Obj(i)
  is(i, "Row")
  i.dom = 0
  has(i,"cells") 
  for(j in a) i.cells[j] = add(t.cols[j], a[j]) }

function _X(i,j) {return i.cells[j] }
function _Y(i)   {return i.y}

function _Dom(i,j,t,   
              n,e,c,w,x,y,sum1,sum2) {
  n = length(t.ys)
  for(c in t.ys) {
    w     = t.cols[c].w
    x     = SomeNorm(t.cols[c], i.cells[c])
    y     = SomeNorm(t.cols[c], j.cells[c])
    sum1 -= 2.71828 ^ ( w * (x - y)/n )
    sum2 -= 2.71828 ^ ( w * (y - x)/n )
  }
 return sum1/n < sum2/n }

function _Show(i,tab,   c,s,sep) { 
  for(c in tab.ys) {
   s= s sep tab.cols[c].txt"=" _X(i,c) 
   sep =", "}
  return s }


### tables store rows, summarized in columns
function Tab(i) {
  Obj(i)
  is(i,"Tab")
  has(i,"xs")
  has(i,"ys")
  has(i,"rows")
  has(i,"cols") }

function _What(i,pos,txt,  x,where) {
  x="Sym"
  if (txt ~ /[<>:]/) x="Some"
  if (txt ~ /\?/)    x="Skip"
  if (x != "Skip") {
    where =  txt ~ /[<>!]/ ? "ys" : "xs"
    i[where][pos] }
  return x }
 
function _Add(i,a,    j) {
  if (length(i.cols)>1) 
    hAS(i.rows, int(1E9 * rand()) ,"Row",a,i)
  else 
    for(j in a)
      hAS(i.cols, j,  _What(i,j,a[j]), j, a[j]) }

function _Dom(i,  n,j,k,s) {
  Some(s)
  for(j in i.rows) {
    n= Gold.scale.Tab.samples
    for(k in i.rows) {
       if(--n<0) break
      if(i.rows[j].id > i.rows[k].id) 
        i.rows[j].dom += RowDom(i.rows[j], i.rows[k],i)}
    add(s,i.rows[j].dom) }
   for(j in i.rows)
      i.rows[j].y = SomeDiscretize(s, i.rows[j].dom)  
   return length(s.bins)+1 }

function _Read(i,f,  a) {  while(csv(a,f)) add(i,a) }  

function Nb(i,use, cols,rows,     r) {
  has(i,"f")  # counts of symbols in each column for each class
  has(i,"h")  # frequency counts for each class
  has(i,"at") # reverse index, column, symbol to row
  i.k=1
  i.m=2
  i.n = 0
  i.population = 20
  i.generations= 20
  i.samples    = 50 
  i.best = -1
  has(i,"ranges")
  for(r in rows) _Adds(i,use,rows[r],cols) }

function _Adds(i,use, row,cols,    r,h,c,x) {
  i.n++
  h = RowY(row)
  i.h[h]++
  i.best = max(i.best,h)
  for(c in use) 
    if(x= discretize(cols[c], RowX(row,c))) 
     if (x != "?") {
       i.at[h][c][x][row.id]
       i.f[h][c][x]++ }}


function _Like(i,  # :Nb asdas
               a,  # :list of  asda
                   #  _asdasas asdas
               h,  # :str asdasd
               n,  # :num asdas
               nh, # :num asdas
               like,prior,inc,c,x,f) {
  like = prior = (i.h[h] + i.k) / (n + i.k*nh)
  like = log(like)
  for(c in a) {
    f = 0
    for(x in a[c]) f += ((x in i.f[h][c]) ? i.f[h][c][x] : 0);
    inc = (f + i.m*prior)/(i.h[h] + i.m)
    like += log(inc)
  }
  return Gold.e^like }

# For everything that is not best,  find rules for getting to best.
# First, since it simplest (a) grow rules within one attribute.
# Then, (b) combine rules from multiple attributes
function _Rules(i,rules,    best,rest,c,j) {
  for(rest in i.h) 
    if (rest != i.best) {
      new(rules,rest)
      for(c in i.f[i.best]) 
        _OneAttributeRules(i,c,rest,rules[rest]);  # ... (a)
      _Learn(i,rest,rules[rest], i.generations)
      _Best(i,rules[rest]) }}
       
function _Best(i,rules,    j,k,doomed) {
  revsort(rules,"n")
  for(j in rules) 
    if(j+0 >i.population)
      doomed[j]
  for(j=1;j<=length(rules);j++)
    for(k=j+1;k<=length(rules);k++) {
      print(length(rules)-j,length(rules)-k,length(rules))
      if(rules[j].n == rules[k].n)
            doomed[k] }
  for(j in doomed) delete rules[j]
}
# (a) Make one rule for every range of column `c`.
# (b) If ever we use a range, mark it `used` (so we never use it twice).
function _OneAttributeRules(i,c,rest,rules,    used,x,one,n) {
  for(x in i.f[i.best][c]) # ... (a)
    if(!(x in used))       # ... (b)
      _OneAttributeRule(i,used,rest,c,x,rules)  }

# (a) Create a rule from this range,
# (b) If we use a range then mark it as used.
# (c) try to grow the rule using adjacent ranges from the 
function _OneAttributeRule(i,used,rest,c,x,rules,    current) {
  Rule(current, rest, i.best, c,x,i)       # ....... (a)
  used[x]      # ................................... (b)       
  _GrowOneAttributeRule(i,c,used,current,rules)} # ... (c)

# (a) From the space of  all possible ranges, then
# (b) find current range that have not bee used yet,
# (c) that are not mentioned by current rule, (d) that are
# not in the current rule and which (e) are adjacent to something
# already in rule. If (f) adding that range makes a better rule then
# try to extend that better rule. Else (h) add the current rule to out.
# Also, (i)  if we ever use a range, mark it as used.
function _GrowOneAttributeRule(i,c,used,current,rules,   x,x0,new) {
  for(x in i.f[i.best][c])        # ... (a)
    if(! (x in used))             # ... (b)
      if(! (x in current.has[c])) # ... (c)
        for(x0 in current.has[c]) # ... (d)
          if ((x==(x0+1) || x==(x0-1)) \
             && RuleBetter(current,new,c,x,i)) #..(e,f)
          { used[x]               # ... (i)
            return _GrowOneAttributeRule(i,c,used,new,rules) }
  if(current.n > 0) 
    append(rules,current) }  # .......... (g)

#------------------------------
function _Learn(i,rest,rules,gen,     zero,b4,sum,j,n) {
  if(gen < 2           ) return
  if(length(rules) < 2 ) return
  _Best(i,rules)
  for(j in rules) 
   sum += rules[j].n 
  n = i.samples
  while(--n > 0) 
   _Pick2(i,rules,sum)
  if(length(rules) > b4) 
    _Learn(i,rest,rules, gen-1) }

function _Pick2(i,rules,sum,      new,diff,j,k) {
  j = _Pick1(i,rules,sum)
  k = _Pick1(i,rules,sum)
  if (j != k &&  RuleMerge(rules[j], rules[k], new, i))   
    append(rules, new)  }

function _Pick1(i,rules,sum,   j,r) {
  r = rand()
  for(j=1; j<=length(rules); j++) {
    r= r - rules[j].n/sum
    if (r<=0) return j }
  return length(rules) }

#------------------------------
function Rule(i,rest,best,c,x,nb) {
  Obj(i); is(i,"Rule") 
  has(i,"has")
  i.has[c][x]
  i.doubt    = 0 
  i.n    = 0 
  i.from = rest 
  i.to   = best 
  _Score(i,nb) }

function _Score(i,nb,  b,r,n,h) {
  h = nb.h[i.to] + nb.h[i.from]
  b = NbLike(nb, i.has, i.to,  h,2)
  r = NbLike(nb, i.has, i.from,h,2) 
  n = b^2/(b+r)
  i.n = (b > r+.01) ? n : 0 
  return i.n }

function _Better(i,j,c,x,nb) { 
  copy(i,j)
  j.has[c][x]
  return _Score(j,nb) > i.n+.01 }

function _Merge(i,j,k,nb,    c,x) {
  copy(i,k)
  for(c in j.has) {
    for(x in j.has[c])  {
      k.has[c][x] }}
  _Score(k,nb) 
  return (k.n > i.n) && (k.n > j.n)
}   

function _Show(i,tab,     c,x,s,sep) {
  for(c in i.has)  {
   s= s tab.cols[c].txt" = ("; sep=""
   for(x in i.has[c]) {
      s = s sep x; sep=" or "}
   s=s") "}
  return "["int(100*i.n)"] " s
}
