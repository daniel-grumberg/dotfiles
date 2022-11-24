function magit
    emacs -nw --eval="(progn (magit-status \"$(git rev-parse --show-toplevel)\" (select-frame-set-input-focus (selected-frame))))"
end
