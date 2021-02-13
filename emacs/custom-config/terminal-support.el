(require 'term)
(require 'dang/core-editor "core-editor")

(push
 `("\\*\\(eshell\\|term\\).*\\*" display-buffer-in-side-window
   (side . bottom) (slot . 0)
   (preserve-size . (nil . t))) display-buffer-alist)

(defun dang/run-term (&optional term program)
  (interactive)
  (let* ((term (or term "term"))
         (program (or program (getenv "SHELL")))
         (buffer (set-buffer (make-term term program))))
    (term-mode)
    (term-char-mode)
    (pop-to-buffer buffer)))

(defun dang/projectile-run-term ()
  "Invoke `term' in the project's root.

Switch to the project specific term buffer if it already exists."
  (interactive)
  (let* ((project (projectile-ensure-project (projectile-project-root)))
         (term (concat "term " (projectile-project-name project)))
         (buffer (concat "*" term "*")))
    (projectile-with-default-dir project
      (dang/run-term term))))

(dang/files/def
  "'" '(dang/run-term :wk "term")
  "\"" '(eshell :wk "eshell"))

(dang/project/def
  "'" '(dang/projectile-run-term :wk "term")
  "\"" '(projectile-run-eshell :wk "eshell"))

(provide 'dang/terminal-support)
