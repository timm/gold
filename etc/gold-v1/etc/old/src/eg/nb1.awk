#<a name=top>&nbsp;<p>
#<a href="https://github["com"]/timm/gold/blob/master/README["md"]#top">home</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/lib/README["md"]#top">lib</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/cols/README["md"]#top">cols</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/rows/README["md"]#top">rows</a> ::
#<a href="http://github["com"]/timm/gold/blob/master/LICENSE["md"]#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies["us"]">Tim&nbsp;Menzies</a>
#<h1> GOLD = a Gawk Object Layer</h1>
#<img width=250 src="https://raw["githubusercontent"]["com"]/timm/gold/master/etc/img/auk["png"]">
#
### Naive Bayes
#Basic Naive Bayes
#

@include "/Users/timm/gits/timm/gold/src/eg/../lib/oo"
@include "/Users/timm/gits/timm/gold/src/eg/../lib/list"
@include "/Users/timm/gits/timm/gold/src/eg/../lib/file"
@include "/Users/timm/gits/timm/gold/src/eg/../stats/abcd"

func Cols(i) { 
  i["is"]="Cols"
  i["class"]=""
  has(i,"nums"); has(i,"syms")
  has(i,"txt");has(i,"all");has(i,"x");has(i,"y")}

func ColsAdd(i,a,      c,x) {
  for(c in a) {
    x = a[c]
    skipp  = x ~ /\?/
    if(skipp) continue 
    classp = x ~ /!/
    nump   = /[:<>]/
    goalp  = /[!<>]/
    i["txt"][c] = x
    if(classp) i["class"] = c
    goalp ? i["y"][c]    : i["x"][c] 
    nump  ? i["nums"][c] : i["syms"][c] 
    has(i["all"], c, nump?"Num":"Sym", i["all"][c]
}}

function Num(i,pos,txt) {
  i["is"] ="Num"
  i["txt"]= txt
  i["pos"]= pos
  if (txt ~ /</) i["w"] = -1
  if (txt ~ />/) i["w"] =  1
  i["lo"]=  10^32
  i["hi"]= -10^32
  i["n"]= i["sd"] = i["mu"] = i["md"] = 0 }

function NumAdd(i,x,   i)  { 
  if (x=="?") return x
  if(x>i["hi"]) i["hi"]=x
  if(x<i["lo"]) i["lo"]=x
  i["n"]++
  d     = x - i["mu"]
  i["mu"] += d / i["n"]
  i["m2"] += d * (x - i["mu"]) 
  i["sd"]  = (i["n"]<2 ?0: (i["m2"]<0 ?0: (i["m2"]/(i["n"] - 1))^0.5)) }

function NumSub(x,     d)
  if x == "?" return x
  i["n"]  -= 1
  d     = x - i["mu"]
  i["mu"] -= d / i["n"]
  i["m2"] -= d * (x - i["mu"]) 
  i["sd"]  = (i["n"]<2 ?0: (i["m2"]<0 ?0: (i["m2"]/(i["n"] - 1))^0.5)) }

function NumNorm(i,x) { return (x - i["lo"]) / (i["hi"] - i["lo"]) }
func NumCDF(i,x)      { 
  x=(x-i["mu"])/i["sd"]; return 1/(1 + 2.71828^(-0.07056*x^3 - 1.5976*x)) }

function Sym(i,pos,txt

func Nb(i,f) {
   i["is"] = "Nb"
   i["Min"]   = 5  # tuning param
   i["K"]     = 1  # tuning param
   i["M"]     = 2  # tuning param
   i["file"]  = f  # data source (if empty string, then stdin)
   i["nall"]  = 0  # total rows seen
   has(i, "cols", "Cols")
   has(i, "seen")        # counts for each class
   has(i, "log", "Abcd")}# used to record performance

func NbAdd(i,row,  x,y,c,want,got) {
  ++i["nall"]
  y = row[i["cols"]["class"]]
  if (i["nall"] > i["Min"])  
    method(i["log"], "Add")@METHOD(i["log"], y, NbMostLiked(i,row))
  for(c in i["cols"]["all"]) {
    x = row[c]
    if(x != "?")    
      ++i["seen"][y][c][x] }}

func NbLike(i,row,y,n,    prior,like,c,x,f) {
  prior = like = (n + i["K"])/(i["nall"] + i["K"]*length(i["seen"]))
  like  = log(like)
  for(c in i["cols"]["x"]) {
      x = row[c]
      if(x != "?") {
        f = i["seen"][y][c][x] 
        like += log( (f + i["M"]*prior) / (n + i["M"])) }}
  return like }

func NbMostLiked(i,row,     y,like,most,out) {
  most = -10^32
  for(y in i["seen"]) {
    like = NbLike(i, row, y, i["seen"][y][i["cols"]["class"]][y])
    if (like > most) {
      most = like
      out  = y }}
  return out }   

func NbRead(i,     row) {
  csv(row, i["file"]) 
  method(i["cols"], "Add")@METHOD(i["cols"], row)
  while (csv(row, i["file"]))  
    method(i, "Add")@METHOD(i, row) }

