;; init-package --- Setup package.el -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
                         ("nongnu-elpa" . "https://elpa.nongnu.org/nongnu/"))
      package-archive-priorities '(("gnu-elpa-devel" . 3)
                                   ("nongnu-elpa" . 2)
                                   ("melpa" . 1))
      package-install-upgrade-built-in t
      package-vc-register-as-project nil)

(unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))

(setq leaf-expand-minimally t
      leaf-enable-imenu-support t)

(leaf leaf-keywords :ensure t
  :init
  ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
  (leaf blackout :ensure t)
  :config
  ;; initialize leaf-keywords.el
  (leaf-keywords-init))


(provide 'init-package)
;;; init-package.el ends here
