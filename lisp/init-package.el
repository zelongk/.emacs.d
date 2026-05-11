;; -*- lexical-binding: t; -*-

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")
                       ("gnu-devel" . "https://elpa.gnu.org/devel/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                       ("org" . "https://orgmode.org/elpa/")))
  (customize-set-variable
   'package-install-upgrade-built-in t)
  (customize-set-variable
   'package-quickstart t)
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    
    (leaf blackout :ensure t)
    (leaf transient :ensure t
      :config
      (transient-bind-q-to-quit)
      (setq transient-history-file (expand-file-name "transient/history.el" user-cache-directory)
            transient-levels-file (expand-file-name "transient/levels.el" user-cache-directory)
            transient-values-file (expand-file-name "transient/values.el" user-cache-directory)
            transient-show-popup t))

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

(setq leaf-expand-minimally t
      leaf-enable-imenu-support t)

(setq package-vc-register-as-project nil)

(provide 'init-package)
