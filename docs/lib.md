#  lib.gold
  - [Globals](#-globals) : There is only one.
    - [BEGIN { List](#-begin--list)
  - [Object stuff](#--object-stuff-) : Methods for handling objects.
    - [List](#-list) : Initialize an empty list
    - [Object](#-object) : Initialize a new object, give it a unique id (in `i.id`)
    - [has](#-has) : Create something of class `f` inside of `i` at position `k`
    - [haS](#-has) : Like `has`, but accepts one constructor argument `x`.
    - [hAS](#-has) : Like `has`, but accepts two constructor arguments `x` and `y`..
    - [new](#-new) : Add a new instances of class `f` at the end of `i`.
    - [asNum](#-asnum) : If `x` can be coerced number, return that. Else return `x`.
  - [Testing stuff](#-testing-stuff-) : Support for unit testing.
    - [rogues](#-rogues) : Print local variables, escaped from functions
    - [tests](#-tests) : Run the functions names in the comma-separated string `s`.
    - [ok](#-ok) : Print "PASS" if `got` same as `want1` (and print "FAIL" otherwise).
    - [red](#-red)
  - [Array stuff](#-array-stuff-) : Support for managing arrays.
    - [push](#-push) : Return `x` after adding to the end of `a`.
    - [keysort](#-keysort) : Sort `a` by field `k`.
    - [keysort1](#-keysort1)
    - [sortCompare](#-sortcompare)
    - [copy](#-copy) : `b` is set to a recursively copy of `a`.
  - [Maths stuff](#-maths-stuff-) : Some mathematical details.
    - [abs](#-abs) : Return absolute value of `x`.
    - [max](#-max) : Return max of `x` and `y.
    - [min](#-min) : Return min of `x` and `y.
    - [z](#-z) : Sample from a Gaussian.
    - [Printing stuff](#-printing-stuff-)
      - [o](#-o) : Simple printing of a flat array
      - [oo](#-oo)
      - [ooSortOrder](#-oosortorder)
  - [File stuff](#-file-stuff-)
    - [csv](#-csv) : Loop over a csv file `f`, setting the array `a` to the next record.


------------------------------------------
General support code.
 
Copyright (c) 2020, Tim Menzies.   
Licensed under the MIT license 
for full license info, see LICENSE.md in the project root

------------------------------------------

## Globals
There is only one.

### BEGIN { List

<ul><details><summary><tt>BEGIN { List()</tt></summary>

```awk
BEGIN { List(Gold); 
  Gold.test.epsilon=0.00001
  Gold.pi= 3.141592653
  Gold.e = 2.718281828
  Gold.dot=sprintf("%c",46)  }
```

</details></ul>

------------------------------------------

##  Object stuff 
Methods for handling objects.

### List
Initialize an empty list

<ul><details><summary><tt>List(i:untyped)</tt></summary>

```awk
function List(i:untyped) { 
  split("",i,"") }
```

</details></ul>

### Object
Initialize a new object, give it a unique id (in `i.id`)

<ul><details><summary><tt>Object(i:untyped)</tt></summary>

```awk
function Object(i:untyped) { 
  List(i); i.id = ++Gold.id }
```

</details></ul>

### has
Create something of class `f` inside of `i` at position `k`

<ul><details><summary><tt>has(i:untyped, k:atom, f:?fname)</tt></summary>

```awk
function has(i:untyped, k:atom, f:?fname) { 
  f=f?f:"List";i[k][0]; @f(i[k]); delete i[k][0]; return k}
```

</details></ul>

### haS
Like `has`, but accepts one constructor argument `x`.

<ul><details><summary><tt>haS(i:untyped, k:atom, f:?fname, x:any)</tt></summary>

```awk
function haS(i:untyped, k:atom, f:?fname, x:any)  { 
  i[k][0]; @f(i[k],x); delete i[k][0] }
```

</details></ul>

### hAS
Like `has`, but accepts two constructor arguments `x` and `y`..

<ul><details><summary><tt>hAS(i:untyped, k:atom, f:fname, x:any, y:any)</tt></summary>

```awk
function hAS(i:untyped, k:atom, f:fname, x:any, y:any) { 
  i[k][0]; @f(i[k],x,y); delete i[k][0] }
```

</details></ul>

### new
Add a new instances of class `f` at the end of `i`.

<ul><details><summary><tt>new(i:array, f:fname)</tt></summary>

```awk
function new(i:array, f:fname, k) { 
  k=length(i)+1; has(i,k,f); return k }
```

</details></ul>

### asNum
If `x` can be coerced number, return that. Else return `x`.

<ul><details><summary><tt>asNum(x:atom)</tt></summary>

```awk
function asNum(x:atom,    y) {
  y = x+0
  return x==y ? x : y }
```

</details></ul>

------------------------------------------

## Testing stuff 
Support for unit testing.

### rogues
Print local variables, escaped from functions

<ul><details><summary><tt>rogues()</tt></summary>

```awk
function rogues(   s,ignore) { 
  ignore=       "(ARGV|ROUNDMODE|ORS|OFS|LINT|FNR"
  ignore=ignore "|ERRNO|NR|IGNORECASE|TEXTDOMAIN|NF|ARGIND"
  ignore=ignore "|ARGC|PROCINFO|FIELDWIDTHS|CONVFMT|SUBSEP"
  ignore=ignore "|PREC|ENVIRON|RS|FPAT|RT|RLENGTH|OFMT"
  ignore=ignore "|FS|RSTART|FILENAME|BINMODE)"
  for(s in SYMTAB) 
    if (s ~ /^[A-Z]/)  
      if (s !~ ignore)
         print "#W> Global: " s>"/dev/stderr" 
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) 
      print "#W> Rogue: "  s>"/dev/stderr" }
```

</details></ul>

### tests
Run the functions names in the comma-separated string `s`.

<ul><details><summary><tt>tests(s:string)</tt></summary>

```awk
function tests(s:string,     a,i,f) {
  split(s,a,",") 
  for(i in a) {
     f=a[i]
     if(f in FUNCTAB)
       @f(s) }}
```

</details></ul>

### ok
Print "PASS" if `got` same as `want1` (and print "FAIL" otherwise).

<ul><details><summary><tt>ok(s:string, got:atom, want:atom, epsilon:number)</tt></summary>

```awk
function ok(s:string, got:atom, want:atom,   epsilon:number,       good) {
  epsilon = epsilon ? epsilon : Gold.test.epsilon
  if (typeof(want) == "number") 
    good = abs(want - got)/(want + 10^-32)  < epsilon
  else
    good = want == got;
  s= "#TEST:\t"(good?"PASSED":"FAILED") "\t" want "\t" got " : " s
  rint(good ? green(s) : red(s)) }
```

</details></ul>

### red

<ul><details><summary><tt>red()</tt></summary>

```awk
function red(x)   { return "\033[31m"x"\033[0m" }
function green(x) { return "\033[32m"x"\033[0m" }
```

</details></ul>

------------------------------------------

## Array stuff 
Support for managing arrays.

### push
Return `x` after adding to the end of `a`.

<ul><details><summary><tt>push(a:array, x:atom)</tt></summary>

```awk
function push(a:array, x:atom) { 
  a[length(a)+1] = x; return x }
```

</details></ul>

### keysort
Sort `a` by field `k`.

<ul><details><summary><tt>keysort()</tt></summary>

```awk
function keysort(a,k) { 
  Gold["keysort"]=k; return asort(a,a,"keysort1") }
```

</details></ul>

### keysort1

<ul><details><summary><tt>keysort1()</tt></summary>

```awk
function keysort1(i1,x,i2,y) {
  return sortCompare(x[ Gold["keysort"] ] + 0,
                     y[ Gold["keysort"] ] + 0) } 
```

</details></ul>

### sortCompare

<ul><details><summary><tt>sortCompare()</tt></summary>

```awk
function sortCompare(x,y) { return x<y ? -1 : (x==y?0:1) }
```

</details></ul>

### copy
`b` is set to a recursively copy of `a`.

<ul><details><summary><tt>copy(a:array, b:array)</tt></summary>

```awk
function copy(a:array,b:array,   j) { 
  for(j in a) 
    if(isarray(a[j]))  {
      b[j][0]
      delete b[j][0]
      copy(a[j], b[j]) 
    } else
      b[j] = a[j] 
}
```

</details></ul>

------------------------------------------

## Maths stuff 
Some mathematical details.

### abs
Return absolute value of `x`.

<ul><details><summary><tt>abs(x:number)</tt></summary>

```awk
function abs(x:number)           { 
  return x>0 ? x : -1*x }
```

</details></ul>

### max
Return max of `x` and `y.

<ul><details><summary><tt>max(x:number, y:number)</tt></summary>

```awk
function max(x:number, y:number) { 
  return x>y ? x : y }
```

</details></ul>

### min
Return min of `x` and `y.

<ul><details><summary><tt>min(x:number, y:number)</tt></summary>

```awk
function min(x:number, y:number) { 
  return x>y ? y : x }
```

</details></ul>

### z
Sample from a Gaussian.

<ul><details><summary><tt>z(mu:nummber|0, sd:number|0)</tt></summary>

```awk
function z(mu:nummber|0, sd:number|0) {
  mu = mu?mu:0
  sd = sd?sd:1  
  return mu + sd*sqrt(-2*log(rand()))*cos(2*Gold.pi*rand())}
```

</details></ul>

------------------------------------------

### Printing stuff 

#### o
Simple printing of a flat array

<ul><details><summary><tt>o(a:array, prefix:string|"")</tt></summary>

```awk
function o(a:array, prefix:string|"",     i,sep,s) {
  for(i in a) {s = s sep prefix a[i]; sep=","}
  return  s }
```

</details></ul>

#### oo

<ul><details><summary><tt>oo()</tt></summary>

```awk
function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix Gold.dot )
  if (!isarray(a)) {print(a); return a}
  ooSortOrder(a)
  for(i in a)  {
    if (isarray(a[i]))   {
      print(txt i"" )
      oo(a[i],"","|  " indent)
    } else
      print(txt i (a[i]==""?"": ": " a[i])) }}
```

</details></ul>

#### ooSortOrder

<ul><details><summary><tt>ooSortOrder()</tt></summary>

```awk
function ooSortOrder(a, i) {
  for (i in a)
   return PROCINFO["sorted_in"] =\
     typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc" }
```

</details></ul>

------------------------------------------

## File stuff 

### csv
Loop over a csv file `f`, setting the array `a` to the next record.
Returns zero at end of files.
Complain if file is missing. Kill comments `#` and spaces.
Split lines on commas. If records split over more than one 
line (and end in a comma) concat that line to the next.
Coerce numeric strings to numbers.

<ul><details><summary><tt>csv(a:array, f:string|"")</tt></summary>

```awk
function csv(a:array, f:string|"",       b4, g,txt,i,old,new) {
  f = f ? f : "-"             
  g = getline < f
  if (g< 0) { print "#E> Missing f ["f"]"; exit 1 } # file missing
  if (g==0) { close(f) ; return 0 }       # end of file                   
  txt = b4 $0                             # combine with prior
  gsub(/[ \t]+/,"",txt)
  if (txt ~ /,$/) { return csv(a,f,txt) } # continue txt into next
  sub(/#.*/, "", txt)                    # kill whitespace,comments    
  if (!txt)       { return csv(a,f,txt) } # skip blanks
  split(txt, a, ",")                      # split on "," into "a"
  for(i in a) {
     old = a[i]
     new = a[i]+0
     a[i] = (old == new) ? new : old
  }
  return 1 } 
```

</details></ul>
