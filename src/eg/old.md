
function Some(i) { i.is="Some"; has(i,"all"); i.n=0; i.max=256 }

function _Add((i,x) {
  if (length(i.all) < i.max)     return i.all[1+length(i.all)]=x
  if (rand()        < i.max/i.n) return i.all[    anyi(i.all)]=x }


