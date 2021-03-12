;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Daniel Grumberg"
      user-mail-address "dany.grumberg@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Etoile" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Disable this horror that is part of the core ui.
(remove-hook! (prog-mode text-mode conf-mode) #'hl-line-mode)
(setq global-hl-line-modes '(special-mode org-agenda-mode))

(setq +format-on-save-context 'modification)

(global-visual-line-mode +1)
(setq evil-respect-visual-line-mode +1)

;; Ensure that we move screen line instead of physical lines when
;; visual-line-mode is on and evil-respect-visual-line-mode is enabled.
(defun +evil-next-line-a (orig-fn &rest args)
  (if (and visual-line-mode evil-respect-visual-line-mode)
      (apply #'evil-next-visual-line args)
    (apply orig-fn args)))

(defun +evil-previous-line-a (orig-fn &rest args)
  (if (and visual-line-mode evil-respect-visual-line-mode)
      (apply #'evil-previous-visual-line args)
    (apply orig-fn args)))

(advice-add #'evil-next-line :around #'+evil-next-line-a)
(advice-add #'evil-previous-line :around #'+evil-previous-line-a)

;; Compilation mode specifics, this doesn't warrant further organization for nowk
(add-hook 'compilation-finish-functions
          (lambda (buf str)
            (if (null (string-match ".*exited abnormally.*" str))
                ;;no errors, make the compilation window go away in a few seconds
                (progn
                  (run-at-time
                   "5 sec" nil 'delete-windows-on
                   (get-buffer-create buf))
                  (message "No Compilation Errors!")))))
(setq compilation-scroll-output t)

;;
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

(add-to-list 'c-default-style '(c-mode . "llvm.org"))
(add-to-list 'c-default-style '(c++-mode . "llvm.org"))
