#!/bin/zsh
set -o vi

# System
#source "/etc/environment"

export PATH=/usr/bin:~/.cabal/bin:~/Tools/android/ndk:~/Tools/android/sdk/platform-tools:~/Tools/android/sdk/tools:~/Tools/appengine/google_appengine:~/Tools/appengine/java/latest/bin:~/Tools/appengine/python/latest:~/bin:~/bin/genymotion:~/Tools/java/gradle/bin:~/Tools/java/maven/maven/bin:/usr/local/cuda/bin/:~/Tools/db/datomic/latest/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH

#OCTAVE
#export PATH=$PATH:/Applications/Octave.app/Contents/Resources/bin

#RVM
export PATH=$PATH:~/.rvm/bin

#export CLASSPATH=$CLASSPATH:.:..
export TERM=xterm-256color
export EDITOR=/usr/bin/vim

#export ANDROID_HOME=~/Tools/android/sdk
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH 

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias xclip='pbcopy'
fi

alias ll='ls -l --color=auto'
alias ls='ls --color=auto'


# APT
# alias acs='apt-cache search'
# alias agi='sudo apt-get install'
# alias dpq='dpkg-query -L'
# alias sdi='sudo dpkg -i'

alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gc='git checkout'
alias gcp='git checkout -p'
alias gca='git commit --amend'
alias gcam='git commit -am'
alias gcm='git commit -m'
alias gd='git diff'
alias gbg='git bisect good'
alias gbb='git bisect bad'
alias gf='git fetch'
alias gl='git log'
alias gm='git merge'
alias gmm='git merge master'
alias gp='git push'
alias gpuom='git push -u origin master'
alias grm='git rebase -i master'
alias grc='git rebase --continue'
alias gs='git status'
alias gss='git stash save'
alias gsp='git stash pop'
alias griom='git rebase -i origin/master'

alias lf=lfrun

git_rebase_origin () {
    branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"
    branch_name=${branch_name##refs/heads/}
    if [ -n "$branch_name" ]; then
      git rebase origin/$branch_name
    fi
}

#alias gfr='git fetch && git_rebase_origin'
alias gfr='git pull'

#****************************************
# The following lines were added by compinstall
#****************************************

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand suffix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
#****************************************
# End of lines added by compinstall
#****************************************

#Navigation

#history search
bindkey '^R' history-incremental-search-backward

#automagically go to a directory, eg type $/etc and hit enter, zsh will chage to /etc
setopt AUTO_CD


#keep history file between sessions
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history
setopt APPEND_HISTORY
#for sharing history between zsh processes
setopt INC_APPEND_HISTORY

#****************************************
# Program Shortcuts
#****************************************

alias t='todo.sh'

#****************************************
# File Associations
#****************************************
alias -s odt=oowriter
alias -s tgz="tar -xzf"
alias -s tar.gz="tar -xzvf"
alias -s bz2="tar -xjvf"
alias -s png=gqview
alias -s jpg=gqview
alias -s gif=gqview
alias -s sxw=oowriter
alias -s doc=oowriter

#****************************************
#SSH agent
#****************************************
#SSH AGENT
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
echo "Initializing new SSH agent..."
/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
echo succeeded
chmod 600 "${SSH_ENV}"
. "${SSH_ENV}" > /dev/null
/usr/bin/ssh-add;
}

         # Source SSH settings, if applicable
         if [ -f "${SSH_ENV}" ]; then
             . "${SSH_ENV}" > /dev/null
             #ps ${SSH_AGENT_PID} doesn't work under cywgin
             ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
             start_agent;
         }
     else
         start_agent;
     fi

#****************************************
#MISC
#****************************************
#define shich characters belong to a word, note that / is missing, so Ctrl+W will handle paths correctly
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

#****************************************
# Android Development
#****************************************

alias restartUdev='sudo udevadm control --reload-rules'
alias bluetoothDiscoverable='sudo hciconfig hci0 piscan'
# hcitool dev
# hciconfig -a hci0

#********************************
# Clojure
#********************************
export VIMCLOJURE_SERVER_JAR="$HOME/Tools/clojure/nailgun/server-latest.jar"

#****************************************
#BEGIN PROMPT
#****************************************

function precmd {

    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))


    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=""
    
    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    
    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi


    ###
    # Get APM info.

    if which ibam > /dev/null; then
	PR_APM_RESULT=`ibam --percentbattery`
    elif which apm > /dev/null; then
	PR_APM_RESULT=`apm`
    fi
}


setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}


setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    
    ###
    # Decide if we need to set titlebar text.
    
    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
    else
	PR_STITLE=''
    fi
    
    
    ###
    # APM detection
    
    if which ibam > /dev/null; then
	PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
    elif which apm > /dev/null; then
	PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
    else
	PR_APM=''
    fi
    
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

# END PROMPT

setprompt

#f you want to enable Portage completions and Gentoo prompt,
# emerge app-shells/zsh-completion and add
autoload -U compinit promptinit
compinit
#promptinit; prompt gentoo
promptinit;
#* Also, if you want to enable cache for the completions, add
zstyle ':completion::complete:*' use-cache 1

# Rust
export PATH="$HOME/.multirust/toolchains/stable/cargo/bin:$PATH"

# RVM System
#[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
# RVM User
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# PyEnv
export PATH="/home/dk/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


export PATH="~/Tools/appengine/java/current/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"

export PYTHONPATH=$PYTHONPATH:./lib

export GOROOT=/usr/lib/go
export GOPATH=~/Tools/go/
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export PATH="/opt/cuda/bin:$PATH"
export PATH="$HOME/Tools/crystal/crystal/bin:$PATH"

# env-zsh - Enhanced .env file loading
autoload -U add-zsh-hook

# Store loaded env vars to unset them when leaving directory
typeset -A DOTENV_VARS

load-local-conf() {
    # Unset previously loaded env vars if we're leaving a directory with .env
    if [[ -n "${DOTENV_VARS[@]}" ]]; then
        for var in "${(k)DOTENV_VARS[@]}"; do
            unset "$var"
        done
        DOTENV_VARS=()
    fi

    # Check if .env file exists, is regular file and is readable
    if [[ -f .env && -r .env ]]; then
        # Parse .env file and track loaded variables
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue

            # Remove leading/trailing whitespace
            key="${key//[[:space:]]/}"

            # Export the variable and track it
            if [[ -n "$key" ]]; then
                export "$key=$value"
                DOTENV_VARS[$key]=1
            fi
        done < .env

        echo "✓ Loaded .env from $(pwd)"
    fi
}

# Load .env when entering a directory
add-zsh-hook chpwd load-local-conf

# Also load .env in current directory when shell starts
load-local-conf

export NVM_DIR="/home/dk/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/dk/.sdkman"
[[ -s "/home/dk/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dk/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
