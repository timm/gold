BEGIN{  DOT=sprintf("%c",46)}

function push(lst,i) {
  lst[ length(lst)+1 ] = i
  return i
}

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p DOT)
  ooSortOrder(x)
  for(i in x)  {
    if (isarray(x[i]))   {
      print(txt i"" )
      oo(x[i],"","|  " pre)
    } else
      print(txt i (x[i]==""?"": ": " x[i])) }
}
function ooSortOrder(x, i) {
  for (i in x)
    return PROCINFO["sorted_in"] =\
      typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) if (s ~ /^[_a-z]/    ) print "#W> Rogue: " s>"/dev/stderr"
}

function tests(what, all,   one,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { one = a[i]; @one(one) }
  rogues()
}

function ok(f,got,want,   epsilon,     near) {
  if (typeof(want) == "number") {
     epsilon = epsilon ? epsilon : 0.001
     near = abs(want - got)/(want + 10^-32)  < epsilon
  } else
     near = want == got
  if (near)
    print "#TEST:\tPASSED\t" f "\t" want "\t" got
  else
    print "#TEST:\tFAILED\t" f "\t" want "\t" got
}

function zap(i,k)  { k = k?k:length(i)+1; i[k][0]; List(i[k]); return k } 

function List(i)         { split("",i,"") }
function Object(i)       { List(i); i["oid"]=++OID }

function has( i,k,f)      { f=f?f:"List"; zap(i,k); @f(i[k]); return length(i[k])}
function hass(i,k,f,m)    {               zap(i,k); @f(i[k],m); return length(i[k]) }
function hasss(i,k,f,m,n) {               zap(i,k); @f(i[k],m,n); return length(i[k])  }



