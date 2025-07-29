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