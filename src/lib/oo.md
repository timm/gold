<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

## OO
<details open><summary>Table of Contents</summary>

- [Slot Creation](#slotcreation) : Makeing it happena     
  - [Other stuff](#otherstuff) : asd da d

</details>
Three base structures:

- GOLD: a global to store, well, everything
- GOLD.dot: _GOLD_ translates full stops into nested array access. So if your code really needs a full stop 
  (e.g. in extensions to file names) used `GOLD.dot`.
- `List`: Constructor for empty lists.
- `Obj`: Constructor for the  base class `Obj`. Contains a unique id.

#### object List

<details>

```awk

BEGIN             { List(GOLD) ; GOLD.dot=sprintf("%c",46) }
function List(i)  { split("",i,"") }
function Obj(i)   { List(i); i.id = ++GOLD.id }
```
</details>

### Slot Creation 
Makeing it happena     

- `has(i,key,function)` calls `function` to add something to `i[key]`.
- `more(i,function)` calls `function` to append something to end of `i`. Returns position of new item.
  Used to append items to an already created list.

#### Other stuff
asd da d
<details><summary>...</summary>

```awk
function method(i,f)         { METHOD=i.is f }
function more( i,f,       k) { k=1+length(i); if(f) @f(i[k])      ; return k}
function morE( i,f,x1,    k) { k=1+length(i); if(f) @f(i[k],x1)   ; return k}
function moRE( i,f,x1,x2, k) { k=1+length(i); if(f) @f(i[k],x1,x2); return k}

function has0(i,k)           { i[k]["\t"]; delete i[k]["\t"]       }
function has( i,k,f)         { has0(i,k);  if(f) @f(i[k])          }
function haS( i,k,f,x1)      { has0(i,k);  if(f) @f(i[k],x1)       }
function hAS( i,k,f,x1,x2)   { has0(i,k);  if(f) @f(i[k],x1,x2)    }
```
</details>
