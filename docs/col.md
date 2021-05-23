
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

```awk
function adds(i,a,    j) { for(j in a) add(i, a[j]) }
function add(i,x,   f) {
  if (x != "?") {
    i.n++
    f= i.is "Add"
    @f(i,x) }
  return x }
```

Expected middle and spreads.

```awk
function mid(i, f)    {f=i.is "Mid";    return @f(i) }
function spread(i, f) {f=i.is "Spread"; return @f(i) }
```

Normalize non-empty cells.

```awk
function norm(i,x,   f) {
  if (x != "?") { f= i.is "Norm"; return @f(i,x) }
  return x }
```

Missing value,

```awk
function dist(i,x,y,   f) {
  if (x==">" && y=="?") return 1 
  if (x != "?") { f= i.is"Dist"; return @f(i,x) }
  return x }
```
