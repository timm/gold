# vim: filetype=awk ts=2 sw=2 sts=2  et :
function CsvDemo(i,f) {
  Obj(i)
  i.is   = "CsvDemo"  
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


function csv1ing(f,     i,n) {
  while(csv(a,f)) n+= length(a)
  print n }

function csving(f,     i,n) {
  CsvDemo(i,f)
  while(it(i)) n += length(i.fields)
  print(n) }

BEGIN { 
  print("\n--- Csv")
  csving(data("auto93")) }

function data(f,  d) { 
  d=Gold.dot
  return d d "/data/" f d "csv" }
