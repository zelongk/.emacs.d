;; -*- lexical-binding: t; -*-

(leaf grip-mode
  :elpaca t
  
  :config (setq grip-command 'auto)) ;; auto, grip, go-grip or mdopen

(add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))

(provide 'init-markdown)
