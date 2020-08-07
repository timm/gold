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
	   vi	   calls vim using ./.var/vimrc
	   tmux	   calls tmux using ./.var/tmuxrc
		
	EOF
   exit 0
fi

Sh=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
chmod +x $Sh
mkdir -p $Sh/.var $Sh/docs $Sh/tests 

transpiles() {
  dot=$1; shift
  if [ -n "$*" ]; then
    for i in $*; do 
      j=$(basename $i .md).awk
      k=$Sh/.var/$j
      echo -n $dot >&2
      cat $i |
      gawk -f $Sh/.var/gold.awk --source '{use=gold2awk(use) }' > $k
    done
  fi
} 

go() {
  j=`basename $2 .md`
  k=$Sh/.var/$j.awk
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
  sh $Sh/gold.sh --install
  sh $Sh/gold.sh --all
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
  if [ -f "$Sh/.var/bashrc" ]; then
    hello
    Sh="$Sh"   bash --init-file $Sh/.var/bashrc -i  
  else
    echo "Missing config files. Try running sh gold.sh --install"
  fi
  exit 0
fi

echo "Installing tricks..."

##########################################
want=$Sh/.var/bashrc
[ -f "$want" ] || cat<<'EOF' > $want
reload() {
  rm $Sh/.var/*rc $Sh/.gitgnore
  sh $Sh/md.sh --install
  . $Sh/.var/bashrc
}


alias awk="gold --all; AWKPATH='$Sh/.var:$AWKPATH'  gawk -f $Sh/gold.awk "
alias gold="bash $Sh/gold.sh "
alias gg="git pull"   
alias gs="git status"   
alias gp="git commit -am 'saving'; git push; git status"    

matrix() { nice -20 cmatrix -b -C cyan;   }
vims()   { vim -u $Sh/.var/vimrc +PluginInstall +qall; }

alias vi="vim    -u $Sh/.var/vimrc"
alias tmux="tmux -f $Sh/.var/tmuxrc"

here()  { cd $1; basename `pwd`; }    

PROMPT_COMMAND='echo -ne "🔆 79º $(git branch 2>/dev/null | grep '^*' | colrm 1 2):";PS1="$(here ..)/$(here .):\!\e[m ▶ "'     
EOF

##########################################
want=$Sh/.travis.yml
[ -f "$want" ] || cat<<'EOF' > $want
language: C

sudo: true

install:
  - wget -O gawk.tar.gz https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.gz
  - tar xzf gawk.tar.gz
  - cd gawk-5.1.0
  - ./configure; sudo make; sudo make install
  - cd ..


script:
  - chmod +x gold.sh
  - sh gold.sh --tests

EOF
##########################################
want=$Sh/docs/index.md
[ -f "$want" ] || cat<<'EOF' > $want
---
title: 'Hello!'
---

#  Hello

<img src="https://pngimg.com/uploads/gold/gold_PNG11033.png">

EOF

##########################################
want=$Sh/.var/gold.awk 
[ -f "$want" ] || cat<<'EOF' > $want
function gold2awk(use) {
  if (gsub(/^```awk/,"")) use= 1
  if (gsub(/^```/,  "")) use= 0
  if (use) 
    print gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/,
                  "[\"\\1\\2\"]","g",$0);
  else 
    print "# " $0
  return use
}

function tests(what, all,   f,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { 
    srand(1)
    f = a[i]; 
    @f(f) 
  }
  rogues()
}

function ok(f,yes,    msg) {
  msg = yes ? "PASSED!" : "FAILED!"
  if (yes) 
     GOLD["test"]["yes"]++ 
  else
     GOLD["test"]["no"]++;
  print "#test:\t" msg "\t" f
}

function within(x,lo,hi) { return x >= lo && x <= hi }

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) print "#W> Rogue: " s>"/dev/stderr"
}

function Obj(i)  { 
  List(i)
  i["ois"]= "Obj"
  i["oid"] = ++GOLD["oid"] 
}

function List(i)    { split("",i,"") }

function has(i,k,f,   s) { 
  if (!f) f = "List"               # ensure we are creating something
  if (!k) k = length(i)+1          # ensure we have a place to put it
  i[k]["\001"]; delete i[k]["\001"] # ensure we adding to a sulist
  @f(i[k])                         # create
  return k                         # return where we put it
}

function is(i,f1,f2) {
  if (f2) @f2(i)
  if ("ois" in i) { GOLD["ois"][f1] = i["ois"] }
  i["ois"] = f1
}

function inherit(s,f,   g) {
  while(s) {
    g = s f
    if (g in FUNCTAB) return g
    s = GOLD["ois"][s] # look upward in the class hierarchy
  }
  print "#E> failed method lookup: ["f"]"
  exit 2
}

function isa(f,a) {
  if (isarray(a) && "ois" in a && "oid" in a && 
      f==a["ois"] && a["ois"] in FUNCTAB) {
       if (GOLD["brave"])
         return 1
       else {
         while(f) { 
           if (isa1(f, a)) 
             return 1
           f = GOLD["ois"][f] }}}
  return 0
}

function isa1(f,a,   b) { @f(b); return isa2(a,b) }

function isa2(a,b,     j) {
  if (isarray(a) && isarray(b)) {
    for(j in b) 
      if ( ! isa2(a[j], b[j]) ) 
        return 0
  } else {
      if (typeof(a) != typeof(b)) 
        return 0 
  }
  return 1
}
EOF

##########################################
want=$Sh/.gitignore
[ -f "$want" ] || cat<<'EOF' > $want
.var
## VIM ###

# Swap
[._]*.s[a-v][a-z]
!*.svg  # comment out if you don't need vector files
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]

# Session
Session.vim
Sessionx.vim

# Temporary
.netrwhist
*~
# Auto-generated tag files
tags
# Persistent undo
[._]*.un~

### Macos ###

# General
.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Python
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# PEP 582; used by e.g. github.com/David-OConnor/pyflow
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/
EOF
##########################################

want=$Sh/.var/tmuxrc
[ -f "$want" ] || cat<<'EOF' > $want
set -g aggressive-resize on
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix
set -g base-index 1
# start with pane 1
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %
# open new windows in the current path
bind c new-window -c "#{pane_current_path}"
# reload config file
bind r source-file $Tnix/.config/dottmux
unbind p
bind p previous-window
# shorten command delay
set -sg escape-time 1
# don't rename windows automatically
set-option -g allow-rename off
# mouse control (clickable windows, panes, resizable panes)
set -g mouse on
# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# enable vi mode keys
set-window-option -g mode-keys vi
# set default terminal mode to 256 colors
set -g default-terminal "screen-256color"
bind-key u capture-pane \;\
    save-buffer /tmp/tmux-buffer \;\
    split-window -l 10 "urlview /tmp/tmux-buffer"
bind P paste-buffer
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
# loud or quiet?
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none
#  modes
setw -g clock-mode-colour colour5
# panes
# statusbar
set -g status-position top
set -g status-justify left
set -g status-bg colour232
set -g status-fg colour137
###set -g status-attr dim
set -g status-left ''
set -g status-right '#{?window_zoomed_flag,🔍,} #[fg=colour255,bold]#H #[fg=colour255,bg=colour19,bold] %b %d #[fg=colour255,bg=colour8,bold] %H:%M '
set -g status-right '#{?window_zoomed_flag,🔍,} #[fg=colour255,bold]#H '
set -g status-right-length 50
set -g status-left-length 20
setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
# messages
# layouts
bind S source-file $Tnix/.config/tmux-session1
setw -g monitor-activity on
set -g visual-activity on
EOF
##########################################

want=$Sh/.var/vimrc
[ -f "$want" ] || cat<<'EOF' > $want
set list
set listchars=tab:>-
set backupdir-=.
set backupdir^=~/tmp,/tmp
set nocompatible
"filetype plugin indent on
set modelines=3
set scrolloff=3
set autoindent
set hidden "remember ls
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set backspace=indent,eol,start
set laststatus=2
set splitbelow
set paste
set mouse=a
set title
set number
set relativenumber
autocmd BufEnter * cd %:p:h
set showmatch
set matchtime=15
set background=light
set syntax=on
syntax enable
set ignorecase
set incsearch
set smartcase
set showmatch
set hlsearch
set nofoldenable    " disable folding
set ruler
set laststatus=2
set statusline=
set statusline+=%F
set statusline+=\ 
set statusline+=%m
set statusline+=%=
set statusline+=%y
set statusline+=\ 
set statusline+=%c
set statusline+=:
set statusline+=%l
set statusline+=\ 
set lispwords+=defthing
set lispwords+=doitems
set lispwords+=deftest
set lispwords+=defkeep
set lispwords+=labels
set lispwords+=labels
set lispwords+=doread
set lispwords+=while
set lispwords+=until
set path+=../**
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
colorscheme default
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
map Z 1z=
set spell spelllang=en_us
set spellsuggest=fast,20 "Don't show too much suggestion for spell check
nn <F7> :setlocal spell! spell?<CR>
let g:vim_markdown_fenced_languages = ['awk=awk']
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'tbastos/vim-lua'
Plugin 'airblade/vim-gitgutter'
"Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf'
"  Plugin 'humiaozuzu/tabbar'
"  Plugin 'drmingdrmer/vim-tabbar'
Plugin 'tomtom/tcomment_vim'
Plugin 'ap/vim-buftabline'
Plugin 'junegunn/fzf.vim'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nvie/vim-flake8'
Plugin 'seebi/dircolors-solarized'
Plugin 'nequo/vim-allomancer'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tell-k/vim-autopep8'
Plugin 'vimwiki/vimwiki'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-markdown'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
let g:autopep8_indent_size=2
let g:autopep8_max_line_length=70
let g:autopep8_on_save = 1
let g:autopep8_disable_show_diff=1
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
colorscheme jellybeans
map <C-o> :NERDTreeToggle<CR>
nnoremap <Leader><space> :noh<cr>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
set titlestring=%{expand(\"%:p:h\")}
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
        set fillchars=vert:\|
hi VertSplit cterm=NONE
set ts=2
set sw=2
set sts=2
 set et
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
set formatoptions-=t
set nowrap
" Markdown
let g:markdown_fenced_languages = ['awk','py=python']
EOF

if [ ! -d "$HOME/.vim/bundle" ]; then
   git clone https://github.com/VundleVim/Vundle.vim.git \
         ~/.vim/bundle/Vundle.vim
   vim -u $Sh/.var/vimrc  +PluginInstall +qall
fi
