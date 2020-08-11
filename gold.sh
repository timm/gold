#!/usr/bin/env bash
hello() { tput bold; tput setaf 6; cat<<"EOF"
    __        __  __   
  /'__`\     /\ \/\ \   GOLD v0.4
 /\ \L\.\_   \ \ \_\ \    a Gawk object layer
 \ \__/.\_\   \ \____/      (ↄ) 2020 Tim Menzies
  \/__/\/_/    \/___/         timm@ieee.org
                   
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
	   -f x.md $*  transpiles, then runs gawk -f gold.awk -f x.awk $*
	   --install     adds config files for bash, vim, git, tmux to ./.var
	
	If run with no options, drops the user into a shell where
	the following commands are avaialble:

	   gold    = sh gold.sh
	   awk -f x     = gold --all; AWKPATH='$Sh/.var' gawk -f $Sh/.var/gold.awk -f x 
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
mkdir -p $Sh/.var 

transpiles() {
  dot=$1; shift
  if [ -n "$*" ]; then
    for i in $*; do 
      j=$(basename $i .md).awk
      k=$Sh/.var/$j
      echo -n $dot >&2
      cat $i |
      gawk -f $Sh/etc/gold.awk --source '{use=gold2awk(use) }' > $k
    done
  fi
} 

go() {
  j=`basename $2 .md`
  k=$Sh/.var/${j}.awk
  shift; shift;
  AWKPATH="$Sh/.var:$AWKPATH"
  Com="gawk -f $Sh/.var/gold.awk -f $k $*"
  if  [ -t 0 ]; then AWKPATH="$AWKPATH" $Com
  else       cat - | AWKPATH="$AWKPATH" $Com
  fi
  exit $?
}

if [ "$1" == "--all" ]; then
  transpiles "." $Sh/docs/*.md 
  transpiles "," $Sh/tests/*.md
  exit 0
fi

if [ "$1" == "-f"   ]; then
  transpiles "." $Sh/docs/*.md 
  transpiles "," $Sh/tests/*.md
  go $*
  exit $?
fi

if [ "$1" == "--tests"   ]; then
   set -x
  cd $Sh/tests
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
    Sh="$Sh"   bash --init-file $Sh/etc/bashrc -i  
  else
    echo "Missing config files. Try running sh gold.sh --install"
  fi
  exit 0
fi

echo "Installing tricks..."
wget  -O master.zip https://github.com/timm/gold/archive/master.zip
unzip master.zip
cp -a  -n gold-master/ .
rm -rf master.zip gold-master
chmod +x gold.sh

if [ ! -d "$HOME/.vim/bundle" ]; then
   git clone https://github.com/VundleVim/Vundle.vim.git \
         ~/.vim/bundle/Vundle.vim
   vim -u $Sh/.var/vimrc  +PluginInstall +qall
fi
