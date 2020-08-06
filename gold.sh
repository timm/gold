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
	   awk -f x     = gold --all; AWKPATH='$Sh/.var' gawk -f $Sh/.var/gold.awk -f x 
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
mkdir -p $Sh/.var $Sh/src $Sh/tests $Sh/etc

transpiles() {
  dot=$1; shift
  if [ -n "$*" ]; then
    for i in $*; do 
      j=$(basename $i .gold).awk
      k=$Sh/.var/$j
      echo -n $dot >&2
      cat $i |
      gawk -f $Sh/.var/gold.awk --source '{use=gold2awk(use) }' > $k
    done
  fi
} 

go() {
  j=$Sh/.var/${2%.gold}.awk
  shift; shift;
  AWKPATH="$Sh/.var:$AWKPATH"
  Com="gawk -f $Sh/.var/gold.awk -f $j $*"
  if  [ -t 0 ]; then AWKPATH="$AWKPATH" $Com
  else       cat - | AWKPATH="$AWKPATH" $Com
  fi
  exit $?
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

wget --quiet -O /tmp/master.zip https://github.com/timm/gold/archive/master.zip

exists() {
  if [ ! -f "$1" ]; then
    unzip -p /tmp/master.zip gold-master/etc/$2 > $1
  fi
}

exists $Sh/.var/gold.awk gold.awk
exists $Sh/.gitignore gitignore
exists $Sh/.var/tmuxrc tmuxrc
exists $Sh/.var/bashrc bashrc
exists $Sh/.var/vimrc vimrc
if [ ! -d "$HOME/.vim/bundle" ]; then
   git clone https://github.com/VundleVim/Vundle.vim.git \
         ~/.vim/bundle/Vundle.vim
   vim -u $Sh/.var/vimrc  +PluginInstall +qall
fi


