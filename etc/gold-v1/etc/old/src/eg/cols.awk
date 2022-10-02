### Col
#Summarize colums
#
#### class Num

func Num(i,pos,txt) {
  i["is"] ="Num"
  i["txt"]= txt
  i["pos"]= pos
  if (txt ~ /</) i["w"] = -1
  if (txt ~ />/) i["w"] =  1
  i["lo"]=  10^32
  i["hi"]= -10^32
  i["n"]= i["sd"] = i["mu"] = i["md"] = 0 }

#### Add
Incrementally add new data, update `mu`, `sd`, `n    


func NumAdd(i,x,   i)  { 
  if (x=="?") return x
  if(x>i["hi"]) i["hi"]=x
  if(x<i["lo"]) i["lo"]=x
  i["n"]++
  d     = x - i["mu"]
  i["mu"] += d / i["n"]
  i["m2"] += d * (x - i["mu"]) 
  i["sd"]  = (i["n"]<2 ?0: (i["m2"]<0 ?0: (i["m2"]/(i["n"] - 1))^0.5)) }

# 
# #### Sub
# Subtract new data, update `mu`, `sd`, `n`    
# 

func NumSub(x,     d)
  if x == "?" return x
  i["n"]  -= 1
  d     = x - i["mu"]
  i["mu"] -= d / i["n"]
  i["m2"] -= d * (x - i["mu"]) 
  i["sd"]  = (i["n"]<2 ?0: (i["m2"]<0 ?0: (i["m2"]/(i["n"] - 1))^0.5)) }

# 
# #### Norm
# Return a number 0[".1"], min[".max"]
# 

func NumNorm(i,x) { return (x - i["lo"]) / (i["hi"] - i["lo"]) }

# 
# #### CDF
# Return area under the probability curve below `-&infin; &le x`.
# 

func NumCDF(i,x)      { 
  x=(x-i["mu"])/i["sd"]; return 1/(1 + 2.71828^(-0.07056*x^3 - 1.5976*x)) }

# 
# #### AUC
# Area under the curve between two points
# 

func NumAUC(i,x,y) {return (x>y)? NumAUC(i,y,x): NumCDF(i,y) - NumCDF(i,x)}

# 
# ### Class Sym
# 

func Sym(i) { 
  i["is"] = "Sym"
  i["txt"]= txt
  i["pos"]= pos
  i["n"]  = i["most"] = 0
  i["mode"] =""
  has(i,"seen") }

#   
# #### Sub
# Add new data, update `mu`, `sd`, `n`    
# 

func SymAdd(i,x,  tmp) {
  if (x == "?") return v
  i["n"]++
  tmp = ++i["seen"][x]
  if (tmp > i["most"]) { i["most"] = tmp; i["mode"] = x }}

# 
# #### Sub
# Subtract new data, update `mu`, `sd`, `n`    
# adn: 

func SymSub(i,x) {
  if (x == "?") return x
  if( --i["n"]       < 1) i["n"]=0
  if( --i["seen"][x] < 1) delete i["seen"][x] }

#  awwk  
# #### AUC
# Area under the curve between two points
# 

func SymAUC(i,x) { return i["seen"][x]/i["n"] }

