;; -*- lexical-binding: t; -*-

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")
                       ("gnu-devel" . "https://elpa.gnu.org/devel/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (customize-set-variable
   'package-archive-priorities '(("melpa" . 3)
                                 ("gnu" . 2)
                                 ("nongnu" . 1)))
  (setq package-install-upgrade-built-in t
        package-quickstart-file (expand-file-name "quickstart.el" user-cache-directory))
  ;; (package-initialize)
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
    (leaf-keywords-init)))
;; </leaf-install-code>

(setq package-vc-register-as-project nil)

(provide 'init-package)
