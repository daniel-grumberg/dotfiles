[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [[ ! "${DISPLAY}" && "${XDG_VTNR}" -eq "1" ]]; then
    exec startx
fi
