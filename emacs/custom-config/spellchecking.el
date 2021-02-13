(use-package flyspell
  ;; This is part of the base emacs distribution so we really don't
  ;; want this to conflict with use-package-always-ensure
  :ensure nil
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :init
  ;; Ensure that spellcheckers are found on macOS
  (setq ispell-dictionary "american")
  (setq ispell-program-name "aspell")
  :custom
  (flyspell-issue-message-flag nil)
  (flyspell-issue-welcome-flag nil)
  :general
  (dang/text/def
    "s" '(flyspell-mode :wk "toggle-spellcheck")))

(use-package flyspell-correct
  :after flyspell
  :general
  (dang/text/def
    "." 'flyspell-correct-wrapper))
(use-package flyspell-correct-ivy
  :after flyspell-correct)

(provide 'dang/spellchecking)
