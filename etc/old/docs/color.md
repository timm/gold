[home](https://github.com/timm/gold/blob/master/README.md) ::
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
<img align=right width=350 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
# GOLD = a Gawk Object Layer

[home](http://github.com/timm/gold/README.me) ::
[lib] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer
----- 

```awk
function color(x,f,b) { 
  b = b?b:"default"
  f = f?f:"red"
  return "\033["GOLD.back[b]"m\033["GOLD.fore[f]"m"x"\033[0m" 
}
BEGIN {
  GOLD.fore.black= 30;        GOLD.fore.red= 31;         GOLD.fore.green= 32
  GOLD.fore.yellow= 33;       GOLD.fore.blue= 34;        GOLD.fore.magenta= 35
  GOLD.fore.cyan= 36;         GOLD.fore.gray= 37;        GOLD.fore.darkgray= 90
  GOLD.fore.litered= 91;      GOLD.fore.litegreen= 92;   GOLD.fore.lityellow= 93
  GOLD.fore.liteblue= 94;     GOLD.fore.litemagenta= 95; GOLD.fore.litecyan= 96
  GOLD.fore.white= 97;        GOLD.back.default= 49;     GOLD.back.black= 40
  GOLD.back.red= 41;          GOLD.back.green= 42;       GOLD.back.yellow= 43
  GOLD.back.blue= 44;         GOLD.back.magenta= 45;     GOLD.back.cyan= 46
  GOLD.back.gray= 47;         GOLD.back.darkgray= 100;   GOLD.back.litered= 101
  GOLD.back.litegreen= 102;   GOLD.back.liteyellow= 103; GOLD.back.liteblue= 104
  GOLD.back.litemagenta= 105; GOLD.back.litecyan= 106;   GOLD.back.white= 107
}

function ok_color(   b,f) {
  for(b in GOLD.back) {
    print b
    for(f in GOLD.fore)
      printf("%s", color(f,f,b))
    print("")  
}}
```

```awk
BEGIN {ok_color() }
```
