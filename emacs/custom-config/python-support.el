(add-hook 'python-mode-hook #'lsp)

(use-package yapfify
  :general
  (dang/text/def python-mode-map
    "f" '(yapfify-buffer :wk "format-buffer")
    "F" '(yafify-buffer-or-region :wk "format-dwim")))

(provide 'dang/python-support)
