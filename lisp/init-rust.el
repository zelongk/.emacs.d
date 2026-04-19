;; Rust  -*- lexical-binding: t; -*-
(use-package rust-mode
  :ensure t
  :defer t
  :config
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

(use-package ron-mode
  :ensure t
  :defer t
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
