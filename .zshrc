# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ===== History =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# ===== Key Bindings =====
bindkey '^[[1;5C' forward-word  # Ctrl + Right Arrow
bindkey '^[[1;5D' backward-word # Ctrl + Left Arrow

# ===== Alias =====
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'

# Export ~/.bin folder
export PATH="$HOME/.bin:$PATH"

# Git configuration
alias clear_git_cache='git rm -r --cached .'  # remove all files from the git cache
alias clear_git_tags='git tag -l | xargs git tag -d'  # remove all tags from the git repository

# Svn configuration
export SVN_EDITOR=nvim

# opam configuration
[[ ! -r /home/fcb/.opam/opam-init/init.zsh ]] || source /home/fcb/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# ghcup configuration
[ -f "/home/fcb/.ghcup/env" ] && . "/home/fcb/.ghcup/env" # ghcup-env

# rust configuration
. "$HOME/.cargo/env"

# Set JAVA_HOME to the desired version
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# LLVM configuration
export PATH=$PATH:/usr/lib/llvm14/bin

# Latex configuration
export TEXEDIT="nvim +%d %s"
export PATH=$PATH:/usr/local/texlive/2024/bin/x86_64-linux
export BIBINPUTS=$HOME/texmf/tex/latex/adapt-lab/trunk/bibs:.

l4p() {  # it assumes to have $BIBINPUTS set and with the dir to look into as the first one
  BIB_DIR=${BIBINPUTS%%:*}
  grep -rin"$2" -ie "$1" "$BIB_DIR"/*.bib
}

vimbib() { # it assumes to have $BIBINPUTS set and with the dir to look into as the first one
  BIB_DIR=${BIBINPUTS%%:*}
  # local bibs=()
  # for bib in "$@"
  # do
  #    bibs+=($BIB_DIR/"$bib"".bib")
  # done
  local bibs=($@)
  bibs=("${bibs[@]/%/.bib}")
  bibs=( "${bibs[@]/#/$BIB_DIR/}" )
  echo "${bibs[@]}"

  vim -p "${bibs[@]}"
}

# tgt
alias tgt='~/dev/tgt/target/release/tgt'

# tgt
export LOCAL_TDLIB_PATH=$HOME/lib/tdlib

# Telegram API configuration
# export API_ID="94575"
# export API_HASH="a3406de8d171bb422bb6ddf3bbd800e2"

# pkg-config configuration
# export PKG_CONFIG_PATH=$HOME/lib/tdlib/lib/pkgconfig/:$PKG_CONFIG_PATH

# dynmic linker configuration
# export LD_LIBRARY_PATH=$HOME/lib/tdlib/lib/:$LD_LIBRARY_PATH

# Alias for the bare git repository for dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Start Docker
# systemctl start docker

pkgsize(){
    pacman -Ss $@ | awk '{if(NR%2) {system("pacman -Si "$1" | grep Ins | cut -d\":\" -f 2 | tr -d \" \n\" "" "); printf " "$1"$";} else print $0}' | sort -h | tr "$" "\n"
}

