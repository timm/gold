# vim: filetype=awk nospell ts=2 sw=2 sts=2 et :

BEGIN { GOLD["DOT"] = sprintf("%c",46) }

function has(   i,k,f)       { f=f?f:"List"; zap(i,k); @f(i[k]) }
function hass(  i,k,f,m)     {               zap(i,k); @f(i[k],m) }
function hasss( i,k,f,m,n)   {               zap(i,k); @f(i[k],m,n) }
function hassss(i,k,f,m,n,o) {               zap(i,k); @f(i[k],m,n,o) }

function has1more(lst,new,f) {
  has(lst, length(lst)+1, new,f)
  return length(lst)
} 

function zap(i,k)         { i[k][0]; List(i[k])} 
function List(i)          { split("",i,"") }
function Object(i)        { List(i); i["oid"]=++OID }

function rogues(    s) {
  for(s in SYMTAB) {
    if (s ~ /^[A-Z][a-z]/) print "Global " s
    if (s ~ /^[_a-z]/    ) print "Rogue: " s }
}
function how(i,f,    k,m) {
 k = i["isa"]
 while(k) {
   m=k f
   if (m in FUNCTAB) return m
   k=GOLD["ISA"][k]
 }
 print "E> failed method lookup on ["f"]"; 
 exit 1
}
function isa(i,this,parent) {
  i["ISA"] = this
  GOLD["ISA"][this] = parent
}
