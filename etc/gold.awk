BEGIN { 
  GOLD["dot"]  = "." 
  GOLD["dots"] = ".." 
}

function gold2awk(use,s) 
{
  if (gsub(/^```awk/,"", s)) use= 1
  if (gsub(/^```/,  "" , s)) use= 0 
  if (use) 
    print gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/,
                  "[\"\\1\\2\"]","g", s);
  else
    print "# " s
  return use
}
function fileExists(f,   status) {
  status = getline < f
  status = status >= 0
  close(f)
  return status
}
function goldFile(f, seen,
            g,i,use,s) {
  if (f in seen) return 0
  if (fileExists(f)) {
    seen[f] 
    while((getline < f) > 0)  {
      if($0 ~ /^@include/) {
        g = $2
        gsub(/[" \t]/,"",g)
        gsub(/\.md$/,"",g)
        goldFile(g ".md", seen) 
     } else
       use = gold2awk(use, $0);
    }
    close(g) 
  } else
    print("#E missing file ",f) > "/dev/stderr"
}

function oks(    f) {
  for(f in FUNCTAB) 
    if (f ~ /^ok_/)  {
      print "\n#--- " f " -----------------------"
      srand(1)
      @f() 
  }
  rogues()
}

function ok(yes,    msg) {
  msg = yes ? "PASSED!" : "FAILED!"
  if (yes) 
     GOLD["test"]["yes"]++ 
  else
     GOLD["test"]["no"]++;
  print "#test:\t" msg
}

function within(lo,x,hi) { return x >= lo && x <= hi }

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) print "#W> Rogue: " s>"/dev/stderr"
}

function Object(i)  { 
  List(i)
  i["ois"]= "Object"
  i["oid"] = ++GOLD["oid"] 
}

function List(i)    { split("",i,"") }

function has(i,k,f,              s) { i[k]["0"]; delete i[k]["0"] ; f ? @f(i[k])  : List(i[k]) }
function hass(i,k,f,x1,          s) { i[k]["0"]; delete i[k]["0"] ; @f(i[k],x1)       }
function hasss(i,k,f,x1,x2,      s) { i[k]["0"]; delete i[k]["0"] ; @f(i[k],x1,x2)    }
function hassss(i,k,f,x1,x2,x3,  s) { i[k]["0"]; delete i[k]["0"] ; @f(i[k],x1,x2,x3) }

function have(i,f,               k) { k =length(i)+1; has(i,k,f);          return k }
function haves(i,f,x1,           k) { k =length(i)+1; hass(i,k,f,x1);      return k }
function havess(i,f,x1,x2,       k) { k =length(i)+1; hasss(i,k,f,x1,x2);    return k }
function havesss(i,f,x1,x2,x3,   k) { k =length(i)+1; hassss(i,k,f,x1,x2,x3); return k }

function is(i,x) {
  GOLD["ois"][x] = i["ois"] 
  i["ois"] = x
}

function inherit(s,f,   g) {
  while(s) {
    g = s f
    if (g in FUNCTAB) return g
    s = GOLD["ois"][s] # look upward in the class hierarchy
  }
  print "#E> failed method lookup: ["f"]"
  exit 2
}

function isa(f,a) {
  if (isarray(a))
    if ("ois" in a)
      if ("oid" in a) 
        if (f==a["ois"])
          if (a["ois"] in FUNCTAB) 
             return 1
}

function copy(a, b,     i){
  for (i in a) {
    if(isarray(a[i])) {
      b[i][0]        # ensure nested list exists
      delete b[i][0] 
      copy(a[i], b[i])
    } else 
      b[i] = a[i] 
}}

function o(a,     sep,    sep1,i,s) {
  for(i in a) {
    s    = s sep1 a[i]
    sep1 = sep ? sep : ", " }
  return s 
}

function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix GOLD["dot"] )
  if (!isarray(a)) {print(a); return a}
  ooSortOrder(a)
  for(i in a)  {
    if (isarray(a[i]))   {
      print(txt i"" )
      oo(a[i],"","|  " indent)
    } else
      print(txt i (a[i]==""?"": ": " a[i])) }
}
function ooSortOrder(a, i) {
  for (i in a)
   return PROCINFO["sorted_in"] =\
     typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}

