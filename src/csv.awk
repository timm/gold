# vim: filetype=awk ts=2 sw=2 sts=2  et :

function Csv(i,f) {
  Obj(i)
  is(i, "Csv")  
  i.file = f 
  has(i,"fields") }

function _It(i,     ok,a,j,old,new) {
  if(ok = rows(a,i.file)>0)  
    if(length(a))  {
      delete i.fields
      for(j in a) {
        old = a[j]
        gsub(/([ \t]+|#.*)/,"",old)
        new = old + 0
        i.fields[j] = (new==old) ? new : old a[j] }}
  return ok}
