[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

if [[ ! "${DISPLAY}" && "${XDG_VTNR}" -eq "1" ]]; then
    exec startx
fi
