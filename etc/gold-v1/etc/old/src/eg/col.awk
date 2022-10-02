#<a name=top>&nbsp;<p>
#<a href="https://github["com"]/timm/gold/blob/master/README["md"]#top">home</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/lib/README["md"]#top">lib</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/cols/README["md"]#top">cols</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/rows/README["md"]#top">rows</a> ::
#<a href="http://github["com"]/timm/gold/blob/master/LICENSE["md"]#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies["us"]">Tim&nbsp;Menzies</a>
#<h1> GOLD = a Gawk Object Layer</h1>
#<em>A <a href="https://en["wikipedia"]["org"]/wiki/Little_auk">little <strike>auk</strike> awk</a>  goes a long way["<"]/em><br>
#<img width=250 src="https://raw["githubusercontent"]["com"]/timm/gold/master/etc/img/auk["png"]">
#
### Col
#Incrementally summarize columns
#
#<details><summary>Contents</summary>
#
#- [class Some](#class-some) : Reservoir sampling: just keep up to `i["max"]` items.
#  - [constructor Some](#constructor-some) : Initialize
#  - [method Add](#method-add) : Add a new item (if reservoir not full)[" Else"], replace an old item.
#  - [method Sd](#method-sd) : Compute the standard deviation of a list of sorted numbers.
#  - [method Better](#method-better) : Returns true if it useful dividing the list `a` to `c` at the point  `b`[" "] 
#  - [method Div](#method-div) : Divide our list `i["all"]` into `a`; i["e"][" bins"] of size `sqrt(n)`[" "]
#  - [method Merge](#method-merge) : Combine adjacent pairs of bins (if they too similar)[" Loop"] until there are no more combinable  bins.
#- [class Num](#class-num) : Incrementally summarize numerics.
#  - [constructor Num](#constructor-num) : Create a new `Num`.
#  - [method Add](#method-add) : Incrementally add new data, update `mu`, `sd`, `n`   
#  - [method Norm](#method-norm) : Return a number 0[".1"], min[".max"]
#  - [method CDF](#method-cdf) : Return area under the probability curve below `-&infin; &le x`.
#  - [method AUC](#method-auc) : Area under the curve between two points
#- [class Sym](#class-sym) : Incrementally summarize numerics
#  - [constructor Sym](#constructor-sym) : Create a new `Sym`.
#  - [method Add](#method-add) : Add new data, update `mu`, `sd`, `n`    
#  - [method Merge](#method-merge) : Returns true if  combing two `Sym`s does not have larger entropy that the parts.
#  - [method Ent](#method-ent) : Compute the entropy of the stored symbol counts.
#  - [method AUC](#method-auc) : Area under the curve between two points
#
#</details>
#
#
#### class Some
#Reservoir sampling: just keep up to `i["max"]` items.
#
#
##### constructor Some
#Initialize
#
#

function Some(i, pos,txt) { 
  i["is"]="Some"; i["sorted"]=0; 
  i["Size"] = 0.5
  i["Small"] = 4
  i["Epsilon"] = 0.01
  i["pos"] = pos
  i["txt"] = txt
  has(i,"all"); i["n"]=0; i["max"]=256 }

# 
# <ul>
# 
# #### method Add
# Add a new item (if reservoir not full)[" Else"], replace an old item.
# 
# 

@include "/Users/timm/gits/timm/gold/src/eg/../lib/list" # get "any"

