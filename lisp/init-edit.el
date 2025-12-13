;; -*- lexical-binding: t -*-

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode))

(use-package winum
  :init
  (winum-mode)
  :config
  (winum-set-keymap-prefix (kbd "C-c w"))  )


(provide 'init-edit)
