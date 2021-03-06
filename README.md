<img align=right width=400
 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/coins.png">

# GOLD= Gawk Goodies


[![DOI](https://zenodo.org/badge/237838701.svg)](https://zenodo.org/badge/latestdoi/237838701)  
![](https://img.shields.io/badge/platform-osx%20,%20linux-orange)    
![](https://img.shields.io/badge/language-gawk,bash-blue)  
![](https://img.shields.io/badge/purpose-ai%20,%20se-blueviolet)  
[![Build Status](https://travis-ci.com/timm/gold.svg?branch=master)](https://travis-ci.com/timm/gold)  
![](https://img.shields.io/badge/license-mit-lightgrey)  
[home](http://menzies.us/gold)  ::
[about](http://menzies.us/keys/about.html) ::
[lib](http://menzies.us/keys/lib.html) ::
[tips](http://menzies.us/keys/tips.html) 



Gold adds  the following goodies to standard Gawk:
        inheritance, polymorphism, encapsulation, objects, 
attributes, methods, iterators, unit tests, multi-line comments.

Interestingly,  most of that comes from:

- [13 lines of a Gawk transpiler](https://github.com/timm/gold/blob/master/gold.awk#L13-L26)
from Gold code into the standard Gawk syntax.
- About [25 lines of runtime support](https://github.com/timm/gold/blob/master/gold.awk#L28-L52)
  code.

## INSTALL:

- Install everything in [requirements.txt](requirements.txt).
- See [INSTALL.md](INSTALL.md)
 

## USAGE:

|com|notes|
|---|-----|
|  ./gold               | convert .awk files in src and test to shared|
|  ./gold -h            | as above, also prints this help text|
|  ./gold xx.awk        | as above, then runs xx.awk|
|  ./gold xx            | ditto|
|  Com \| ./gold xx.awk | as above, taking input from Com|
|  Com \| ./gold xx     | ditto|
|  . gold               |adds some bash tools to local environment|

Alternatively, to execute your source file directly using ./xx.awk,
chmod +x xx.awk and add the top line:

      #!/usr/bin/env path2gold

If called via ". gold" then the following alias are defined:

```
  Gold= directory of gold
  alias gold='$Gold/gold '              # short cut to this code
  alias gp='git add *;git commit -am save;git push;git status' # gh stuff
  alias gs='git status'                 # status 
  alias ls='ls -G'                      # ls
  alias reload='. $Gold/gold'           # reload these tools
  alias vims="vim +PluginInstall +qall" # install vim plugins 
  alias vi="vim -u $Gold/etc/.vimrc"    # run a configured vim
```  
