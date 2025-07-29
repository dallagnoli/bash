# -----------------------------
# Startup (interactive session)
# -----------------------------

# Check if the shell is interactive
if [[ $- == *i* ]]; then

    # Run fastfetch if available
    command -v fastfetch &>/dev/null && fastfetch

    # Use visible bell instead of sound
    bind "set bell-style visible"

    # Enable case-insensitive tab completion
    bind "set completion-ignore-case on"

    # Show all results if ambiguous completion
    bind "set show-all-if-ambiguous on"

    # Automatically check terminal window size after each command
    shopt -s checkwinsize

    # Disable Ctrl+S/Ctrl+Q flow control
    stty -ixon

fi


# -----------------------------
# Load system-wide bash settings
# -----------------------------

# Source system-wide bashrc file if it exists
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc

# Fallback to older bashrc location
elif [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi


# Load bash completion if available
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion

elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# -----------------------------
# History Configuration
# -----------------------------

# Maximum number of lines stored in the history file
export HISTFILESIZE=10000

# Number of lines stored in memory for the current session
export HISTSIZE=500

# Format of timestamps in the command history
export HISTTIMEFORMAT="%d/%m/%y %H:%M:%S - "

# Avoid storing duplicate or space-prefixed commands
export HISTCONTROL="erasedups:ignorespace"

# Append to history file rather than overwriting it
shopt -s histappend

# Immediately append each command to the history file
export PROMPT_COMMAND="history -a"


# -----------------------------
# Environment Variables
# -----------------------------

# Define standard user data/config directories using XDG specification
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Set the default text editor
export EDITOR="nano"
export VISUAL="nano"

# Define custom file type colors for the 'ls' command
export LS_COLORS="no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.zip=01;31:*.tar=01;31:*.jpg=01;35:*.png=01;35:*.mp3=01;35:*.wav=01;35"

# Define color sequences for the 'less' command output
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# -----------------------------
# Command Substitutions and Aliases
# -----------------------------

# Use 'rg' (ripgrep) instead of 'grep' if available
command -v rg &>/dev/null && alias grep="rg"

# Use 'trash' instead of 'rm' to prevent accidental deletion
command -v trash &>/dev/null && alias rm="trash -v"

# Define 'yayf' as a fuzzy search installer using yay and fzf
if command -v yay &>/dev/null && command -v fzf &>/dev/null; then
    alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S --noconfirm --needed"
fi

# Use zoxide if available for fast directory jumping
if command -v zoxide &>/dev/null; then
    alias cd="z"
    command -v fzf &>/dev/null && alias cdi="zi"
fi


# -----------------------------
# Directory Navigation Aliases
# -----------------------------

# Allow use of "..", "...", etc. for directory traversal
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Create directories recursively by default
alias mkdir="mkdir -p"
alias mk="mkdir"

# Clear the terminal screen
alias cl="clear"

# Basic colored listing, show all including hidden
alias ls="ls -aFh --color=always"

# Long listing, human-readable sizes (sem ocultos)
alias ll="ls -l"

# List only directories
alias ldir="ls -l | egrep '^d'"

# List only files
alias lf="ls -l | egrep -v '^d'"            


# -----------------------------
# File and Permission Aliases
# -----------------------------

# Safer default copy command
alias cp="cp -rf"

# Shorter chmod commands for common permission modes
alias mx="chmod a+x"
alias 000="chmod -R 000"
alias 644="chmod -R 644"
alias 666="chmod -R 666"
alias 755="chmod -R 755"
alias 777="chmod -R 777"

# Use raw /bin/rm when needed with verbose and recursive flags
alias rmd="/bin/rm -rfv"

# Short grep alias
alias gr="grep"


# -----------------------------
# Utility Functions
# -----------------------------

# Create a directory and enter it
mkcd() {
    mkdir "$1"
    cd "$1"
}


# Show the last two directories in the current path
pwdtail() {
    pwd | awk -F/ '{nlast = NF -1; print $nlast"/"$NF}'
}


# Extract various archive formats automatically
xt() {
    for archive in "$@"; do

        if [ ! -f "$archive" ]; then
            echo "'$archive' is not a valid file!" >&2
            continue
        fi

        case "$archive" in
            *.tar.bz2|*.tbz2)     tar -xvjf "$archive" ;;
            *.tar.gz|*.tgz)       tar -xvzf "$archive" ;;
            *.tar.xz)             tar -xvJf "$archive" ;;
            *.tar.zst)            tar --use-compress-program=unzstd -xvf "$archive" ;;
            *.tar)                tar -xvf "$archive" ;;
            *.bz2)                bunzip2 "$archive" ;;
            *.gz)                 gunzip "$archive" ;;
            *.xz)                 unxz "$archive" ;;
            *.zst)                unzstd "$archive" ;;
            *.lzma)               unlzma "$archive" ;;
            *.zip)                unzip "$archive" ;;
            *.rar)                unrar x "$archive" ;;
            *.7z)                 7z x "$archive" ;;
            *) echo "don't know how to extract: '$archive'" >&2 ;;
        esac

    done
}


# Detect Linux distribution and standardize its name
distro() {
    local dtype="unknown"

    if [ -r /etc/os-release ]; then
        . /etc/os-release
        for id in "$ID" $ID_LIKE; do
            case $id in
                fedora|rhel|centos) dtype="redhat"; break ;;
                sles|opensuse*)     dtype="suse"; break ;;
                ubuntu|debian)      dtype="debian"; break ;;
                gentoo)             dtype="gentoo"; break ;;
                arch|manjaro)       dtype="arch"; break ;;
                slackware)          dtype="slackware"; break ;;
            esac
        done
    fi

    echo "$dtype"
}

DISTRO=$(distro)

case "$DISTRO" in
    redhat|arch)
        alias cat="bat"
        ;;
    *)
        alias cat="batcat"
        alias bat="batcat"
        ;;
esac


# Show internal and external IP addresses
whatsmyip() {
    echo -n "Internal IP: "
    ip route get 1.1.1.1 2>/dev/null | awk '/src/ { print $7; exit }'

    echo -n "External IP: "
    if command -v curl &>/dev/null; then
        curl -s -4 ifconfig.me
    elif command -v wget &>/dev/null; then
        wget -qO- -4 ifconfig.me
    else
        echo "No curl or wget installed"
    fi
}


# Git add and commit with message
gcom() {
    git add .
    git commit -m "$1"
}

# Git add, commit and push with message
lazyg() {
    git add .
    git commit -m "$1"
    git push
}

# Create a symbolic link with full path
slk() {
    PWD=$(pwd)
    ln -sf $PWD/$1 $2
}


# -----------------------------
# Key Bindings and Startup Hooks
# -----------------------------

# Bind Ctrl+F to run the 'zi' command if shell is interactive
if [[ $- == *i* ]]; then
    bind '"\C-f":"zi\n"'
fi


# Update PATH with local directories
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:$PATH"


# Initialize Starship prompt
eval "$(starship init bash)"

# Initialize zoxide command
eval "$(zoxide init bash)"


# Automatically start graphical session if at TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec startx
fi