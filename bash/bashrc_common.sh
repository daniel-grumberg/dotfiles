source "${HOME}/.exports"

[[ ! "$-" =~ "i" ]] && return

if [[ -f "${HOME}/.git-prompt.sh" ]]; then
    source "${HOME}/.git-prompt.sh"
fi

if [[ -f "${HOME}/.aliases" ]]; then
    source "${HOME}/.aliases"
fi

set_prompt()
{
   local _txtreset
   _txtreset='$(tput sgr0)'
   local _txtbold
   _txtbold='$(tput bold)'
   local _txtred
   _txtred='$(tput setaf 1)'
   local _txtgreen
   _txtgreen='$(tput setaf 2)'
   local _txtblue='$(tput setaf 4)'
   PS1="\[${_txtbold}\]"
   # User color: red for root, yellow for others
   if [[ "${EUID}" -eq "0" ]]; then
       PS1+="\[${_txtred}\]"
   else
       PS1+="\[${_txtgreen}\]"
   fi
   # user@host
   PS1+="\u@\h:"
   # cwd
   PS1+="\[${_txtblue}\]\w "
   # red git branch
   PS1+="\[${_txtred}\]$(__git_ps1 '(%s)')\n\[${_txtreset}\]"
   # good old prompt, $ for user, # for root
   PS1+="\[${_txtbold}\]\\$\[${_txtreset}\] "
}

export PROMPT_COMMAND='set_prompt'

set -o vi
