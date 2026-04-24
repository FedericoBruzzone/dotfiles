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
plugins=(git zsh-autosuggestions)

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


#################################################
#################################################
#################################################


# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Homebrew configuration {
    export PATH="/usr/local/sbin:$PATH"
# }


# openvpn configuration {
if [[ "$OSTYPE" == "darwin"* ]]; then
 if [[ "$(uname -m)" == "arm64" ]]; then
     export PATH="/opt/homebrew/opt/openvpn/sbin/:$PATH"
 else
     export PATH="/usr/local/opt/openvpn/sbin/:$PATH"
 fi
fi
# }



# dotfiles bin {
    export PATH="$HOME/.bin:$PATH"
# }

# Svn configuration {
 export SVN_EDITOR=nvim
# }

# rust configuration {
 . "$HOME/.cargo/env"
# }

# python3.13 configuration {
 # export PATH="/usr/local/opt/python/libexec/bin:$PATH"
 # export PATH="/usr/local/Cellar/python@3.13/3.13.9/libexec/bin:$PATH"
 export PATH="/usr/local/Cellar/python@3.11/3.11.14_1/libexec/bin:$PATH"
# }


# openjdk21 configuration {
 # macOS Intel {
  # If you need to have openjdk@21 first in your PATH, run:
  # export PATH="/usr/local/opt/openjdk@21/bin:$PATH"
  # It could be an alternative to exporting JAVA_HOME
  #
  # For compilers to find openjdk@21 you may need to set:
  # export CPPFLAGS="-I/usr/local/opt/openjdk@21/include"

  # On macOS, you can set the JAVA_HOME environment variable to point to the JDK installation only after the following command:
  #
  # For the system Java wrappers to find this JDK, symlink it with
  # ```
  # sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  # ```
  # It allows `/usr/libexec/java_home -v 21` to find the JDK
 # }
 # macOS Silicon {
  # For the system Java wrappers to find this JDK, symlink it with
  #   sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  #
  # openjdk@21 is keg-only, which means it was not symlinked into /opt/homebrew,
  # because this is an alternate version of another formula.
  #
  # If you need to have openjdk@21 first in your PATH, run:
  #   echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
  #
  # For compilers to find openjdk@21 you may need to set:
  #   export CPPFLAGS="-I/opt/homebrew/opt/openjdk@21/include"
 # }
 export JAVA_HOME=$(/usr/libexec/java_home -v 21)
# }

