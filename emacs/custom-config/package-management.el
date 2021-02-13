(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(eval-when-compile
  (require 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(provide 'dang/package-management)
