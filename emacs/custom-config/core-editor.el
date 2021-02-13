;; Preferred editor behaviors, this prevents backup files on auto-saves
(setq auto-save-list-prefix nil
      make-backup-files nil
      auto-save-default nil
      auto-save-list-file-prefix nil)

(setq-default indent-tabs-mode nil)

(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

(add-hook 'prog-mode-hook '(lambda () (display-line-numbers-mode 1)))
(add-hook 'text-mode-hook '(lambda () (display-line-numbers-mode 1)))

(global-visual-line-mode t)

(use-package visual-fill-column
  :hook (text-mode . visual-fill-column-mode)
  :init
  (setq visual-fill-column-width 120))

(setq show-paren-delay 0)
(show-paren-mode 1)

;; Make the editor more discoverable (provides a popup menu for incomplete chord prefixes)
(use-package which-key
  :demand t
  :init
  :config
  (which-key-mode 1))

;; Add support for customizing key-bindings
;; Here we add support for the basic key-definers (prefixes)
(use-package general
  :demand t
  :config
  (general-create-definer dang/leader/def
    :states '(motion normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "C-SPC")

  (dang/leader/def
    "TAB" '((lambda () (interactive) (switch-to-buffer (other-buffer))) :wk "previous-buffer")
    "k" 'save-buffers-kill-emacs
    "K" 'kill-emacs)

  (defmacro dang/generate-override-keymap (definer inf name)
    "Generate command, keymap and definer for global override editor prefixes
The forms of the generated symbols is:
- infix key: INF
- commands: dang/NAME/command
- keymap: dang/NAME/map
- definer: dang/NAME/def"
    `(progn
       (general-create-definer ,(intern (concat "dang/" name "/def"))
         :wrapping ,definer
         :infix ,inf)
       (,(intern (concat "dang/" name "/def"))
        "" '(:ignore t :wk ,name))))

  ;; Cannot be looped as the NAME string needs to be the macro argument to be
  ;; able to generate the symbols
  (dang/generate-override-keymap dang/leader/def "b" "buffers")
  (dang/generate-override-keymap dang/leader/def "c" "completions")
  (dang/generate-override-keymap dang/leader/def "f" "files")
  (dang/generate-override-keymap dang/leader/def "h" "help")
  (dang/generate-override-keymap dang/leader/def "l" "local")
  (dang/generate-override-keymap dang/leader/def "r" "registers")
  (dang/generate-override-keymap dang/leader/def "t" "text")

  (dang/buffers/def
    "k" 'kill-buffer
    "K" '((lambda ()
            (interactive)
            (kill-buffer nil))
          :wk "kill-current-buffer"))

  (dang/help/def
    "d" 'man
    "f" 'describe-function
    "g" 'general-describe-keybindings
    "k" 'describe-key
    "m" 'describe-mode
    "p" 'describe-package
    "v" 'describe-variable
    "w" 'where-is)

  (dang/files/def
    "d" 'delete-file
    "O" '(find-file :wk "open-file-current-window")
    "s" '(save-buffer :wk "save-file"))

  (dang/text/def
    "f" 'indent-region
    "F" '(indent-according-to-mode :wk "indent-line")))

;; Narrowing completions across the editor using ivy
(use-package ivy
  :demand t
  :general
  (dang/buffers/def
    "g" '(ivy-switch-buffer :wk "goto-buffer"))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t
        ivy-count-format "(%d/%d) "
        ivy-use-selectable-prompt t
        ivy-wrap t))

;; Enable narrowing completion optimized incremental search
(use-package swiper
  :general ('normal "/" '(swiper :wk "swipe")))

;; Enable various narrowing completion enabled commands
(use-package counsel
  :general
  (dang/leader/def
    "SPC" '(counsel-M-x :wk "execute-command"))
  :demand t)

;; Install and enable evil-mode to get vim emulation goodness
(use-package evil
  :demand t
  :init
  (setq evil-respect-visual-line-mode t
        evil-want-integration t   ;; Make sure we can use evil pervasively
        evil-want-keybinding nil
        evil-disable-insert-state-bindings t)  ;; Disable default evilified keybindings so we can rely on evil-collection
  :general
  (dang/registers/def
   "m" '(evil-record-macro :wk "record-macro")
   "M" '(evil-execute-macro :wk "execute-macro"))
  :config
  ;; Ensure no major mode defaults to emacs or motion state unless explicitly specified
  (setq evil-emacs-state-modes nil
        evil-motion-state-modes nil)
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;; Bindings for undo tree
(dang/text/def
  "u" '(nil :wk "undo-tree")
  "uv" '(undo-tree-visualize :wk "visualize")
  "uu" '(undo-tree-undo :wk "undo")
  "uU" '(undo-tree-redo :wk "redo"))

(dang/registers/def
  "u" '(undo-tree-save-state-to-register :wk "undo-save")
  "U" '(undo-tree-restore-state-from-register :wk "undo-restore"))

(general-define-key
 :states '(normal motion)
 :keymaps 'undo-tree-visualizer-mode-map
 "h" 'undo-tree-visualize-switch-branch-left
 "j" 'undo-tree-visualize-redo
 "C-j" 'undo-tree-visualize-redo-to-x
 "k" 'undo-tree-visualize-undo
 "C-k" 'undo-tree-visualize-undo-to-x
 "l" 'undo-tree-visualize-switch-branch-right)

;; Get Hydra for modal key-bindings
(use-package hydra
  :demand t)

;; Enable smart parens matching globally
(electric-pair-mode 1)

;; Enable easy-commenting operator
(use-package evil-commentary
  :config
  (evil-commentary-mode))

;; Enable completions globally
(use-package company
  :demand t
  :init
  :general
  (company-active-map
   "RET" 'company-complete-selection)
  (dang/completions/def
    "c" 'company-complete
    "o" 'company-other-backend)
  :hook ((after-init . global-company-mode)))

(use-package ripgrep)

(provide 'dang/core-editor)
