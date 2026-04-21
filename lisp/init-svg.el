;; -*- lexical-binding: t; -*-

(use-package svg-lib
  :ensure t)

(use-package svg-tag-mode
  :ensure t
  :hook (emacs-startup . global-svg-tag-mode))

(provide 'init-svg)
