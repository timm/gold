# vim: filetype=awk ts=2 sw=2 sts=2  et :

# built-ins for the Gold language
# should be all "raw" gawk (no Gold extensions)

BEGIN {
   Gold["dot"]  = sprintf("%c",46) 
   Gold["dots"] = Gold["dot"] Gold["dot"]
   Gold["seed"] = 1
   Gold["pi"]   = 3.1415926535
   Gold["e"]    = 2.7182818284
   Gold["id"]   = 0 }

### transpile stuff
function gold2awk(f,  klass,tmp) {
  while (getline <f) {
    # multi line comments delimited with #< ... >#
    if(/^#</) {do {print "# " $0} while((getline<f) && (! /^#>/));  print $0}
    # grab class name so we can expand "_" to current class
    if (/^func(tion)?[ \t]+[A-Z][^\(]*\(/) {  # new class name
      split($0,tmp,/[ \t\(]/); klass = tmp[2] 
    }
    # expand " _" to the current class
    gsub(/[ \t]_/," " klass)
    # turn a.b.c[1] into a["b"]["c"][2]
    print  gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/, 
                  "[\"\\1\\2\"]","g", $0) }}

### object creation stuff
function Obj(i)   { i["id"] = ++Gold["id"] }

function is(i, new,old) {
  if ("is" in i) Gold["is"][new] = old
  i["is"] = new }

function new(i,k) { i[k]["\127"]; delete i[k]["\127"] }

function does(i,f,      s,k0,k) {
  k = k0 = i["is"]
  do { s= k f
       if(s in FUNCTAB) return s
  } while(k=Gold["is"][k])
  print "E> method not found "f" in "k0
  exit 1 }

## add a nested list to `i` at `k` using constructor `f` (if supplied)
## the haS and hAS and HAS variants are the same, 
## but constructors have 1 or 2 or 3 args
function has(i,k,     f)  {new(i,k); if(f) @f(i[k])      }
function haS(i,k,f,x)     {new(i,k);       @f(i[k],x)    }
function hAS(i,k,f,x,y)   {new(i,k);       @f(i[k],x,y)  }
function HAS(i,k,f,x,y,z) {new(i,k);       @f(i[k],x,y,z)}

## using constructor `f`, add to the end of nested list `i`
# Note: `i` must already be a list.
## the morE and moRE and mORE variants are the same, 
## but constructors have 1 or 2 or 3 args
function more(i,f)       { has(i,length(i)+1,f)       }
function morE(i,f,x)     { haS(i,length(i)+1,f,x)     }
function moRE(i,f,x,y)   { hAS(i,length(i)+1,f,x,y)   }
function mORE(i,f,x,y,z) { HAS(i,length(i)+1,f,x,y,z) }

### list stuff
## push to end of list
function push(x,a) { a[length(a)+1]=x; return x }

## return  end of list
function last(a)  { return a[length(a)] }

# recursive copy of `a` into `b`
function copy(a,b,   j) { 
  for(j in a) 
    if(isarray(a[j]))  { new(b,j); copy(a[j], b[j]) }
    else
      b[j] = a[j] }

### sort a list on some named field `k`
# `keysort` modifies the urinal list while `keysorT` returns
# a sorted copy.
function keysort(a,k)   {Gold["keysort"]=k; return asort(a,a,"keysrt")}
function keysorT(a,b,k) {Gold["keysort"]=k; return asort(a,b,"keysrt")}

function keysrt(i1,x,i2,y) {
  return keysrtCompare(x[ Gold["keysort"] ] + 0,
                     y[ Gold["keysort"] ] + 0) } 

function keysrtCompare(x,y) { return x<y ? -1 : (x==y?0:1) }

## flat list to string. optionally, show `prefix`
function o(a, prefix,     i,sep,s) {
  for(i in a) {s = s sep prefix a[i]; sep=","}
  return  s }

## print nested array, keys shown in sorted order
function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix ? prefix Gold["dot"] : "")
  if (!isarray(a)) {print(a); return a}
  ooSortOrder(a)
  for(i in a)  {
    if (isarray(a[i]))   {
      print(txt i"" )
      oo(a[i],"","|  " indent)
    } else
      print(txt i (a[i]==""?"": ": " a[i])) }}

function ooSortOrder(a, i) {
  for (i in a)
   return PROCINFO["sorted_in"] =\
     typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc" }

### meta stuff
## hunt down rogue local variabes
function rogues(   s,ignore) { 
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) 
      print "#W> Rogue: "  s>"/dev/stderr" }

### file stuff
## looping over files 
function rows(a, f,       g,txt) {
  f = f ? f : "-"             
  g = getline < f
  if (g< 0) { print "#E> Missing file ["f"]"; exit 1 } # file missing
  if (g==0) { close(f) ; return 0 }       # end of file                   
  delete a
  split($0, a, ",")                      # split on "," into "a"
  return 1 } 

function it(i,  f) { f=does(i,"It"); return @f(i) }

## looping over csvs
function csv(a, f,       b4, g,txt,i,old,new) {
  f = f ? f : "-"             
  g = getline < f
  if (g< 0) { print "#E> Missing file ["f"]"; exit 1 } # file missing
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
