;; Rust  -*- lexical-binding: t; -*-
(leaf rust-mode
  :elpaca t
 
  :config
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

(leaf ron-mode
  :elpaca t
 
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
