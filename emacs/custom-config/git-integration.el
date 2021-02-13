(provide 'dang/git-integration)

;; This cannot go in the :init section because use-package tries to generate the autoloads before the keymap exists?
(dang/generate-override-keymap dang/leader/def "g" "git")
;; Proper installation of magit
(use-package magit
  :general
  (dang/git/def
    ">" '(magit-submodule-popup :wk "submodules-popup")
    "b" '(magit-blame-addition :wk "blame")
    "i" '(magit-gitignore-locally :wk "ignore")
    "s" '(magit-status :wk "status")
    "S" '(magit-stage :wk "stage-file")
    "m" '(magit-dispatch-popup :wk "dispatch")
    "U" '(magit-unstage-file :wk "unstage-file")))

(use-package evil-magit
  :after (magit evil))
