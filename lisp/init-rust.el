;; Rust  -*- lexical-binding: t; -*-
(leaf rust-mode
  :ensure t
 
  :config
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

(leaf ron-mode
  :ensure t
 
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
