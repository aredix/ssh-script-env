# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '

alias ls="ls --color=auto"
alias ll="ls -lah"
alias openarena="~/.env/bin/openarena/openarena.x86_64"
alias deb2targz="~/.env/tools/deb2targz.sh"
alias deb2tarxz="~/.env/tools/deb2tarxz.sh"
alias deb2tarxz4lib="~/.env/tools/deb2tarxz4lib.sh"
alias deb2targz4lib="~/.env/tools/deb2targz4lib.sh"
alias tshark="~/.env/bin/tshark"
alias nmap="~/.env/bin/nmap"
alias ncat="~/.env/bin/ncat"
alias nping="~/.env/bin/nping"

export PATH="$PATH:~/.env/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:~/.env/lib"
