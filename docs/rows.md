#  rows.gold
  - [Row](#row) : Storage for one row of data.
    - [Row](#row) : Constructor
    - [_Dist](#_dist) : Distance between two rows
  - [Rows](#rows) : Storage for many rows of data, with summaries of the columns.
    - [Rows](#rows) : Constructor
    - [_Load](#_load) : Load a csv file `f` into the table `i`
    - [_Add](#_add) : Update `i` with `a`. First update creates the column headers.
    - [_Header](#_header) : Initialize columns in a table.
    - [_Data](#_data) : Add an row at some random index within `rows`.
    - [_Dist](#_dist) : Distance between two rows.
    - [_Far](#_far) : Return something quite far way from `r` (ignoring outliers).
    - [_Around](#_around) : Compute `out`; i.e.  pairs <row,d> listing neighbors of `r1`.
    - [_Clone](#_clone) : Copy the structure of table `i` into a new table `j`.
    - [_Y](#_y)
    - [_Sample](#_sample) : Set `a` to a sample of `enough` rows from column `c`.
    - [_Bins](#_bins) : Discretize all numeric columns in each row's `bins`.
    - [_Bin](#_bin) : Discretize one column of numeric values in each row's `bins`.
    - [_BinsHeader](#_binsheader) : Return a header where all the independent columns are not numbers
    - [_SomeBins](#_somebins) : Add a new table to `out` with discretized values for some rows. 


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
  has(i,"bins") }
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

## Rows 
Storage for many rows of data, with summaries of the columns.
The first row passed to `Rows` initializes the column summary objects.
The other rows are data.  In that first row:

- Column names containing `?` become `Info` columns.
- Column names containing `<>:` are `Num`bers (and all others are `Sym`s).
- Dependent variables (stored in `ys`) are marked with `<>!` 
  and all other are independent variables (stored in `xs`).
- Klass names are marked in `!`.

### Rows
Constructor

<ul><details><summary><tt>Rows(i:untyped, a:array|)</tt></summary>

```awk
function Rows(i:untyped, a:array|) {
  Object(i); i.is = "Rows"
  i.klass   = ""
  i.use     = "xs"
  i.far     = .95
  i.arounds = 128
  has(i,"rows");  has(i,"cols"); has(i,"names")
  has(i, "nums"); has(i, "syms")
  has(i,"info");  has(i,"xs");   has(i,"ys") 
  if (length(a)) _Add(i,a)}
```

</details></ul>

### _Load
Load a csv file `f` into the table `i`

<ul><details><summary><tt>_Load(i:Rows, f:fname)</tt></summary>

```awk
function _Load(i:Rows, f:fname,     record) {
  while(csv(record,f)) {  add(i,record)} }
```

</details></ul>

### _Add
Update `i` with `a`. First update creates the column headers.

<ul><details><summary><tt>_Add(i:Rows, a:array)</tt></summary>

```awk
function _Add(i:Rows, a:array) {
  if ("cells" in a) return RowsAdd(i, a.cells)
  return length(i.cols) ?  RowsData(i,a) : RowsHeader(i,a) }
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
    what == "Num" ? i.nums[j] : i.syms[j]
    i[where][j]
    if (a[j]~/!/) i.klass = j }
  return 0}
```

</details></ul>

### _Data
Add an row at some random index within `rows`.

<ul><details><summary><tt>_Data(i:Rows, a:array)</tt></summary>

```awk
function _Data(i:Rows, a:array,    r,j) {
  r = sprintf("%9.0f",1E9*rand())
  has(i.rows, r, "Row")
  for(j=1; j<=length(a); j++) 
    i.rows[r].bins[j] = i.rows[r].cells[j] = add(i.cols[j], a[j])  
  return r }
```

</details></ul>

### _Dist
Distance between two rows.

<ul><details><summary><tt>_Dist(i:Rows, r1:posint, r2:posint)</tt></summary>

```awk
function _Dist(i:Rows, r1:posint, r2:posint) {
  return  RowDist(i.rows[r1], i.rows[r2], i,i[i.use]) }
```

</details></ul>

### _Far
Return something quite far way from `r` (ignoring outliers).

<ul><details><summary><tt>_Far(i:Rows, r:posint)</tt></summary>

```awk
function _Far(i:Rows, r:posint,     n,out) {
  n= _Around(i,r, out) 
  return out[int(n*i.far)].row }
```

</details></ul>

### _Around
Compute `out`; i.e.  pairs <row,d> listing neighbors of `r1`.
Sorted by distance `d`.

<ul><details><summary><tt>_Around()</tt></summary>

```awk
function _Around(i,r1,out,   r2,n) {
  n = i.arounds 
  for(r2 in i.rows) 
    if(r1 != r2) {
       if(--n<0) break
       out[r2].row = r2
       out[r2].d   = _Dist(i,r1, r2) }
  return keysort(out,"d") }
```

</details></ul>

### _Clone
Copy the structure of table `i` into a new table `j`.

<ul><details><summary><tt>_Clone(i:Rows, j:Rows)</tt></summary>

```awk
function _Clone(i:Rows, j:Rows) {
  Rows(j)
  RowsHeader(j, i.names) }
```

</details></ul>

### _Y

<ul><details><summary><tt>_Y(i:Rows)</tt></summary>

```awk
function _Y(i:Rows,   c,s,sep) {
  for(c in i.ys) { 
    s = s sep i.cols[c].txt "=" i.cols[c].mu
    sep = ", " }
  return s }
```

</details></ul>

### _Sample
Set `a` to a sample of `enough` rows from column `c`.
Avoid cells with empty values

<ul><details><summary><tt>_Sample(i:Rows, a:untyped, c:posint, n:posint|128)</tt></summary>

```awk
function _Sample(i:Rows,a:untyped,c:posint,n:posint|128, r,v) {
  n = n ? n : 128
  for(r in i.rows) {
    v = i.rows[r].cells[c]
    if(v != "?") {
      if(--n>0) {a[r] = v} else {break}}}}
```

</details></ul>

### _Bins
Discretize all numeric columns in each row's `bins`.

<ul><details><summary><tt>_Bins(i:Rows)</tt></summary>

```awk
function _Bins(i:Rows,   n) {
  for(n in i.nums) 
    if (n in i.xs) 
      _Bin(i,n) }
```

</details></ul>

### _Bin
Discretize one column of numeric values in each row's `bins`.

<ul><details><summary><tt>_Bin(i:Rows, n:posint)</tt></summary>

```awk
function _Bin(i:Rows,n:posint,   tmp,r,a,bins) {
  _Sample(i,a,n)
  div(a,bins)
  for(r in i.rows)  
    i.rows[r].bins[n] = bin(bins, i.rows[r].bins[n]) }
```

</details></ul>

### _BinsHeader
Return a header where all the independent columns are not numbers

<ul><details><summary><tt>_BinsHeader(i:Rows, out:untyped)</tt></summary>

```awk
function _BinsHeader(i:Rows, out:untyped,      col) {
  for(col in i.cols) {
    out[col] = i.cols[col].txt
    if (col in i.xs) gsub(/:/,"",out[col] ) }}
```

</details></ul>

### _SomeBins
Add a new table to `out` with discretized values for some rows. 

<ul><details><summary><tt>_SomeBins(i:Rows, a:array, out:array)</tt></summary>

```awk
function _SomeBins(i:Rows,a:array,out:array,    n,head,r) {
  n = new(out,"Rows")
  RowsBinsHeader(i,  head)
  RowsHeader(out[n], head)
  for(r in a) 
    RowsData(out[n], i.rows[r].bins) 
  return n }
```

</details></ul>
