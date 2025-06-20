# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

### Inspirations
    # https://github.com/ericmurphyxyz/dotfiles/blob/master/.zshenv

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# write time stamp to the history file
HISTTIMEFORMAT="$(echo -e '\r\e[K')%F %T  "
# '\e[K' is an Erase in Line operation in ANSI (https://en.wikipedia.org/wiki/ANSI_escape_code)
# this way line numbers are not written into the history file

# append to the history file with each executed command from various shell sessions
# some other solutions are described in here:
# https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals
# PROMPT_COMMAND='history -a'
# other solution:
log_bash_persistent_history()
{
  [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
  ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
    echo $date_part " " "$command_part" >> ~/.persistent_history
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}
# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
    log_bash_persistent_history
}
PROMPT_COMMAND="run_on_prompt_command"

allhist() { cat "${HOME}/.persistent_history" ;}
alias histall=allhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.config/bash_aliases ]; then
    . ~/.config/bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### lf

    # change dir with lf file manager
    LFCD="$HOME/.config/lf/lfcd.sh"
    if [ -f "$LFCD" ]; then
        source "$LFCD"
    fi
    bind '"\C-o":"lfcd\C-m"'
    alias lf='lfcd'

    # display icons in lf file manager
    LF_ICONS_FILE="$HOME/.config/lf/icons"
    if [ -f "$LF_ICONS_FILE" ]; then
        source "$LF_ICONS_FILE"
    fi

### fzf
    source /usr/share/doc/fzf/examples/key-bindings.bash
    source /usr/share/doc/fzf/examples/completion.bash
    if [ -f ~/.config/fzf/functions ]; then
        . ~/.config/fzf/functions
    fi

### wikiman
    source /usr/share/wikiman/widgets/widget.bash

### bat
    export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

    alias bathelp='bat --plain --language=help'
    help() {
        "$@" --help 2>&1 | bathelp
    }
    alias h=help

# git
# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_reset='\[\033[1;32m\]'
    c_user='\[\033[1;32m\]'
    c_path='\[\e[0;33m\]'
    c_git_clean='\[\e[0;36m\]'
    c_git_dirty='\[\e[0;35m\]'
else
    c_reset=
    c_user=
    c_path=
    c_git_clean=
    c_git_dirty=
fi
 
# Function to assemble the Git part of our prompt.
git_prompt ()
{
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi
 
    git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p') 
    echo " [$git_branch${c_reset}]"
}

# update_prompt() {
#     # PS1="${c_user}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\$ "
#     # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_prompt)\$ '
# }

# Thy holy prompt.
PROMPT_COMMAND='run_on_prompt_command'

# change working directory to root of repo
git-root() {
	cd "$(git proot)"	
}
