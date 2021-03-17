;;; lang/llvm/autoload/tablegen.el -*- lexical-binding: t; -*-

;; Stolen from the LLVM Project using license Apache 2.0 License with LLVM exceptions

(require 'comint)
(require 'custom)
(require 'ansi-color)

;; Create mode-specific tables.
;;; Code:

(defvar td-decorators-face 'td-decorators-face
  "Face method decorators.")
(make-face 'td-decorators-face)

(defvar tablegen-font-lock-keywords
  (let ((kw (regexp-opt '("class" "defm" "def" "field" "include" "in"
                         "let" "multiclass" "foreach" "if" "then" "else"
                         "defvar" "defset")
                        'words))
        (type-kw (regexp-opt '("bit" "bits" "code" "dag" "int" "list" "string")
                             'words))
        )
    (list
     ;; Comments
;;     '("\/\/" . font-lock-comment-face)
     ;; Strings
     '("\"[^\"]+\"" . font-lock-string-face)
     ;; Hex constants
     '("\\<0x[0-9A-Fa-f]+\\>" . font-lock-preprocessor-face)
     ;; Binary constants
     '("\\<0b[01]+\\>" . font-lock-preprocessor-face)
     ;; Integer literals
     '("\\<[-]?[0-9]+\\>" . font-lock-preprocessor-face)
     ;; Floating point constants
     '("\\<[-+]?[0-9]+\.[0-9]*\([eE][-+]?[0-9]+\)?\\>" . font-lock-preprocessor-face)

     '("^[ \t]*\\(@.+\\)" 1 'td-decorators-face)
     ;; Keywords
     kw
     ;; Type keywords
     type-kw
     ))
  "Additional expressions to highlight in TableGen mode.")

;; ---------------------- Syntax table ---------------------------

(defvar tablegen-mode-syntax-table nil
  (let ((table (make-syntax-table)))
        ;; whitespace (` ')
        (modify-syntax-entry ?\   " "      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\t  " "      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\r  " "      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\n  " "      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\f  " "      tablegen-mode-syntax-table)
        ;; word constituents (`w')
        (modify-syntax-entry ?\%  "w"      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\_  "w"      tablegen-mode-syntax-table)
        ;; comments
        (modify-syntax-entry ?/   ". 124b" tablegen-mode-syntax-table)
        (modify-syntax-entry ?*   ". 23"   tablegen-mode-syntax-table)
        (modify-syntax-entry ?\n  "> b"    tablegen-mode-syntax-table)
        ;; open paren (`(')
        (modify-syntax-entry ?\(  "("      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\[  "("      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\{  "("      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\<  "("      tablegen-mode-syntax-table)
        ;; close paren (`)')
        (modify-syntax-entry ?\)  ")"      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\]  ")"      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\}  ")"      tablegen-mode-syntax-table)
        (modify-syntax-entry ?\>  ")"      tablegen-mode-syntax-table)
        ;; string quote ('"')
        (modify-syntax-entry ?\"  "\""     tablegen-mode-syntax-table)
        table)
  "Syntax table used while in TableGen mode.")

;; Emacs 23 compatibility
(defalias 'tablegen-mode-prog-mode
  (if (fboundp 'prog-mode)
      'prog-mode
    'fundamental-mode))

;;;###autoload
(define-derived-mode tablegen-mode tablegen-mode-prog-mode "TableGen"
  "Major mode for editing TableGen source files."
  (setq-local font-lock-defaults `(table-gen-font-lock-keywords)
              comment-start "//"
              indent-tabs-mode nil))

;;;###autoload
(add-to-list 'auto-mode-alist (cons "\\.td\\'" 'tablegen-mode))

(provide 'tablegen-mode)
