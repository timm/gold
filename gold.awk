#!/usr/bin/env gawk -f
# vim: filetype=awk ts=2 sw=2 sts=2  et :

#--------------------------------
# built-ins for the Gold language
# should be all "raw" gawk (no Gold extensions)

BEGIN {
   Gold["dot"]  = sprintf("%c",46) 
   Gold["dots"] = Gold["dot"] Gold["dot"]
   Gold["seed"] = 1
   Gold["pi"]   = 3.1415926535
   Gold["e"]    = 2.7182818284
   Gold["id"]   = 0 }

################################################
### transpile stuff

function toAwk(  i,klass,codep,tmp) {
  OFS=FS="\n"; RS=""
  while (getline) {
    codep= (/}[ \t]*$/ || /^@include/)
    if (! codep) {
      for(i=1;i<=NF;i++) $i="# " $i
      print $0  "\n"  
    } else {
      # grab class name so we can expand "_" to current class
      if (/^func(tion)?[ \t]+[A-Z][^\(]*\(/)   # new class name
        split($0,tmp,/[ \t\(]/); klass = tmp[2] 
      # expand " _" to the current class
      gsub(/[ \t]_/," " klass)
      # method call shorthand. Generates (FUN=does(obj,"f")?@FUN(obj):1)
      #if  (/@[A-Z][^\(]+\(/) print 11 ": " $0
      #$0=gensub(/@([A-Z][^\(]+)\(\(([A-Za-z\.0-9_]+)(.*)\)\)/,
      #          "((FUN=does(\\2,\"\\1\"))?@FUN(\\2\\3):1)","g",$0)
      # turn a.b.c[1] into a["b"]["c"][2]
      print  gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/, 
                  "[\"\\1\\2\"]","g", $0) 
      print "" }}}

function toMd(   pre,codep,codeb4) {
  FS="\n"; RS=""
  print "\n# " ARGV[1] "\n"
  while(getline) {
    if(/^# vim: /) continue
    codep = /}[ \t]*$/
    if (codep  &&  !codeb4) print "\n```awk"
    if (!codep &&  codeb4)  {print "```\n"}
    if (!codep &&  !codeb4) {print ""}
    if (codep  &&  codeb4)  {print ""}
    print  $0 
    codeb4=codep
  }
  if (codep) print "```" }

function  redGreen(  bad) {
  while(getline) {
     if (/^### --/) { $0="\n\033[01;36m"$0"\033[0m" }
     if (/FAIL/)    { bad++; $0="\033[31m"$0"\033[0m" }
     if (/PASS/)    { $0="\033[32m"$0"\033[0m" }
     print $0  }                
  exit(bad!=0)
}

################################################
### object creation stuff

function Obj(i)   { i["id"] = ++Gold["id"] }

function is(i, new) {
  if ("is" in i) Gold["is"][new] = i["is"]
  i["is"] = new }

function empty(i) { split("",i,"") } 

function has0(i,k) { 
  k = k ? k : length(i) + 1
  i[k]["\t"]
  delete i[k]["\t"]
  return k }

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

function has(i,k,     f)     {has0(i,k); if(f) @f(i[k])        ;return k}
function haS(i,k,f,x)        {has0(i,k);       @f(i[k],x)      ;return k}
function hAS(i,k,f,x,y)      {has0(i,k);       @f(i[k],x,y)    ;return k}
function HAS(i,k,f,x,y,z)    {has0(i,k);       @f(i[k],x,y,z)  ;return k}
function HASS(i,k,f,w,x,y,z) {has0(i,k);       @f(i[k],w,x,y,z);return k}

## using constructor `f`, add to the end of nested list `i`
# Note: `i` must already be a list.
## the morE and moRE and mORE variants are the same, 
## but constructors have 1 or 2 or 3 args

function more(i,f)         {return has(i,length(i)+1,f)          }
function morE(i,f,x)       {return haS(i,length(i)+1,f,x)        }
function moRE(i,f,x,y)     {return hAS(i,length(i)+1,f,x,y)      }
function mORE(i,f,x,y,z)   {return HAS(i,length(i)+1,f,x,y,z)    }
function MORE(i,f,w,x,y,z) {return HASS(i,length(i)+1,f,w,x,y,z) }

################################################
### Support stuff

### math stuff

function abs(x)   { return x<0? -1*x : x }
function max(x,y) { return x<y? y : x }
function min(x,y) { return x>y? y : x }

## push to end of list

function push(x,a) { a[length(a)+1]=x; return x }

## return  end of list

function last(a)  { return a[length(a)] }

# recursive copy of `a` into `b`

function copy(a,b,   j) { 
  for(j in a) 
    if(isarray(a[j]))  { has0(b,j); copy(a[j], b[j]) }
    else               { b[j] = a[j]                }}

function append(a, x,k) { 
   k = length(a) + 1
   has0(a,k)
   copy(x, a[k]) }

# any index in a lst

function anyi(a) { return 1+ int(rand() * length(a)) }
function any( a) { return a[ anyi(a) ] }

### sort a list on some named field `k`
# `keysort` modifies the urinal list while `keysorT` returns
# a sorted copy.

function keysort(a,k)   { Gold["sort"]=k; return asort(a,a,"srt")  }
function keysorT(a,b,k) { Gold["sort"]=k; return asort(a,b,"srt")  }
function revsort(a,k)   { Gold["sort"]=k; return asort(a,a,"rsrt") }
function revsorT(a,b,k) { Gold["sort"]=k; return asort(a,b,"rsrt") }

function rsrt(i1,x,i2,y) { return -1 * srt(i1,x,i2,y) }
function srt(i1,x,i2,y) {
  return keysrtCompare( x[Gold["sort"]] + 0, y[Gold["sort"]] + 0) } 

function keysrtCompare(x,y) { return x<y ? -1 : (x==y?0:1) }

## flat list to string. Optionally, show `prefix`

function ooo(a, prefix,     i,sep,s) {
  for(i in a) {s = s sep prefix i"="a[i]; sep=", "}
  return  s }

## flat list to string. Optionally, show `prefix`

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
      oo(a[i],prefix,"|  " indent)
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
      print "#W> Rogue: "  s }

function assert(x,s) { 
  print " - "(x ? "PASS " :  "FAIL ") s }

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
