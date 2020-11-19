#  tab.gold
  - [Row](#-row) : Storage for one row of data.
    - [Row](#-row) : Constructor
    - [_Dist](#-_dist) : Distance between two rows
  - [Table](#-table) : Storage for many rows of data, with summaries of the columns.
    - [Tab](#-tab) : Constructor
    - [_Load](#-_load) : Load a csv file `f` into the table `i`
    - [_Add](#-_add) : Update `i` with `a`. First update creates the column headers.
    - [_Header](#-_header) : Initialize columns in a table.
    - [_Data](#-_data) : Add an row at some random index within `rows`.
    - [_Dist](#-_dist) : Distance between two rows.
    - [_Far](#-_far) : Return something quite far way from `r` (ignoring outliers).
    - [_Around](#-_around) : Compute `out`; i.e.  pairs <row,d> listing neighbors of `r1`.
    - [_Clone](#-_clone) : Copy the structure of table `i` into a new table `j`.
  - [TreeNode](#-treenode)
    - [TreeNode](#-treenode) : notes should be created in the tree;
    - [_X](#-_x) : Project 
    - [_Descend](#-_descend)
    - [_AddRi:TreeNode, t:Tab, r:posint) {](#-_addritreenode-ttab-rposint-) : Recursively add `i` , forking subtrees when a ## node gets more than `i.enough` items.  
    - [_Add1](#-_add1) : Divide the data
    - [_Print](#--_print)


-----------------------------------------------
Tools for summarizing columns of data.
 
Copyright (c) 2020, Tim Menzies.  Licensed under the MIT license.
For full license info, see LICENSE.md in the project root

-----------------------------------------------

@include "lib"   
@include "col"

-----------------------------------------------------------

## Row 
Storage for one row of data.

### Row
Constructor

<ul><details><summary><tt>Row(i:untyped)</tt></summary>

```awk
function Row(i:untyped) {
  Object(i)
  i.is = "Row"
  i.p  = 2
  has(i,"cells")
  has(i,"ranges") }
```

</details></ul>

### _Dist
Distance between two rows

<ul><details><summary><tt>_Dist(i:Row, j:Row)</tt></summary>

```awk
function _Dist(i:Row,j:Row, tab, cols,  c,pos,x,y,d,d1,n) {
  n = 1E-32
  for(c in cols) {
    pos = tab.cols[c].pos
    x   = i.cells[pos]
    y   = j.cells[pos]
    d1  = (x=="?" && y=="?") ? 1 : dist(tab.cols[c], x,y)
    d  += d1^i.p
    n++ }
  return (d/n)^(1/i.p) }
```

</details></ul>

-----------------------------------------------------------

## Table 
Storage for many rows of data, with summaries of the columns.
The first row passed to the `Tab`le initializes the column summary objects.
The other rows are data.  In that first row:

- Column names containing `?` become `Info` columns.
- Column names containing `<>:` are `Num`bers (and all others are `Sym`s).
- Dependent variables (stored in `ys`) are marked with `<>!` 
  and all other are independent variables (stored in `xs`).
- Klass names are marked in `!`.

### Tab
Constructor

<ul><details><summary><tt>Tab(i:untyped)</tt></summary>

```awk
function Tab(i:untyped) {
  Object(i); i.is = "Tab"
  i.klass   = ""
  i.use     = "xs"
  i.far     = .95
  has(i,"tree")
  has(i,"rows"); has(i,"cols"); has(i,"names")
  has(i,"info"); has(i,"xs");   has(i,"ys") }
```

</details></ul>

### _Load
Load a csv file `f` into the table `i`

<ul><details><summary><tt>_Load(i:Tab, f:fname)</tt></summary>

```awk
function _Load(i:Tab, f:fname,     record) {
  while(csv(record,f)) {  add(i,record)} }
```

</details></ul>

### _Add
Update `i` with `a`. First update creates the column headers.

<ul><details><summary><tt>_Add(i:Tab, a:array)</tt></summary>

```awk
function _Add(i:Tab, a:array) {
  if ("cells" in a) return TabAdd(i, a.cells)
  length(i.cols) ?  TabData(i,a) : TabHeader(i,a) }
```

</details></ul>

### _Header
Initialize columns in a table.

<ul><details><summary><tt>_Header()</tt></summary>

```awk
function _Header(i,a,   where, what, j) {
  for(j=1; j<=length(a); j++) {
    i.names[j] = a[j]
    if (a[j] ~ /\?/) {
      what="Info"
      where="info"
    } else {
      what = a[j] ~ /[:<>]/ ?  "Num" : "Sym"
      where= a[j] ~ /[!<>]/ ?  "ys"  : "xs"
    }
    hAS(i.cols, j, what, a[j],j)   
    i[where][j]
    if (a[j]~/!/) i.klass = j }}
```

</details></ul>

### _Data
Add an row at some random index within `rows`.

<ul><details><summary><tt>_Data(i:Tab, a:array)</tt></summary>

```awk
function _Data(i:Tab, a:array,    r,j) {
  r = sprintf("%9.0f",1E9*rand())
  has(i.rows, r, "Row")
  for(j=1; j<=length(a); j++) 
    i.rows[r].cells[j] = add(i.cols[j], a[j])  }
```

</details></ul>

### _Dist
Distance between two rows.

<ul><details><summary><tt>_Dist(i:Tab, r1:posint, r2:posint)</tt></summary>

```awk
function _Dist(i:Tab, r1:posint, r2:posint) {
  return  RowDist(i.rows[r1], i.rows[r2], i,i[i.use]) }
```

</details></ul>

### _Far
Return something quite far way from `r` (ignoring outliers).

<ul><details><summary><tt>_Far(i:Tab, r:posint)</tt></summary>

```awk
function _Far(i:Tab, r:posint,     n,out) {
  n= _Around(i,r, out) 
  return out[int(n*i.far)].row }
```

</details></ul>

### _Around
Compute `out`; i.e.  pairs <row,d> listing neighbors of `r1`.
Sorted by distance `d`.

<ul><details><summary><tt>_Around()</tt></summary>

```awk
function _Around(i,r1,out,   r2) {
  for(r2 in i.rows) 
    if(r1 != r2) {
       out[r2].row = r2
       out[r2].d   = _Dist(i,r1, r2) }
  return keysort(out,"d") }
```

</details></ul>

### _Clone
Copy the structure of table `i` into a new table `j`.

<ul><details><summary><tt>_Clone(i:Tab, j:Tab)</tt></summary>

```awk
function _Clone(i:Tab, j:Tab) {
  Tab(j)
  TabHeader(j, i.names) }
```

</details></ul>

-----------------------------------------------------------

## TreeNode

### TreeNode
notes should be created in the tree;
Constructor for a tree of clusters

<ul><details><summary><tt>TreeNode(i:untuped)</tt></summary>

```awk
function TreeNode(i:untuped) {
  Object(i)
  i.enough=64
  i.is = "TreeNode"
  i.c=i.lo=i.hi=i.mid = ""
  has(i,"all")
  has(i,"upper")
  has(i,"lower") }
```

</details></ul>

### _X
Project 

<ul><details><summary><tt>_X(i:TreeNode, t:Tab, r:posint)</tt></summary>

```awk
function _X(i:TreeNode, t:Tab, r:posint     a,b,x) {
   a = TabDist(t,r,i.lo)
   b = TabDist(t,r,i.hi)
   x = (a^2 + i.c^2 - b^2)/(2*i.c)
   return max(0, min(1, x)) }
```

</details></ul>

### _Descend

<ul><details><summary><tt>_Descend(i:TreeNode, top:TreeNode, t:Tab, d:float, r:posint)</tt></summary>

```awk
function _Descend(i:TreeNode, top:TreeNode, t:Tab, d:float, r:posint,   where) {
  where = d < i.mid ? "lower" : "upper" 
  return _Add1(i[where], top, t, t) }
```

</details></ul>

### _AddRi:TreeNode, t:Tab, r:posint) {
Recursively add `i` , forking subtrees when a ## node gets more than `i.enough` items.  
In a pointer-less language, to add in details deep
within a recursive structure, work down from
the root carry along the root node.

<ul><details><summary><tt>_AddRi:TreeNode, t:Tab, r:posint) {()</tt></summary>

```awk
function _AddRi:TreeNode, t:Tab, r:posint) {
  _Add1(i,
        i, # payload: top node (place to store clusters)
        t, # payload: table  (used to access distance calculations).
        r) }
```

</details></ul>

### _Add1
Divide the data

<ul><details><summary><tt>_Add1(i:TreeNode, top:TreeNode, t:Tab, r:posint)</tt></summary>

```awk
function _Add1(i:TreeNode, top:TreeNode, t:Tab, r:posint,   n,one,x,tmp) {
  push(i.all,  r)
  if (length(i.all) == i.enough)  {
    i.lo = TabFar(t, r)
    i.hi = TabFar(t, i.lo )
    i.c  = TabDist(t, i.lo, i.hi)
    for(one in i.all) {
      tmp[one]  = x = _X(i,t,one)
      i.mid    += x/2 
    }
    has(i,"upper","TreeNode")
    has(i,"lower","TreeNode")
    for (one in tmp) 
      _Descend(i,top, t, tmp[one], one) 
  }
  if (length(i.all)>i.enough) 
    return _Descend(i,top,t, _X(i,t,r),r)
  return i.id }
```

</details></ul>

###  _Print

<ul><details><summary><tt> _Print(i:TreeNode)</tt></summary>

```awk
 function _Print(i:TreeNode,         lvl,pre) {
   print pre length(i.all)
   if (length(i.lower)) _Print(i.lower, lvl+1, "|.. " pre)
   if (length(i.upper)) _Print(i.upper, lvl+1, "|.. " pre) }
```

</details></ul>
