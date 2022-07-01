# Make sure that PATH components inside the home directory are correctly
# set. This can not use $fish_user_paths because my home directory is not
# consistent across machines.
set -gx PATH ~/.local/src/arcanist/bin ~/.local/bin $PATH

if status is-interactive
    # Initialize fuck
    thefuck --alias | source
end
