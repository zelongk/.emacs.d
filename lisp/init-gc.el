;; -*- lexical-binding: t; -*-


(use-package gcmh
  :diminish
  :straight (:wait t) ;; what does this do in elpaca 
  :init
  (gcmh-mode 1)
  :config
  (setq gcmh-high-cons-threshold #x6400000))

(provide 'init-gc)
