# -----------------------------
# --- Startup -----------------
# -----------------------------

# Interactive tweaks
if [[ $- == *i* ]]; then
    command -v fastfetch &>/dev/null && fastfetch
    bind "set bell-style visible"
    shopt -s checkwinsize
    stty -ixon
    bind "set completion-ignore-case on"
    bind "set show-all-if-ambiguous on"
fi

# Source global bashrc definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source extended bash completion module
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# -----------------------------
# --- History -----------------
# -----------------------------

# Number of history commands stored on disk
export HISTFILESIZE=10000
# Number of history commands stored in memory
export HISTSIZE=500
# Print date and time of execution
export HISTTIMEFORMAT="%d/%m/%y %H:%M:%S - "
# Ignore commands starting with a space, keep last duplicate
export HISTCONTROL="erasedups:ignorespace"
# Append to history, rather than overwriting
shopt -s histappend
# Append immediately, not at end of session
export PROMPT_COMMAND="history -a"

# -----------------------------
# --- Environment -------------
# -----------------------------

# Set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Set the default editor
export EDITOR="nano"
export VISUAL="nano"

# Custom colors for ls command
export LS_COLORS="no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:"

# -----------------------------
# --- Aliases -----------------
# -----------------------------

# Swap grep for ripgrep, if installed
if command -v rg &> /dev/null; then
    alias grep="rg"
fi

# Swap rm for trash-cli, for security, if installed
if command -v trash &> /dev/null; then
    alias rm="trash -v"
fi

# Enables fuzzy yay, if yay is installed
if command -v yay &> /dev/null; then
    alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S --noconfirm --needed"
fi

# Quick shortcuts
alias nano="sudo nano"
alias mkdir="mkdir -p"
alias mk="mkdir"
alias cp="cp -rf"
alias cl="clear"
alias gr="grep"

# -----------------------------
# --- Final Call --------------
# -----------------------------

# Init starship prompt
eval "$(starship init bash)"
# Init zoxide command
eval "$(zoxide init bash)"