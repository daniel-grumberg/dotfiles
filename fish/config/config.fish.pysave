# Make sure that PATH components inside the home directory are correctly
# set. This can not use $fish_user_paths because my home directory is not
# consistent across machines.
set -x PATH ~/.local/src/arcanist/bin ~/.local/bin $PATH

set -gx NVM_DIR ~/.nvm
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

nvm use default --silent

if status is-interactive
    # Initialize fuck
    thefuck --alias | source
end
