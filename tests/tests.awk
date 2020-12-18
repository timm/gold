# vim: filetype=awk ts=2 sw=2 sts=2  et :

function assert(a,b) { 
  b="-- " b
  print(a ?  b"? PASS" : b"? FAIL") }

BEGIN { 
  print("\n--- Things")
  assert(1,"love")
  assert(0,"hate") }
