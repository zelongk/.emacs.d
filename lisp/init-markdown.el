;; -*- lexical-binding: t; -*-

(use-package grip-mode
  :ensure t
  :defer t
  :config (setq grip-command 'auto) ;; auto, grip, go-grip or mdopen
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode)))

(add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))

(provide 'init-markdown)
