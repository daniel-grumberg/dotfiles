(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :hook ((LaTeX-mode . TeX-source-correlate-mode))
  :general
  (dang/local/def LaTeX-mode-map
    "*" '(LaTeX-mark-section :wk "mark-section")
    "." '(LaTeX-mark-environment :wk "mark-environment")
    "]" '(LaTeX-close-environment :wk "close-environment")
    "~" '(LaTeX-math-mode :wk "toggle-math-mode")
    "b" '(TeX-command-run-all :wk "build")
    "B" '(LaTeX-find-matching-begin :wk "find-begin")
    "c" '(TeX-command-master :wk "select-command")
    "E" '(LaTeX-find-matching-begin :wk "find-end")
    "e" '(LaTeX-environment :wk "insert-environment")
    "i" '(LaTeX-insert-item :wk "insert-env-item")
    "m" '(TeX-insert-macro :wk "insert-macro")
    "n" '(TeX-next-error :wk "next-error")
    "s" '(LaTeX-section :wk "insert-section"))
  :config
  (setq TeX-parse-self t
        TeX-auto-save t
        TeX-master nil
        TeX-PDF-mode t
        TeX-source-correlate-start-server t
        TeX-source-correlate-method 'synctex
        TeX-source-correlate-start-server t)
;; Use Skim on macOS for pdf support
  (if (eq system-type 'darwin)
    (setq TeX-view-program-selection '((output-pdf "Skim"))
          TeX-view-program-list
          '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
    (setq TeX-view-program-selection '((output-pdf "PDF Tools"))))
  (setcdr (assoc "BibTeX" TeX-command-list)
          '("bibtex --min-crossrefs=100 %s"
            TeX-run-BibTeX nil t :help "Run BibTeX with ...")))

(use-package ivy-bibtex
  :general
  (dang/local/def LaTeX-mode-map
    "r" '(ivy-bibtex :wk "search-bibliography"))
  :config
  (if (eq system-type 'darwin)
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            (call-process "open" nil 0 nil "-a" "/Applications/Skim.app" fpath)))
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            (call-process "mupdf" fpath))))
  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation))

(provide 'dang/latex-support)
