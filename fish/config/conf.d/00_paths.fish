# Make sure that PATH components inside the home directory are correctly
# set. This can not use $fish_user_paths because my home directory is not
# consistent across machines.
fish_add_path -g -p ~/.local/bin
set -p fish_function_path ~/.local/share/fish/functions
