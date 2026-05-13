;; init-package --- Setup package.el and leaf.el -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; <leaf-install-code>
(eval-and-compile
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu-elpa" . "https://elpa.gnu.org/packages/")
                           ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
                           ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
        package-archive-priorities '(("gnu-elpa" . 3)
                                     ("melpa" . 2)
                                     ("nongnu" . 1))
        package-install-upgrade-built-in t
        package-quickstart-file (expand-file-name "quickstart.el" user-cache-directory))
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (setq leaf-expand-minimally t
        leaf-enable-imenu-support t)
  
  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf blackout :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))
  ;; </leaf-install-code>

  (setq package-vc-register-as-project nil))

(provide 'init-package)
;;; init-package.el ends here
