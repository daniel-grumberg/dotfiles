set -gx NVM_DIR ~/.nvm
if test -x "{$NVM_DIR}/nvm.sh"
  function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
  end

  nvm use default --silent
end
