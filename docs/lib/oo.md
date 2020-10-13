# OO

Three base structures:

- GOLD: a global to store, well, everything
- GOLD.dot: _GOLD_ translates full stops into nested array access. So if your code really needs a full stop 
  (e.g. in extensions to file names) used `GOLD.dot`.
- `List`: Constructor for empty lists.
- `Obj`: Constructor for the  base class `Obj`. Contains a unique id.


```awk
BEGIN             { List(GOLD) ; GOLD.dot=sprintf("%c",46) }
function List(i)  { split("",i,"") }
function Obj(i)   { List(i); i.id = ++GOLD.id }
```

## Slot Creation

- `has(i)` adds a new list at position `i[size+1]`
- `has(i,Constructor)` adds a new `Contructor` thing at  position`i[size+1]`
- `has(i,Constructor,key)` adds a new `Contructor` thing at  postilion `i[key]`

All calls to `has` return the position of the added thing.

```awk
function has(i,f,k)  { return has0(i, f?f:"List", k?k:1+length(i[k])) }
function has0(i,f,k) { i[k][0]; @f(i[k]); delete i[k][0]; return k }
```
