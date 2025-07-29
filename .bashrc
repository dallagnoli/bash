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

# Set up XDG folders location
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"