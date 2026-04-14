;; -*- lexical-binding: t; -*-

(use-package grip-mode
  :ensure t
  :config (setq grip-command 'auto) ;; auto, grip, go-grip or mdopen
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode)))

(provide 'init-markdown)
