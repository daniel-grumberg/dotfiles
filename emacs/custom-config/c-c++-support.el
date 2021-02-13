;; Shamelessly copied from llvm sources
(c-add-style "llvm.org"
             '("gnu"
 	       (fill-column . 80)
 	       (c++-indent-level . 2)
 	       (c-basic-offset . 2)
 	       (indent-tabs-mode . nil)
 	       (c-offsets-alist . ((arglist-intro . ++)
                                   (innamespace . 0)
                                   (member-init-intro . ++)))))

;; Apply llvm conventions when editing anything that seems to integrate with llvm
(defun dang/set-llvm-style ()
  "Sets the c-style to llvm.org when editing a path the that looks to belong
     to a llvm project"
  (when (and buffer-file-name
             (string-match "llvm" buffer-file-name))
    (c-set-style "llvm.org")))

(use-package clang-format+
  :hook ((c-mode c++-mode) . clang-format+-mode)
  :config
  (setq clang-format+-context 'modification
        clang-format+-always-enable t))

(add-hook 'c-mode-hook #'dang/set-llvm-style)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'dang/set-llvm-style)
(add-hook 'c++-mode-hook #'lsp)

(use-package cmake-font-lock
  :hook ((cmake-mode . cmake-font-lock-activate)))

(use-package helm-make
  :config
  (setq helm-make-completion-method 'ivy
        helm-make-do-save t)
  (when (not(eq system-type 'darwin))
    (setq helm-make-nproc 0))
  :general
  (dang/local/def c-mode-base-map
    "c" '(helm-make-projectile :wk "make")))

(provide 'dang/c-c++-support)
