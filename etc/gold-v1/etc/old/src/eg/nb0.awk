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
  has(i,"txt");has(i,"all");has(i,"x");has(i,"y")}

func ColsAdd(i,a,      c,x) {
  for(c in a) {
    x = a[c]
    if(x ~ /\?/) continue 
    i["txt"][c] = x
    if(x ~ /!/) i["class"] = c
    i["all"][c]
    (x ~ /[!<>]/) ? i["y"][c] : i["x"][c] }}

func Nb(i,f) {
   i["is"] = "Nb"
   i["Min"]   = 5  # tuning param
   i["K"]     = 2  # tuning param
   i["M"]     = 1  # tuning param
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

func NbLike(i,row,y, n,    prior,like,c,x,f) {
  prior = like = (n + i["K"])/(i["nall"] + i["K"]*length(i["seen"]))
  like  = log(like)
  for(c in i["cols"]["x"]) {
      x = row[c]
      if(x != "?") {
        f = i["seen"][y][c][x] 
        like +=  log((f + i["M"]*prior) / (n + i["M"])) }}
  return like }

func NbMostLiked(i,row,     y,like,most,out) {
  most = -10^32
  for(y in i["seen"]) {
    out = out ? out : y
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

