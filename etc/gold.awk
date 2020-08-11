function gold2awk(use) {
  if (gsub(/^```awk/,"")) use= 1
  if (gsub(/^```/,  "")) use= 0
  if (use) 
    print gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/,
                  "[\"\\1\\2\"]","g",$0);
  else 
    print "# " $0
  return use
}

function tests(what, all,   f,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { 
    srand(1)
    f = a[i]; 
    @f(f) 
  }
  rogues()
}

function ok(f,yes,    msg) {
  msg = yes ? "PASSED!" : "FAILED!"
  if (yes) 
     GOLD["test"]["yes"]++ 
  else
     GOLD["test"]["no"]++;
  print "#test:\t" msg "\t" f
}

function within(x,lo,hi) { return x >= lo && x <= hi }

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) print "#W> Rogue: " s>"/dev/stderr"
}

function Obj(i)  { 
  List(i)
  i["ois"]= "Obj"
  i["oid"] = ++GOLD["oid"] 
}

function List(i)    { split("",i,"") }

function has(i,k,f,   s) { 
  if (!f) f = "List"               # ensure we are creating something
  if (!k) k = length(i)+1          # ensure we have a place to put it
  i[k]["\001"]; delete i[k]["\001"] # ensure we adding to a sulist
  @f(i[k])                         # create
  return k                         # return where we put it
}

function is(i,f1,f2) {
  if (f2) @f2(i)
  if ("ois" in i) { GOLD["ois"][f1] = i["ois"] }
  i["ois"] = f1
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
  if (isarray(a) && "ois" in a && "oid" in a && 
      f==a["ois"] && a["ois"] in FUNCTAB) {
       if (GOLD["brave"])
         return 1
       else {
         while(f) { 
           if (isa1(f, a)) 
             return 1
           f = GOLD["ois"][f] }}}
  return 0
}

function isa1(f,a,   b) { @f(b); return isa2(a,b) }

function isa2(a,b,     j) {
  if (isarray(a) && isarray(b)) {
    for(j in b) 
      if ( ! isa2(a[j], b[j]) ) 
        return 0
  } else {
      if (typeof(a) != typeof(b)) 
        return 0 
  }
  return 1
}
