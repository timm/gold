### Define polymorphic signatures
function read(i,file,  f) {f=i.is"Read"; return @f(i,file) }
function adds(i,x,y,   f) {f=i.is"Adds";  return @f(i,x,y)  }

### If you are happy and you know it, do some things
## Constructor
function Bias(i,n) {
  Obj(i)
  is(i, "Bias")
  i.n = n ? n : 10
  i.ready   = 0 # true if actions sorted on priority
  i.total = 0
  has(i,"actions") }

## Ready means  _actions _ are sorted by priority.
function  _Ready(i) {
  if(!i.ready) { i.ready=keysort(i.actions,"when") }}

## add a new thing, default priority=1
function  _Adds(i,act,when) { 
  when     = when ? when : 1 # handle defaults
  i.total += when            # track priority sum
  moRE(i.actions,"Act",act,when) 
  i.ready  = 0 } # since actions may not be sorted correctly

## read actions from file
function  _Read(i,file,  row) {
  while(rows(row, file)) {
    Cs
    adds(i,row[2],row[1])}}

## Print  _n _ actions, favoring those with higher priorities.
function  _It(i,  j,r)  { 
   _Ready(i) 
  r=rand()
  for(j=length(i.actions); j>=1; j--) {
    r -= i.actions[j].when/i.total
    if(r<=0) 
       return i.actions[j].what }}

## Xy's are simple container for two things
function Act(i,what,when)  { i.what=what; i.when=when }
