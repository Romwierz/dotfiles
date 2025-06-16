# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes custom bins if it exists

# --- ARM GCC Toolchain ---
if [ -d "/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin" ] ; then
    PATH="$PATH:/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin"
fi

# --- Scripts ---
if [ -d "$HOME/.scripts" ]; then
    PATH="$PATH:$HOME/.scripts"
fi

# required for customizing appearance in Qt6 apps (like qpdfview) using i3wm
export QT_QPA_PLATFORMTHEME=qt6ct

# display icons in lf file manager
LF_ICONS_FILE="$HOME/.config/lf/icons"
if [ -f "$LF_ICONS_FILE" ]; then
    source "$LF_ICONS_FILE"
fi
