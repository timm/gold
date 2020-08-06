#!/usr/bin/env bash
hello() { tput bold; tput setaf 6; cat<<"EOF"
   ________      __      
  /\_____  \   /'_ `\   GOLD v0.4
  \/___//'/'  /\ \L\ \   a Gawk object layer
      /' /'   \ \___, \   (ↄ) 2020 Tim Menzies
    /' /'      \/__,/\ \   timm@ieee.org
   /\_/             \ \_\
   \//               \/_/

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
	   --all         transpiles to awk any src/*.gold tests/*.gold files
	   -f x.gold $*  transpiles, then runs gawk -f gold.awk -f x.awk $*
	   --install     adds config files for bash, vim, git, tmux to ./.var
	
	If run with no options, drops the user into a shell where
	the following commands are avaialble:

	   gold    = sh gold.sh
	   awk -f x     = gold --all; AWKPATH='$Sh/.var' gawk -f $Sh/gold.awk -f x 
	   gg	   = git pull
	   gp      = git commit -am saving; git push; git status
	   gs	   = git status
	   vims	   ensure all vim packags are loaded
	   vi	   calls vim using ./.var/vimrc
	   tmux	   calls tmux using ./.var/tmuxrc
		
	EOF
   exit 0
fi

Sh=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
chmod +x $Sh
mkdir -p $Sh/.var $Sh/src $Sh/tests

transpiles() {
  dot=$1; shift
  if [ -n "$*" ]; then
    for i in $*; do 
      j=$(basename $i .gold).awk
      k=$Sh/.var/$j
      echo -n $dot >&2
      cat $i |
      gawk -f $Sh/gold.awk --source '{use=gold2awk(use) }' > $k
    done
  fi
} 

go() {
  j=$Sh/.var/${2%.gold}.awk
  shift; shift;
  AWKPATH="$Sh/.var:$AWKPATH"
  Com="gawk -f $Sh/gold.awk -f $j $*"
  if  [ -t 0 ]; then AWKPATH="$AWKPATH" $Com
  else       cat - | AWKPATH="$AWKPATH" $Com
  fi
}


if [ "$1" == "--all" ]; then
  transpiles "." $Sh/src/*.gold 
  transpiles "," $Sh/tests/*.gold
  exit 0
fi

if [ "$1" == "-f"   ]; then
  transpiles "." $Sh/src/*.gold 
  transpiles "," $Sh/tests/*.gold
  go $*
  exit $?
fi

if [ "$1" != "--install"   ]; then
  if [ -f "$Sh/.var/bashrc" ]; then
    hello
    Sh="$Sh"   bash --init-file $Sh/.var/bashrc -i  
  else
    echo "Missing config files. Try running sh gold.sh --install"
  fi
  exit 0
fi

echo "Installing tricks..."

vims() {
  if [ ! -d "$HOME/.vim/bundle" ]; then
   git clone https://github.com/VundleVim/Vundle.vim.git \
         ~/.vim/bundle/Vundle.vim
   vim -u $Sh/.var/vimrc  +PluginInstall +qall
fi
}

exists() {
  [ -f "$1" ] || wget --queit -O $1 \
  https://raw.githubusercontent.com/timm/misc/txt/se20/master/$2
}

exists $Sh/.var/bashrc etc/bashrc
exists $Sh/.var/vimrc etc/vimrc
vims
exists $Sh/.gitignore etc/gitignore
exists $Sh/.var/tmuxrc etc/tmuxrc

