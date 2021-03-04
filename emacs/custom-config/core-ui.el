(require 'dang/core-editor "core-editor")

;; Remove all the GUI elements
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)

(fset 'yes-or-no-p 'y-or-n-p)

;; Allow finer grained resize of frames
(setq frame-resize-pixelwise t)

(defvar font-string "Iosevka:size=14")

(set-frame-font font-string t t)

;; Ensure we get maximized frames
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; macOS specific UI tweaks
(when (eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(ns-appearance . light)))

;; Theme
(use-package gruvbox-theme
  :config (load-theme 'gruvbox t))

(use-package all-the-icons)
(use-package all-the-icons-dired
  :after (all-the-icons)
  :hook (dired-mode . all-the-icons-dired-mode))

(setq projectile-mode-line
      '(:eval (propertize (if (projectile-project-p)
                              (format " Projectile[%s]"
                                      (projectile-project-name))
                            "")
                          'face 'font-lock-comment-face)))

(setq-default mode-line-format
              (list
               '(:eval (propertize " %f "
                                    'face
                                    (let ((face (buffer-modified-p)))
                                      (if face 'font-lock-warning-face
                                        'font-lock-builtin-face))))
                '(:eval evil-mode-line-tag)
                " %l:%c "
                ;; relative position, size of file
                " ["
                (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
                "/"
                (propertize "%I" 'face 'font-lock-constant-face) ;; size
                "]"
                '(:eval (propertize (or vc-mode "")
                                    'face 'font-lock-comment-face))
                projectile-mode-line
                ;; spaces to align right
                '(:eval (propertize
                         " " 'display
                         `((space :align-to (- (+ right right-fringe right-margin)
                                               ,(+ 3 (string-width mode-name)))))))
                ;; the current major mode
                (propertize " %m " 'face 'font-lock-string-face)))

;; Startup screen
(use-package dashboard
  :init
  (when (display-graphic-p)
    (add-hook 'after-init-hook #'dashboard-refresh-buffer))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-set-navigator t
        dashboard-set-init-info t
        dashboard-center-content t
        initial-buffer-choice (lambda () (get-buffer "*dashboard*"))
        dashboard-items '((recents  . 5)
                          (projects . 5))))

;; Window management proper
(setq split-width-threshold 120)
;; Windows should be able to be resized
(setq fit-window-to-buffer-horizontally t)
;;Ensure side windows maintain their respective sizes
(setq window-resize-pixelwise t)
(setq display-buffer-alist
      `(("\\*compilation\\*" display-buffer-in-side-window
         (side . bottom) (slot . 0) (preserve-size . (t . nil)))
        ("\\*\\(help\\|grep\\|xref\\)\\*" display-buffer-in-side-window
         (side . right) (slot . 0) (window-width . fit-window-to-buffer)
         (preserve-size . (nil . t)))
        ("\\*Man .*\\*" display-buffer-in-side-window
         ;; For some reason using fit-window-to-buffer on man pages makes the buffer tiny in width
         (side . right) (slot . 0))))

(add-hook 'compilation-finish-functions
          (lambda (buf str)
            (if (null (string-match ".*exited abnormally.*" str))
                ;;no errors, make the compilation window go away in a few seconds
                (progn
                  (run-at-time
                   "2 sec" nil 'delete-windows-on
                   (get-buffer-create "*compilation*"))
                  (message "No Compilation Errors!")))))

(setq compilation-scroll-output t)

(dang/generate-override-keymap dang/leader/def "w" "windows")
(dang/windows/def
  "b" 'balance-windows
  "D" '(delete-window :wk "delete-current-window")
  "K" '(kill-buffer-and-window :wk "delete-current-buffer-and-window")
  "m" '(toggle-frame-maximized :wk "maximize-frame-toggle")
  "M" 'maximize-window
  "S" '(split-window-below :wk "split-current-window-below")
  "t" '(window-toggle-side-windows :wk "toggle-side-windows")
  "V" '(split-window-right :wk "split-current-window-right"))

(defun dang/ace-kill-buffer-and-window ()
  (interactive)
  (aw-select " Ace - Kill Buffer and Window"
             #'kill-buffer-and-window))

(defun dang/ace-split-below ()
  (interactive)
  (aw-select " Ace - Split Below"
             #'aw-split-window-vert))

(defun dang/ace-split-right()
  (interactive)
  (aw-select " Ace - Split right"
             #'aw-split-window-horz))

(defun dang/ace-find-file (file &optional wildcards)
  "Use ace window to select a window for find-file"
  ;; We are going to use the same interactive setup as find-file and forward to it
  (interactive
   (find-file-read-args "Find file: "
                        (confirm-nonexistent-file-or-buffer)))
  (aw-select " Ace - Find File"
             (lambda (window)
               (aw-switch-to-window window)
               (find-file file wildcards))))

(use-package ace-window
  :commands (aw-select)
  :general
  (dang/windows/def
    "d" '(ace-delete-window :wk "delete-window") ;; Needed for some reason
    "f" '(ace-swap-window :wk "swap-windows")
    "k" '(dang/ace-kill-buffer-and-window :wk "delete-buffer-and-window")
    "o" '(ace-delete-other-windows :wk "delete-other-windows")
    "s" '(dang/ace-split-below :wk "split-window-below")
    "v" '(dang/ace-split-right :wk "split-window-right")
    "w" '(ace-window :wk "select-window"))
  (dang/files/def
    "o" '(dang/ace-find-file :wk "open-file"))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-swap-invert t
        aw-scope 'frame)
  (custom-set-faces
   '(aw-leading-char-face
     ((t (:inherit ace-jump-face-foreground :height 3.0))))))

;; Ensure we are allowed to use special narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Add mappings for text display manipulation
(dang/text/def
 "d" 'text-scale-decrease
 "i" 'text-scale-increase
 "n" '(nil :wk "narrow")
 "n f" 'narrow-to-defun
 "n p" 'narrow-to-page
 "n r" 'narrow-to-region
 "N" 'widen)

(provide 'dang/core-ui)
