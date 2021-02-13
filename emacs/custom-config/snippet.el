(dang/generate-override-keymap dang/leader/def "s" "snippet")
(use-package yasnippet
  :demand t
  :general
  (dang/snippet/def
    "n" '(yas-new-snippet :wk "new-snippet")
    "i" '(yas-insert-snippet :wk "insert-snippet")
    "e" '(yas-visit-snippet-file :wk "edit-snippet"))
  :config
  (use-package yasnippet-snippets)
  (yas-global-mode t))

(provide 'dang/snippet)
