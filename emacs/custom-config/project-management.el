(require 'dang/core-ui)

(setq dired-use-ls-dired nil)

(defun dang/dwim-toggle-or-open (&optional find-file-fn)
  "Toggle subtree or open the file."
  (interactive)
  (let ((find-file-fn (or find-file-fn 'dang/ace-find-file))
        (file (dired-get-file-for-visit)))
    (if (file-directory-p file)
      (progn (dired-subtree-cycle)
             (revert-buffer))
      (funcall-interactively find-file-fn file))))

(defun dang/mouse-dwim-toggle-or-open (event)
  "Toggle subtree or the open file on mouse-click in dired."
  (interactive "e")
  (let ((window (posn-window (event-end event)))
        (pos (posn-point (event-end event))))
    (select-window window)
    (goto-char pos)
    (dang/dwim-toggle-or-open)))

(defun dang/open-ace-horizontal-split ()
  "Toggle subtree or the open file in a horizontal split"
  (interactive)
  (dang/dwim-toggle-or-open
   (lambda (file &optional wildcards)
     (interactive)
     (select-window (dang/ace-split-right))
     (find-file file))))

(defun dang/open-ace-vertical-split ()
  "Toggle subtree or the open file in a vertical split"
  (interactive)
  (dang/dwim-toggle-or-open
   (lambda (file &optional wildcards)
     (interactive)
     (select-window (dang/ace-split-below))
     (find-file file))))

(defun dang/dired-copy-path-at-point ()
  "Put the absolute path to the file at point at the beginning of the
kill-ring"
  (interactive)
  (kill-new (dired-get-filename nil t)))

(defun dang/dired-copy-path-to-root ()
  "Put the absolute path to the root of the project (the
default-directory of the project explorer buffer) at the beginning of
the kill-ring"
  (interactive)
  (kill-new default-directory))

(use-package dired-subtree
  :demand t
  :general
  (dired-mode-map
   :states '(normal motion insert emacs)
   "<enter>" 'dang/dwim-toggle-or-open
   "<return>" 'dang/dwim-toggle-or-open
   "<tab>" 'dang/dwim-toggle-or-open
   "s" 'dang/open-ace-vertical-split
   "o" 'dang/dwim-toggle-or-open
   "v" 'dang/open-ace-horizontal-split
   "yr" 'dang/dired-copy-path-to-root
   "yy" 'dang/dired-copy-path-at-point
   ;; For weird historical reasons emacs translates mouse-1 clicks to
   ;; mouse-2 clicks for link events such as filenames in
   ;; dired... More info at:
   ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Clickable-Text.html
   "<mouse-2>" 'dang/mouse-dwim-toggle-or-open)
  :config
  (setq dired-subtree-use-backgrounds nil))

(defun dang/toggle-project-explorer ()
  "Toggle the project explorer window."
  (interactive)
  (let* ((buffer (dired-noselect (projectile-project-root)))
         (window (get-buffer-window buffer)))
    (if window
        (dang/hide-project-explorer)
      (dang/show-project-explorer))))

(defun dang/show-project-explorer ()
  "Project dired buffer on the side of the frame.
Shows the projectile root folder using dired on the left side of
the frame and makes it a dedicated window for that buffer."
  (let ((buffer (dired-noselect (projectile-project-root))))
    (with-current-buffer buffer
      (rename-buffer (format "*Explorer %s*" (projectile-project-name)))
      (dired-hide-details-mode t)
      (display-line-numbers-mode -1))
    (display-buffer-in-side-window buffer '((side . left) (window-width . 35)))
    (set-window-dedicated-p (get-buffer-window buffer) t)))

(defun dang/hide-project-explorer ()
  "Hide the project-explorer window."
  (let ((buffer (dired-noselect (projectile-project-root))))
    (progn
      (delete-window (get-buffer-window buffer))
      (kill-buffer buffer))))

(defun dang/projectile-ace-find-file (&optional invalidate-cache)
  "Jump to a project's file using completion using dang/ace-find-file as find-file replacmeent.
With a prefix arg INVALIDATE-CACHE invalidates the cache first."
  (interactive)
  (projectile--find-file invalidate-cache #'dang/ace-find-file))

;; This cannot go in the :init section because use-package tries to generate the autoloads before the keymap exists?
(dang/generate-override-keymap dang/leader/def "p" "project")
(use-package projectile
  :general
  (dang/project/def
   "a" '(projectile-find-other-file :wk "toggle-interface-implementation")
   "b" '(projectile-switch-to-buffer :wk "goto-buffer")
   "c" '(projectile-compile-project :wk "compile")
   "C" '(projectile-configure-project :wk "configure")
   "d" '(dang/toggle-project-explorer :wk "toggle-explorer")
   "e" '(projectile-edit-dir-locals :wk "project-dir-locals")
   "f" '(dang/projectile-ace-find-file :wk "project-find-file")
   "F" '(projectile-find-file :wk "project-find-file-current-window")
   "g" '(projectile-vc :wk "version-control")
   "I" '(projectile-invalidate-cache :wk "invalidate-project-cache")
   "k" '(projectile-kill-buffers :wk "kill-project-buffers")
   "p" '(projectile-switch-project :wk "open-project")
   "t" '(projectile-test-project :wk "test")
   "/" '(projectile-ripgrep :wk "grep"))
  :config
  (setq projectile-completion-system 'ivy
        projectile-enable-caching t)
  (add-to-list 'projectile-globally-ignored-directories "elpa")
  (projectile-mode 1))

(use-package nameframe
  :demand t)

(use-package nameframe-projectile
  :demand t
  :after nameframe
  :general
  (dang/project/def
    "P" '(nameframe-switch-frame :wk "switch-project"))
  :config
  (nameframe-projectile-mode t))

(provide 'dang/project-management)
