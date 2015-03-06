#!/bin/zsh
set -o vi

# System
#source "/etc/environment"

export PATH=$PATH:/var/lib/gems/1.8/bin:/workspace/ici/scripts:~/Tools/android/ndk:~/Tools/android/sdk/platform-tools:~/Tools/android/sdk/tools:~/Tools/appengine/google_appengine:~/Tools/appengine/java/latest/bin:~/Tools/appengine/python/latest:~/bin


#OCTAVE
#export PATH=$PATH:/Applications/Octave.app/Contents/Resources/bin

#RVM
export PATH=$PATH:~/.rvm/bin

export CLASSPATH=$CLASSPATH:.:..
export TERM=xterm-256color
export EDITOR=/usr/bin/vim

export ANDROID_HOME=~/Tools/android/sdk

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
alias ls='ls --color=auto'

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias xclip='pbcopy'
fi

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

alias ll='ls -l --color=auto'

#keep history file between sessions
HISTSIZE=1000
SAVEHIST=1000
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

#randomxterm

#f you want to enable Portage completions and Gentoo prompt,
# emerge app-shells/zsh-completion and add
autoload -U compinit promptinit
compinit
#promptinit; prompt gentoo
promptinit;
#* Also, if you want to enable cache for the completions, add
zstyle ':completion::complete:*' use-cache 1


# RVM System
#[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
# RVM User
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# PyEnv
eval "$(pyenv init -)"

export PATH="~/Tools/appengine/java/current/bin:$PATH"
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
