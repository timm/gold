[home](https://github.com/timm/gold/blob/master/README.md) ::
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
<img align=right width=350 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
# GOLD = a Gawk Object Layer

## OO

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

- `has(i,key,function)` calls `function` to add something to `i[key]`.
- `more(i,function)` calls `function` to append something to end of `i`. Returns position of new item.
  Used to append items to an already created list.

```awk
function more(i,f)  { k= 1+length(i[k]); has(i,k,f); return k }
function has(i,k,f) { f= f?f:"List"; i[k]["\t"]; @f(i[k]); delete i[k]["\t"] }
```
