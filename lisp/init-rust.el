;; Rust  -*- lexical-binding: t; -*-
(use-package rust-mode
  :config
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

(use-package ron-mode
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
