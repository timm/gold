
# col.gold


Base class for columns.

```awk
function Col(i,at,txt) {
  Obj(i)
  is(i,"Col")
  i.at = at
  i.txt = txt
  i.n   = 0
  i.w   = txt ~ /-/ ? -1 : 1 }
```

## Generic protocols for all columns.

Add things.

```awk
function adds(i,a,    j) { for(j in a) add(i, a[j]) }
```

Adding one thing.

```awk
function add(i,x,   f) {
  if (x != "?") {
    i.n++
    f= does(i,"Add")
    @f(i,x) }
  return x }
```

Expected middle and spreads.

```awk
function mid(i, f)    {f=does(i,"Mid");    return @f(i) }
function spread(i, f) {f=does(i,"Spread"); return @f(i) }
```

Normalizing non-empty values.

```awk
function norm(i,x,   f) {
  if (x != "?") { f=does(i,"Norm"); return @f(i,x) }
  return x }
```

Distances between values.

```awk
function dist(i,x,y,   f) {
  if (x=="?" && y=="?") return 1 
  if (x != "?") { f=does(i,"Dist"); return @f(i,x) }
  return x }
```
