#!/usr/bin/env bash
Lib=$HOME/opt/gold/lib
hello() { tput bold; tput setaf 6; cat<<"EOF"
           .--.
         / ,~a`-,
         \ \_.-"`
          ) (
        ,/ ."\
       /  (  |   GOLD v0.4
      /   )  ;   A GAWK object layer
 jgs /   /  /    (ↄ) 2020 Tim Menzies
   ,/_."` /`     timm@ieee.org 
    /_/\ |___
       `~~~~~`   "A little auk goes a long way."

EOF
tput sgr0
}

if [ "$1" == "--help" ]; then 
        hello
        cat<<-'EOF'
	Usage:
	   sh gold.sh [options]
	
	Options:
	
	   --help        show help
	   --all         transpiles to awk any docs/*.md tests/*.md files
	   -f x.md $*  transpiles, then runs gawk  -f x.awk $*
	   --install     adds config files
	
	If run with no options, drops the user into a shell where
	the following commands are avaialble:

	   gold    = sh gold.sh
	   awk -f x     = gold --all; AWKPATH='$Sh/etc:$HOME/opt/gold:$AWKPATH' gawk -f  x 
	   gg	   = git pull
	   gp      = git commit -am saving; git push; git status
	   gs	   = git status
	   vims	   ensure all vim packags are loaded
	   vi	   calls vim using ./etc/vimrc
	   tmux	   calls tmux using ./etc/tmuxrc
		
	EOF
   exit 0
fi

Sh=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
chmod +x $Sh
mkdir -p $Lib

transpile() {
  j=$Lib/$(basename $1 .md).awk
  (cd $Sh/docs
  gawk -f $Sh/etc/gold.awk --source 'BEGIN {goldFile("'$1'")}'  > tmp$$
  cat $Sh/etc/gold.awk >> tmp$$
  gawk -o- -f tmp$$ | sed $'s/\t/  /g' > $j
  rm tmp$$
  )
} 

go() {
  j=$Lib/$(basename $1 .md).awk
  AWKPATH="$Lib:$AWKPATH"
  Com="gawk -f $j $*"
  if  [ -t 0 ]; then AWKPATH="$AWKPATH" $Com
  else       cat - | AWKPATH="$AWKPATH" $Com
  fi
  exit $?
}

if [ "$1" == "--all" ]; then
  for f in $Sh/docs/*.md;  do transpile $f; done
  exit 0
fi

if [ "$1" == "-t"   ]; then
  shift
  transpile $1
  exit $?
fi

if [ "$1" == "-f"   ]; then
  shift
  transpile $1
  go $1
  exit $?
fi

if [ "$1" == "--tests"   ]; then
  cd $Sh/docs
  for i in *ok.md; do
    sh gold.sh -f  $i
  done | gawk ' 
    1                          # a) print current line      
    /^Failure/ { err += 1 }    # b) catch current error number
    END        { exit err - 1} # c) one test is designed to fail 
                               #    (just to test the test engine)
                               #    so "pass" really means, "only
                               #    one test fails"
    '
  out="$?"
  echo "Number of problems: $out"
  exit $out
fi


if [ "$1" != "--install"   ]; then
  if [ -f "$Sh/etc/bashrc" ]; then
    hello
    Sh="$Sh" Lib="$Lib" bash --init-file $Sh/etc/bashrc -i  
  else
    echo "Missing config files. Try running sh gold.sh --install"
  fi
  exit 0
fi

echo "Installing tricks ..."
echo "Download base files ..."
wget  -q -O master.zip https://github.com/timm/gold/archive/master.zip
echo "Expanding base files ..."
unzip -q  master.zip
echo "Updating local files ..."
cp -a  -n gold-master/ .
rm -rf master.zip gold-master
chmod +x gold.sh

if [ ! -d "$HOME/.vim/bundle" ]; then
   git clone https://github.com/VundleVim/Vundle.vim.git \
         ~/.vim/bundle/Vundle.vim
   vim -u $Sh/.var/vimrc  +PluginInstall +qall
fi