# latex configuration {
 # export PATH=$PATH:/usr/local/texlive/2025/bin/universal-darwin
 export BIBINPUTS=$HOME/texmf/tex/latex/adapt-lab/trunk/bibs:.

 l4p() {  # it assumes to have $BIBINPUTS set and with the dir to look into as the first one
   BIB_DIR=${BIBINPUTS%%:*}
   grep -rin"$2" -ie "$1" "$BIB_DIR"/*.bib
 }
# }

# eval $(opam env --switch=default)
# opam configuration {
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/federicobruzzone/.opam/opam-init/init.zsh' ]] || source '/Users/federicobruzzone/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# Allows GSettings to find the schemas installed via Homebrew
export GSETTINGS_SCHEMA_DIR="/opt/homebrew/share/glib-2.0/schemas"
# Merge XDG_DATA_DIRS with opam share directory
export XDG_DATA_DIRS="/opt/homebrew/share:$(opam var share):$XDG_DATA_DIRS"

# }

# perl configuration {
if [[ "$OSTYPE" == "darwin"* ]]; then
 if [[ "$(uname -m)" == "arm64" ]]; then
  # By default non-brewed cpan modules are installed to the Cellar. If you wish
  # for your modules to persist across updates we recommend using `local::lib`.

  # You can set that up like this:
  # PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib

  # And add the following to your shell profile e.g. ~/.profile or ~/.zshrc
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
 else
  # Do not use system perl (/usr/local/bin/perl), use the one installed via brew
  export PATH=/usr/local/opt/perl/bin:$PATH
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
 fi
fi
# }

# # llvm@16 configuration {
#  # To use the bundled libc++ please add the following LDFLAGS:
#  export LDFLAGS="-L/usr/local/opt/llvm@16/lib/c++ -Wl,-rpath,/usr/local/opt/llvm@16/lib/c++"
#
#  # If you need to have llvm@16 first in your PATH, run:
#  export PATH="/usr/local/opt/llvm@16/bin $PATH"
#
#  # For compilers to find llvm@16 you may need to set:
#  export LDFLAGS="-L/usr/local/opt/llvm@16/lib:$LDFLAGS"
#  export CPPFLAGS="-I/usr/local/opt/llvm@16/include"
# # }

# # llvm@18 configuration {
#  # To use the bundled libc++ please add the following LDFLAGS:
#  export LDFLAGS="-L/usr/local/opt/llvm@18/lib/c++ -L/usr/local/opt/llvm@18/lib -lunwind"
#
#  # If you need to have llvm@18 first in your PATH, run:
#  export PATH="/usr/local/opt/llvm@18/bin:$PATH"
#
#  # For compilers to find llvm@18 you may need to set:
#  export LDFLAGS="-L/usr/local/opt/llvm@18/lib $LDFLAGS"
#  export CPPFLAGS="-I/usr/local/opt/llvm@18/include"
# # }

# llvm@20 configuration {
# if [[ "$OSTYPE" == "darwin"* ]]; then
#  if [[ "$(uname -m)" == "arm64" ]]; then
#   # Using `clang`, `clang++`, etc., requires a CLT installation at `/Library/Developer/CommandLineTools`.
#   # If you don't want to install the CLT, you can write appropriate configuration files pointing to your
#   # SDK at ~/.config/clang.
#   #
#   # To use the bundled libunwind please use the following LDFLAGS:
#   #   LDFLAGS="-L/opt/homebrew/opt/llvm@20/lib/unwind -lunwind"
#   #
#   # To use the bundled libc++ please use the following LDFLAGS:
#   #   LDFLAGS="-L/opt/homebrew/opt/llvm@20/lib/c++ -L/opt/homebrew/opt/llvm@20/lib/unwind -lunwind"
#   #
#   # NOTE: You probably want to use the libunwind and libc++ provided by macOS unless you know what you're doing.
#   #
#   # llvm@20 is keg-only, which means it was not symlinked into /opt/homebrew,
#   # because this is an alternate version of another formula.
#   #
#   # If you need to have llvm@20 first in your PATH, run:
#   #   echo 'export PATH="/opt/homebrew/opt/llvm@20/bin:$PATH"' >> ~/.zshrc
#   #
#   # For compilers to find llvm@20 you may need to set:
#   #   export LDFLAGS="-L/opt/homebrew/opt/llvm@20/lib"
#   #   export CPPFLAGS="-I/opt/homebrew/opt/llvm@20/include"
#   #
#   # For cmake to find llvm@20 you may need to set:
#   #   export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm@20"
#   export PATH="/opt/homebrew/opt/llvm@20/bin:$PATH"
#   export LDFLAGS="-L/opt/homebrew/opt/llvm@20/lib/unwind -lunwind"
#   export LDFLAGS="-L/opt/homebrew/opt/llvm@20/libc++ -L/opt/homebrew/opt/llvm@20/lib $LDFLAGS"
#   export CPPFLAGS="-I/opt/homebrew/opt/llvm@20/include"
#  else
#   export PATH="/usr/local/opt/llvm@20/bin:$PATH"
#   export LDFLAGS="-L/usr/local/opt/llvm@20/lib/unwind -lunwind"
#   export LDFLAGS="-L/usr/local/opt/llvm@20/lib/c++ -L/usr/local/opt/llvm@20/lib $LDFLAGS"
#   export CPPFLAGS="-I/usr/local/opt/llvm@20/include"
#  fi
# fi
# }

# llvm@22 configuration {
# if [[ "$OSTYPE" == "darwin"* ]]; then
#  if [[ "$(uname -m)" == "arm64" ]]; then
#   # Using `clang`, `clang++`, etc., requires a CLT installation at `/Library/Developer/CommandLineTools`.
#   # If you don't want to install the CLT, you can write appropriate configuration files pointing to your
#   # SDK at ~/.config/clang.
#   #
#   # To use the bundled libunwind please use the following LDFLAGS:
#   #   LDFLAGS="-L/opt/homebrew/opt/llvm@22/lib/unwind -lunwind"
#   #
#   # To use the bundled libc++ please use the following LDFLAGS:
#   #   LDFLAGS="-L/opt/homebrew/opt/llvm@22/lib/c++ -L/opt/homebrew/opt/llvm@22/lib/unwind -lunwind"
#   #
#   # NOTE: You probably want to use the libunwind and libc++ provided by macOS unless you know what you're doing.
#   #
#   # llvm is keg-only, which means it was not symlinked into /opt/homebrew,
#   # because this is an alternate version of another formula.
#   #
#   # If you need to have llvm first in your PATH, run:
#   #   echo 'export PATH="/opt/homebrew/opt/llvm@22/bin:$PATH"' >> ~/.zshrc
#   #
#   # For compilers to find llvm you may need to set:
#   #   export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#   #   export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
#   #
#   # For cmake to find llvm you may need to set:
#   #   export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
#   export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#   export LDFLAGS="-L/opt/homebrew/opt/llvm@22/lib/unwind -lunwind"
#   export LDFLAGS="-L/opt/homebrew/opt/llvm@22/libc++ -L/opt/homebrew/opt/llvm@22/lib $LDFLAGS"
#   export CPPFLAGS="-I/opt/homebrew/opt/llvm@22/include"
#  else
#   export PATH="/usr/local/opt/llvm@22/bin:$PATH"
#   export LDFLAGS="-L/usr/local/opt/llvm@22/lib/unwind -lunwind"
#   export LDFLAGS="-L/usr/local/opt/llvm@22/lib/c++ -L/usr/local/opt/llvm@22/lib $LDFLAGS"
#   export CPPFLAGS="-I/usr/local/opt/llvm@22/include"
#  fi
# fi
# }

# llvm latest configuration {
if [[ "$OSTYPE" == "darwin"* ]]; then
 if [[ "$(uname -m)" == "arm64" ]]; then
  # Using `clang`, `clang++`, etc., requires a CLT installation at `/Library/Developer/CommandLineTools`.
  # If you don't want to install the CLT, you can write appropriate configuration files pointing to your
  # SDK at ~/.config/clang.
  #
  # To use the bundled libunwind please use the following LDFLAGS:
  #   LDFLAGS="-L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
  #
  # To use the bundled libc++ please use the following LDFLAGS:
  #   LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
  #
  # NOTE: You probably want to use the libunwind and libc++ provided by macOS unless you know what you're doing.
  #
  # llvm is keg-only, which means it was not symlinked into /opt/homebrew,
  # because this is an alternate version of another formula.
  #
  # If you need to have llvm first in your PATH, run:
  #   echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
  #
  # For compilers to find llvm you may need to set:
  #   export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
  #   export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
  #
  # For cmake to find llvm you may need to set:
  #   export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
  export LDFLAGS="-L/opt/homebrew/opt/llvm/libc++ -L/opt/homebrew/opt/llvm/lib $LDFLAGS"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
 else
  export PATH="/usr/local/opt/llvm/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/llvm/lib/unwind -lunwind"
  export LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -L/usr/local/opt/llvm/lib $LDFLAGS"
  export CPPFLAGS="-I/usr/local/opt/llvm/include"
 fi
fi
# }



# koka configuration {
 export PATH=$PATH:$HOME/.local/bin
# }

# yazi configuration {
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
# }

# nlgc bin path {
# export PATH=$PATH:$HOME/thirdparty/nlg3/target/release/
# }

# valging bin path {
export PATH=$HOME/valgrind-install/bin:$PATH
# }

# local tgt configuration
export LOCAL_TDLIB_PATH=$HOME/tdlib

# tdlib-rs configuration (for test purposes)
export API_ID="94575"
export API_HASH="a3406de8d171bb422bb6ddf3bbd800e2"

# Function to convert SVG to PDF using rsvg-convert
svg-convert () {
  # Check if a filename was provided
  if [ -z "$1" ]; then
    echo "Error: You must specify an SVG input file."
    echo "Usage: svg-convert input_file.svg"
    return 1
  fi

  # Extracts the base name of the file (e.g., "my_drawing" from "my_drawing.svg")
  BASE_NAME=$(basename "$1" .svg)

  # Execute the conversion
  # "$1" is the input file (e.g., my_drawing.svg)
  # "${BASE_NAME}.pdf" is the output file (e.g., my_drawing.pdf)
  rsvg-convert -f pdf -o "${BASE_NAME}.pdf" "$1"
}
