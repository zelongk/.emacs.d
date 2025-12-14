;; Rust  -*- lexical-binding: t; -*-
(use-package rust-mode
  :functions centaur-treesit-available-p
  :init (setq rust-format-on-save t
              rust-mode-treesitter-derive (centaur-treesit-available-p)))

(use-package ron-mode
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
