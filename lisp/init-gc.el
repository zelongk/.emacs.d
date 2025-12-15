;; -*- lexical-binding: t; -*-


(use-package gcmh
  :init
  (gcmh-mode 1)
  :config
  (setq gcmh-high-cons-threshold #x6400000))

(provide 'init-gc)