function SomeAdd((i,x) {
  if (x=="?") return x
  if (length(i["all"]) < i["max"])     return i["all"][1+length(i["all"])]=x
  if (rand()        < i["max"]/i["n"]) return i["all"][     any(i["all"])]=x }

# 
# 
# #### method Sd
# Compute the standard deviation of a list of sorted numbers.
# Uses the trick that the standard deviation can be approximated 
# using the 90th-10th percentile (divided by 2.56).
# 
# 

function SomeSd(i,lo,hi,   p10,p90) {
  i["sorted"] = i["sorted"] ||  asort(i["all"])
  p10 = int(0.5 + (hi - lo)*.1)
  p90 = int(0.5 + (hi - lo)*.9)
  return (i["all"][p90] - i["all"][p10])/2.56 }

# 
# 
# #### method Better
# Returns true if it useful dividing the list `a` to `c` at the point  `b`[" "] 
# 
# 

function SomeBetter(i,a,b,c,     sd0,sd1,sd2,sd12,n1,n2) {
  n1   = b-a
  n2   = c-b-1
  sd0  = SomeSd(i,a,c)
  sd1  = SomeSd(i,a,b)
  sd2  = SomeSd(i,b+1,c)
  sd12 = n1/(n1+n2) * sd1 + n2/(n1+n2) * sd2
  return sd0 - sd12 > i["Epsilon"] }

# 
# 
# #### method Div
# Divide our list `i["all"]` into `a`; i["e"][" bins"] of size `sqrt(n)`[" "]
# 
# 


function SomeDiv(i,div,    n0,n1,lo,hi,bins,b) {
  i["sorted"] = i["sorted"] ||  asort(i["all"])
  enough = length(i["all"])^i["Size"]
  while(enough < i["Small"] &&  enough < length(i["all"])/2) 
    m *= 1.2
  b4 = alls = divs = div[1]["lo"] = div[1]["hi"] = 1
  while(++alls <= length(i["all"])) {
    if(alls - b4 > enough) 
      if(i["all"][alls] != i["all"][alls-1]) {
        ++divs
        b4 = div[divs]["lo"] = div[divs]["hi"] = alls  }
    div[divs]["hi"] = alls }}

# 
# #### method Merge
# Combine adjacent pairs of bins (if they too similar)[" Loop"] until there are no more combinable  bins.
# 
# 

function SomeMerge(i,a,c,    amax,as,b,bs) {
  amax = length(a)
  as = bs = 1
  b[bs]["lo"] = a[as]["lo"]
  b[bs]["hi"] = a[as]["hi"]
  while(as <= amax) {
    if(as < amax && SomeBetter(i, a[as]["lo"], a[as]["hi"], a[as+1]["hi"])) {
      b[bs]["hi"] = a[as+1]["hi"]
      as++
    } else {
      bs++
      b[bs]["lo"] = a[as]["lo"]
      b[bs]["hi"] = a[as]["hi"]
    }
    as++ }
  return bs<as ? SomeMerge(i,b,c) : copy(b,c) }

# 
# </ul>
# 
# ### class Num
# Incrementally summarize a stream of numerics.
# 
# e["g"].
# 
#     Num(x)
#     for(i=1; i<= 500; i++) method(x, "Add")@METHOD(x, rand()**2 )
#     print(x["mu"], x["sd"])
# 
# 
# #### constructor  Num
# Create a new `Num`.
# 
# 

function Num(i,pos,txt) {
  i["is"] ="Num"
  i["txt"]= txt
  i["pos"]= pos
  if (txt ~ /</) i["w"] = -1
  if (txt ~ />/) i["w"] =  1
  i["lo"]=  10^32
  i["hi"]= -10^32
  i["n"]= i["sd"] = i["mu"] = i["md"] = 0 }

# <ul>
# 
# #### method Add
# <ul>Incrementally add new data, update `mu`, `sd`, `n`   
# 
# 

function NumAdd(i,x,   i)  { 
  if (x=="?") return x
  if(x>i["hi"]) i["hi"]=x
  if(x<i["lo"]) i["lo"]=x
  i["n"]++
  d     = x - i["mu"]
  i["mu"] += d / i["n"]
  i["m2"] += d * (x - i["mu"]) 
  i["sd"]  = (i["n"]<2 ?0: (i["m2"]<0 ?0: (i["m2"]/(i["n"] - 1))^0.5)) }

# 
# #### method Norm
# Return a number 0[".1"], min[".max"]
# 
# 

function NumNorm(i,x) { return (x - i["lo"]) / (i["hi"] - i["lo"]) }

# 
# #### method CDF
# Return area under the probability curve below `-&infin; &le x`.
# 
# 

function NumCDF(i,x)      { 
  x=(x-i["mu"])/i["sd"]; return 1/(1 + 2.71828^(-0.07056*x^3 - 1.5976*x)) }

# 
# #### method AUC
# Area under the curve between two points
# 
# 

function NumAUC(i,x,y) {return (x>y)? NumAUC(i,y,x): NumCDF(i,y) - NumCDF(i,x)}

# 
# </ul>
# 
# ### class Sym
# Incrementally summarize a stream of symbols.
# 
# 
# #### constructor Sym
# Create a new `Sym`.
# 
# 

function Sym(i, pos,txt) { 
  i["is"] = "Sym"
  i["Epsilon"] = 0.01
  i["txt"]= txt
  i["pos"]= pos
  i["n"]  = i["most"] = 0
  i["mode"] =""
  has(i,"seen") }

# <ul>
# 
# #### method Add
# Add new data, update `mu`, `sd`, `n`    
# 
# 

function SymAdd(i,x,  tmp) {
  if (x == "?") return v
  i["n"]++
  tmp = ++i["seen"][x]
  if (tmp > i["most"]) { i["most"] = tmp; i["mode"] = x }}

# 
# #### method Merge
# Returns true if  combing two `Sym`s does not have larger entropy that the parts.
# As a side-effect, compute that combined item.
# 

function SymMerge(i,j,k) {
  Num(k,i["pos"],i["txt"])
  k["n"] = i["n"] + j["n"]
  for(x in i["seen"]) k["seen"][x] += i["seen"][x]
  for(x in j["seen"]) k["seen"][x] += j["seen"][x]
  for(x in k["seen"]) 
    if (k["seen"][x] > k["most"]) { k["most"] = k["seen"][x]; k["mode"]=x }
  k["lo"] = i["lo"] < j["lo"] ? i["lo"] : j["lo"]
  k["hi"] = i["hi"] > j["hi"] ? i["hi"] : j["hi"]
  e1  = SymEnt(i);  n1  = i["n"]
  e2  = SymEnt(j);  n2  = j["n"]
  e12 = SymEnt(k);  n12 = k["n"]
  return e12 - (n1/n12 * e1 + n2/n12*e2) <= i["Epsilon"] }

# 
# #### method Ent
# Compute the entropy of the stored symbol counts.
# 
# 

function SymEnt(i, e, p) {
  for(x in i["seen"][x])
    if (i["seen"][x]>0) {
      p  = i["seen"][x]/i["n"]
      e -= p*log(p)/log(2) }
  return e }

# 
# 
# 
# #### method AUC
# Area under the curve between two points
# 
# 

function SymAUC(i,x) { return i["seen"][x]/i["n"] }

