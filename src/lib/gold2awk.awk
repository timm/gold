function dots(s,   x) {
  return gensub(/\.([^0-9])([a-zA-Z0-9_]*)/, 
               "[\"\\1\\2\"]","g",s) 
} 
function subs(s,   x) { 
  for(x in SUBS) gsub(x, SUBS[x],s) 
  return s
}
function line(s) {
  if (s ~ /^}/) { 
    show=0
    return s      
  } else {  
    if (s ~ /^[\t ]*$/)   return s                                 
    s = subs(s)
    if (s ~ /^(func|BEGIN|END).*}$/) return dots(s) 
    if (s ~ /^(func|BEGIN|END)/)     show=1  
    return  ( show ?  dots(s) : "# " s ) }
}
function main(f,    path, used,        s,a) {
  if (used[f]++ == 0) { 
    print "#:::::" path " : " f " :::::::::::::::::::::::::::::"
    while((getline s < f) > 0) 
      if (s ~ /^@include/) 
        main( gensub(/.*"(.*)".*$/, "\\1","g",s), path ": " f, used)
      else if (s ~ /^#DEF/ )  {
        split(s,a," ")
 	  SUBS["\\<" a[2] "\\>"] = a[3] 
      } else if (f ~ /.*awk$/)
        print subs(s)
      else 
        if ((s !~ /^#!/)  && (s !~ /^# vim/))
          print line(s) }
}
BEGIN { main(ARGV[1]) }
