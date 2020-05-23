BEGIN{  AU["oid"]  = 0
        AU["up"]   = ".."
        AU["dot"] = "." 
}

function List(i)    { split("",i,"") }
function Object(i)  { List(i); i["oid"] = ++AU["oid"] }

function zap(i,k)  { k = k?k:length(i)+1; i[k][0]; List(i[k]); return k } 

function has( i,k,f,      s) { f=f?f:"List"; s=zap(i,k); @f(i[k]);     return s}
function hass(i,k,f,m,    s) {               s=zap(i,k); @f(i[k],m);   return s}
function hasss(i,k,f,m,n, s) {               s=zap(i,k); @f(i[k],m,n); return s}



