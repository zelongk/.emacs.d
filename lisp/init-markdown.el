;; init-markdown --- Markdown -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf grip-mode
  :ensure t
  
  :config (setq grip-command 'auto)) ;; auto, grip, go-grip or mdopen

(add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))

(provide 'init-markdown)
;;; init-markdown.el ends here
