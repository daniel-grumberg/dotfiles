;; Proper installation of org-mode
(require 'org)
(require 'dang/core-editor)

(defun dang/open-inbox ()
  (interactive)
  (find-file org-default-notes-file))

;; Ensure org-mode is the default for /\.(org(_archive)?|txt)/ files
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(setq org-adapt-indentation nil
      org-hide-leading-stars t)
(setq org-directory "~/org-gtd"
      org-agenda-files '("~/org-gtd/inbox.org"
                         "~/org-gtd/tickler.org"
                         "~/org-gtd/agenda")
      org-default-notes-file "~/org-gtd/inbox.org")

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))
      org-todo-keyword-faces
      '(("TODO" :foreground "red" :weight bold)
        ("NEXT" :foreground "blue" :weight bold)
        ("DONE" :foreground "forest green" :weight bold)
        ("WAITING" :foreground "orange" :weight bold)
        ("HOLD" :foreground "magenta" :weight bold)
        ("CANCELLED" :foreground "forest green" :weight bold))
      org-todo-state-tags-triggers
      '(("CANCELLED" ("CANCELLED" . t))
        ("WAITING" ("WAITING" . t))
        ("HOLD" ("WAITING") ("HOLD" . t))
        (done ("WAITING") ("HOLD"))
        ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
        ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
        ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))

(setq org-use-fast-todo-selection t)

(setq org-tag-persistent-alist '(("@home" . ?h)
                                 ("@office" . ?o)
                                 ("@computer" . ?c)
                                 ("@email" . ?e)))
(setq org-use-fast-tag-selection t)

(setq org-capture-templates
      '(("t" "todo" entry (file "~/org-gtd/inbox.org")
         "* TODO %?\n")
        ("n" "note" entry (file "~/org-gtd/inbox.org")
         "* %? :NOTE:\n\n")
        ("w" "org-protocol" entry (file "~/org-gtd/inbox.org")
         "* TODO Review [[%:link][%:description]]\n")
        ("T" "Tickler" entry (file "~/org-gtd/tickler.org")
         "* %?\n%U\n")))

(setq org-refile-targets '((org-agenda-files :maxlevel . 9)
                           ("~/org-gtd/tickler.org" :maxlevel . 9)))

(setq org-archive-location "~/org-gtd/archive/%s_archive::")

;; This cannot go in the :init section because use-package tries to generate the autoloads before the keymap exists?
(dang/generate-override-keymap dang/leader/def "o" "org-mode")

(general-define-key
  :states '(motion emacs)
  "<f12>" 'org-agenda)

(general-define-key
  :states '(motion emacs insert)
  :keymaps 'org-mode-map
  "M-h" 'org-metaleft
  "M-k" 'org-metaup
  "M-j" 'org-metadown
  "M-l" 'org-metaright
  "M-H" 'org-shiftmetaleft
  "M-K" 'org-shiftmetaup
  "M-J" 'org-shiftmetadown
  "M-L" 'org-shiftmetaright)

(general-define-key
  :states '(motion emacs)
  :keymaps 'org-agenda-mode-map
  "j" 'org-agenda-next-item
  "k" 'org-agenda-previous-item
  ;; Entry
  "ha" 'org-agenda-archive-default
  "hk" 'org-agenda-kill
  "hp" 'org-agenda-priority
  "hr" 'org-agenda-refile
  "h:" 'org-agenda-set-tags
  "ht" 'org-agenda-todo
  ;; Visit entry
  "<tab>" 'org-agenda-goto
  "TAB" 'org-agenda-goto
  "SPC" 'org-agenda-show-and-scroll-up
  "RET" 'org-agenda-switch-to
  ;; Date
  "dt" 'org-agenda-date-prompt
  "dd" 'org-agenda-deadline
  "ds" 'org-agenda-schedule
  ;; View
  "vd" 'org-agenda-day-view
  "vw" 'org-agenda-week-view
  "vt" 'org-agenda-fortnight-view
  "vm" 'org-agenda-month-view
  "vy" 'org-agenda-year-view
  "vn" 'org-agenda-later
  "vp" 'org-agenda-earlier
  "vr" 'org-agenda-reset-view
  ;; Toggle mode
  "ta" 'org-agenda-archives-mode
  "tr" 'org-agenda-clockreport-mode
  "tf" 'org-agenda-follow-mode
  "tl" 'org-agenda-log-mode
  "td" 'org-agenda-toggle-diary
  ;; Filter
  "fc" 'org-agenda-filter-by-category
  "fx" 'org-agenda-filter-by-regexp
  "ft" 'org-agenda-filter-by-tag
  "fr" 'org-agenda-filter-by-tag
  "fh" 'org-agenda-filter-by-top-headline
  "fd" 'org-agenda-filter-remove-all
  ;; Other
  "gd" 'org-agenda-goto-date
  "." 'org-agenda-goto-today
  "gr" 'org-agenda-redo)

(dang/org-mode/def
  "l" '(org-store-link :wk "store-link")
  "a" '(org-agenda :wk "agenda")
  "c" '(org-capture :wk "capture")
  "i" '(dang/open-inbox :wk "open-inbox"))

(dang/text/def org-mode-map
  "n b" 'org-narrow-to-block
  "n e" 'org-narrow-to-element
  "n t" 'org-narrow-to-subtree)

(dang/local/def 'org-mode-map
  "'" '(org-edit-special :wk "edit-special")
  "/" '(org-sparse-tree :wk "sparse-tree")
  "." '(org-time-stamp :wk "time-stamp")
  "!" '(org-time-stamp-inactive :wk "time-stamp-inactive")
  ":" '(org-set-tags-command :wk "set-tags")
  "#" '(org-update-statistics-cookies :wk "update-cookies")
  "a" '(org-archive-subtree :wk "archive-subtree")
  "b" '(org-tree-to-indirect-buffer :wk "tree-to-indirect-buffer")
  "c" '(org-capture :wk "capture")
  "d" '(org-deadline :wk "add-deadline")
  "D" '(org-insert-drawer :wk "insert-drawer")
  "e" '(org-export-dispatch :wk "export")
  "f" '(org-set-effort :wk "set-effort")
  "i" '(org-clock-in :wk "clock-in")
  "o" '(org-clock-out :wk "clock-out")
  "p" '(org-set-property :wk "set-property")
  "q" '(org-clock-cancel :wk "clock-cancel")
  "r" '(org-refile :wk "refile")
  "s" '(org-schedule :wk "schedule")
  "t" '(org-table-create :wk "create-table")
  "T" '(org-todo :wk "set-todo")
  "h" '(nil :wk "heading-insertion")
  "h i" '(org-insert-heading :wk "insert-heading")
  "h t" '(org-insert-todo-heading :wk "insert-todo")
  "h s" '(org-insert-subheading :wk "insert-subheading"))

(dang/local/def 'org-capture-mode-map
  "f" '(org-capture-finalize :wk "finalize")
  "r" '(org-capture-refile :wk "finalize-and-refile")
  "a" '(org-capture-kill :wk "abort"))

(provide 'dang/org-mode)
