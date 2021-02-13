(use-package flycheck)

(use-package lsp-mode
  :general
  (dang/help/def
    :predicate '(lsp-mode)
    "l" '(lsp-describe-session :wk "lsp-describe-session"))
  (dang/local/def lsp-mode-map
    "d" 'lsp-find-definition
    "D" 'lsp-find-declaration
    "f" 'lsp-format-buffer
    "F" 'lsp-format-region
    "g" 'lsp-goto-implementation
    "G" 'lsp-goto-type-definition
    "h" 'lsp-describe-thing-at-point
    "p" '(xref-pop-marker-stack :wk "goto-previous")
    "r" 'lsp-rename
    "R" 'lsp-find-references)
  :config
  (setq lsp-auto-guess-root t
        lsp-enable-indentation t
        lsp-enable-snippet t
        lsp-prefer-flymake nil
        lsp-file-watch-threshold nil
        lsp-auto-configure t)
  (when (equal system-type 'darwin)
    (add-to-list 'exec-path
                 (file-name-directory (shell-command-to-string "xcrun -f clangd"))
                 1)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package company-lsp
  :commands company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil))

(use-package lsp-ivy
  :commands (lsp-ivy-workspace-symbol lsp-ivy-global-workspace-symbol)
  :general
  (dang/local/def lsp-mode-map
    "s" '(lsp-ivy-workspace-symbol :wk "lsp-workspace-symbol")
    "S" '(lsp-ivy-global-workspace-symbol :wk "lsp-global-workspace-symbol")))

(provide 'dang/lsp-features)
