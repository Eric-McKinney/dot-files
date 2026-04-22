# copy and go to dir
cpg() {
    set -e
    cp "$@"

    if [[ -d "${@: -1}" ]]
    then
        cd "${@: -1}"
    fi
}

# move & go to dir
mvg() {
    set -e
    mv "$@"

    if [[ -d "${@: -1}" ]]
    then
        cd "${@: -1}"
    fi
}

# cd up specified number of parent directories
up() {
    [[ $# -gt 1 ]] && { echo "up: expected 0 or 1 arg, given $#"; return 1; }

    if [[ $# -eq 0 ]]
    then
        z ..
        return $?
    fi

    [[ "$1" =~ ^[0-9]+$ ]] || { echo "up: arg is not a number"; return 1; }

    local i
    local d=""
    for (( i = 0; i < $1; i++ ))
    do
        d+="../"
    done

    z "$d"
}

extract() {
    for archive in "$@"
    do
        if [[ -f "$archive" ]]
        then
            case "$archive" in
                *.tar.bz2|*.tbz2) tar xvjf "$archive" ;;
                *.tar.gz|*.tgz) tar xvzf "$archive" ;;
                *.bz2) bunzip2 "$archive" ;;
                *.rar) rar x "$archive" ;;
                *.gz) gunzip "$archive" ;;
                *.tar) tar xvf "$archive" ;;
                *.zip) unzip "$archive" ;;
                *.Z) uncompress "$archive" ;;
                *.7z) 7z x "$archive" ;;
                *) echo "extract: don't know how to extract '$archive'..." ;;
            esac
        else
            echo "extract: '$archive' is not a valid file"
        fi
    done
}

update() {
    type -p apt &>/dev/null && sudo apt update && sudo apt -y full-upgrade
    type -p brew &>/dev/null && brew update && brew upgrade
    type -p flatpak &>/dev/null && flatpak update -y
    type -p wsl.exe &>/dev/null && wsl.exe --update
    type -p nixos-rebuild &>/dev/null && sudo nixos-rebuild switch --upgrade
}

alias mktar='tar cvf'
alias mkbz2='tar cvjf'
alias mkgz='tar cvzf'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias less='less -R'
fi

# some more ls aliases (which I'll never use)
alias ll='ls -AlhF'    # nice long listing
alias lx='ls -lXBh'    # sort by extension
alias lk='ls -lSrh'    # sort by file size
alias lc='ls -ltcrh'   # sort by ctime (last change time: file metadata e.g. permissions)
alias lu='ls -lturh'   # sort by last time accessed
alias lt='ls -ltrh'    # sort by last time modified
alias lw='ls -xAh'     # wide listing
alias labc='ls -lp'    # alphabetical sort
alias ldir='ls -d */'  # list directories only
alias lf='ls -l $(fd --max-depth 1 --type f)'  # list files only

alias tree='tree -CAhF --dirsfirst'
alias treed='\tree -CAFd'

# --- same but better ---
alias cd='z'
alias find='fd'
alias grep='rg'
alias vim='nvim'
alias vi='\vim'

# --- NixOS ---
alias ned='sudoedit /etc/nixos/configuration.nix'
alias nrs='sudo nixos-rebuild switch'
alias ngc='sudo nix-collect-garbage'
alias nso='sudo nix store optimise'

# --- WSL ---
if [[ -d /mnt/c/WINDOWS/system32 ]]
then
    # pipe to this to copy to the system clipboard (for wsl only)
    # ex: cat file | copy
    alias copy='clip.exe'
    # echo contents of system clipboard (for wsl only)
    # ex: paste > file
    alias paste='powershell.exe -command "Get-Clipboard"'
    # change CRLF to LF in a file
    # ex: dos2unix file
    alias dos2unix="sed -i 's/\r$//'"
fi

# --- MISC ---

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias py='python3'
alias 2proj='source /home/eric/.local/bin/2proj'
alias gcc='gcc -ansi -Wall -g -O0 -Wwrite-strings -Wshadow -pedantic-errors -fstack-protector-all -Wextra'
