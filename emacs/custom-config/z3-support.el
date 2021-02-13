(use-package z3-mode
  :commands z3-mode
  :config
  (setq z3-solver-cmd "/usr/bin/z3"))

(provide 'dang/z3-support)
