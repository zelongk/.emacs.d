;; -*- lexical-binding: t; -*-


(use-package gcmh
  :diminish
  :ensure t
  :hook (emacs-startup . gcmh-mode)
  :config
  (setq gcmh-high-cons-threshold #x4000000
        gcmh-idle-delay 'auto
        gcmh-auto-idle-delay-factor 10))

(provide 'init-gc)
