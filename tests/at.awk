# vim: filetype=awk ts=2 sw=2 sts=2  et :

function Who(i,name,shoes) {
  Obj(i) ; is(i,"Who")
  i.name=name ? name : "jane"
  i.shoeSize=shoes ? shoes : 5 }

function _Show(i) { print i.name,i.shoeSize ; return i.id}

function main(      i,j) {
  Who(i)
  j=Show((i)) 
  print j }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main()
        rogues()  }

