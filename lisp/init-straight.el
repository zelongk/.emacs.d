;; init-straight --- A package manager -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'leaf)
(straight-use-package 'leaf-keywords)
(require 'leaf)
(require 'leaf-keywords)
(leaf-keywords-init)
(setq leaf-expand-minimally t
      leaf-enable-imenu-support t
      leaf-alias-keyword-alist '((:ensure . :straight)))

(leaf leaf-keywords
  :init
  ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
  (leaf blackout :ensure t)
  :config
  ;; initialize leaf-keywords.el
  )
  


(provide 'init-straight)
;;; init-straight.el ends here
