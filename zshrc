# Set our zsh theme
ZSH_THEME="candy"

# Setup oh-my-zsh path var
export ZSH=~/.oh-my-zsh

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Allow for key repeat hjkl inside macvim
# defaults write org.vim.MacVim ApplePressAndHoldEnabled false
# defaults write org.vim.MacVim.LSSharedFileList ApplePressAndHoldEnabled false

# Empty trash since mac shortcut doesn't work
alias tempty="sudo rm -rf ~/.Trash/*"

# In terminal quick open sys pref
alias spref="open 'x-apple.systempreferences:'"

# Add rename tool
function __rename {
  if [ -z "$2" ]; then
    # display usage if no parameters given
    echo "Usage: rename <from_string> [to_string]"
    echo "NOTE: to_string param is optional"
  else
    # Command that will replace the text
    replace_string="sed -e s/$2/$3/g"
    # Command that will return an array of files
    file_array="find . -maxdepth 1 -type f"
    if [[ $1 == "dry" ]]; then
      echo "[START DRY RUN]"
      echo "Actions that would have been ran..."
      for filename in `eval $file_array`; do
        echo "mv $filename" "$(echo $filename | eval $replace_string)"
      done
      echo "[END DRY RUN]"
    else
      for filename in `eval $file_array`; do
        mv "$filename" "$(echo $filename | eval $replace_string)"
      done
    fi
  fi
}

alias rename='__rename no_dry'
alias rename_dry='__rename dry'

# Make `which` find lookup tree
alias which='which -a'

# Finds the first true lookup (a non aliased lookup)
# You can add a second arg to it like --version or -v
function __dowhich {
  tcmd="$(which $1 | sed -n '2p' | tr -d '\n')"
  "$tcmd" "$2"
}

alias dowhich='__dowhich'

# -- Begin Prompt configuration --

# Colors - Color White, etc
export CB=$'%{$fg[blue]%}'
export CBB=$'%{$fg_bold[blue]%}'
export CBG=$'%{$fg_bold[green]%}'
export CW=$'%{$fg[white]%}'

# Reset
export RS=$'%{$reset_color%}'

# Newline
export NL=$'\n'

# Modify the prompt to contain git branch name if applicable
git_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " ${CBG}${current_branch}${RS}"
  fi
}

# Enable prompt substitution
setopt promptsubst

# Executed before each prompt print
precmd() {
  # Where Local and Where Remote
  export WL=$'%{$fg_bold[green]%}[LOCAL] '
  export WR=$'%{$fg_bold[green]%}%n@%m '

  # Datetime print
  export DT=$'%D{[%X]} '

  # Folder print
  export FP=$'[%3/] '

  # Git Prompt print
  export GP=$'$(git_prompt_info) '

  # Command Prompt
  export CP="${CB}->${CBB} %# ${RS}"

  # Main Prompt
  export MP="${CB}${DT}${RS}${GP}${NL}${CW}${FP}${NL}${CP}"
}

# If we are on our own computer show [LOCAL]
remote_vs_local_display () {
  if [[ ${(%):-%m} = "Adams-MBP" ]]; then
    PS1="${WL}${MP}"
  else
    PS1="${WR}${MP}"
  fi
}

# Enable precmd functions
typeset -a precmd_functions
precmd_functions+=(remote_vs_local_display)

# -- End Prompt configuration --

# Enable fish like autocompletion and git plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable emscripten
#source "$HOME/SDKs/emsdk_portable/emsdk_env.sh"

# Add Android sdk tools to path
export PATH="$HOME/.bin:$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/platform-tools:$PATH"

# Add any cargo installed binaries to path (Multirust)
export PATH="$HOME/.multirust/toolchains/stable/cargo/bin:$PATH"

# Add any rbenv installed global gems to path
export PATH="$HOME/.rbenv/bin:$PATH"

# Add /usr/local/sbin to path
export PATH="/usr/local/sbin:$PATH"

# Add /usr/local/bin to path
export PATH="/usr/local/bin:$PATH"

# Add php 5.6 to path
export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"

# Add any .bin binaries to path
export PATH="$HOME/.bin:$PATH"

# Needed for the Nix installer
#if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi

# Elixir
alias mi='mix deps.get'
alias mu='mix local.hex'

alias mpn='mix phoenix.new'
alias mpnw='mix phoenix.new --no-brunch'
alias mpnv='mix phoenix.new -v'

alias ms='mix phoenix.server'
alias mgm='mix phoenix.gen.model'

alias mec='mix ecto.create'
alias mem='mix ecto.migrate'

# DO NOT INSTALL NVM USING BREW
# BC: https://github.com/creationix/nvm/issues/856

# Source nvm setup
export NVM_DIR="/Users/afaur/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Autoexec nvm switch
setnvm() {
 if [ "$PWD" != "$MYOLDPWD" ]; then
   MYOLDPWD="$PWD";
   if [ -e "$PWD/.nvmrc" ]; then
     nvm use
   fi
 fi
}

function cd () { builtin cd "$@" && setnvm; }

# Quickly npm install with nvm exec checker
alias ni='nvm use && npm install'

# Quickly npm run with nvm exec checker
alias nr='nvm use && npm run'

# Setup autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Setup RBENV
eval "$(rbenv init -)"

# Quickly bundle install
alias bi='bundle install'

# Instead of installing binstubs, alias be to be bundle exec
alias be='bundle exec'

# Alias irb to pry.  If pry is not installed then run irb.
alias irb='pry 2> /dev/null && return 0 || irb'

# Setup RubyMotion SDKs
export RUBYMOTION_ANDROID_SDK="$HOME/.rubymotion-android/sdk"
export RUBYMOTION_ANDROID_NDK="$HOME/.rubymotion-android/ndk"

# Setup Go
export PATH="$PATH:$HOME/Scratch/GOTESTS/bin" # Add RVM to PATH for scripting
export GOPATH=/Users/afaur/Scratch/GOTESTS

# Setup Haskell
export PATH="$HOME/Library/Haskell/bin:$PATH"

# Setup OCaml - OPAM configuration
. /Users/afaur/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# Debugging cargo issue
alias cargo-get="while cargo run; do :; done"

# VIM
alias myvim="/usr/local/Cellar/macvim/7.4-106/MacVim.app/Contents/MacOS/Vim"
alias vim="myvim -w ~/vimlog"
alias v="vim"

# TMUX
export DISABLE_AUTO_TITLE='true'
alias tm="tmuxp load ~/tmux.yaml"

# NESH
alias esrepl="nesh -b -e"
alias csrepl="nesh -c -e"

# Setup Java (uncomment jdk you want to use)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home

# Configure Docker CLI
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/afaur/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"

# Find all sym links
alias symfind="find . -maxdepth 1 -type l -exec echo {} \;"

# Util for quick file extraction
function extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "'$1' - file does not exist"
    fi
  fi
}

