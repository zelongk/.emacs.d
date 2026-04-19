;; -*- lexical-binding: t; -*-


(use-package tuareg
  :ensure t
  :defer t
  :mode (("\\.ocamlinit\\'" . tuareg-mode))
  :config
  (setq tuareg-prettify-symbols-full t))

;; (use-package dune)

(use-package opam-switch-mode
  :ensure t
  :after tuareg
  :hook (tuareg-mode . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(use-package ocp-indent
  :ensure t
  :after tuareg
  :hook (tuareg-mode . ocp-setup-indent))

(use-package utop
  :ensure t
  :after tuareg)

(use-package ocaml-eglot
  :disabled t
  :ensure t
  :after tuareg
  :hook (tuareg-mode . ocaml-eglot)
  :hook (ocaml-eglot . eglot-ensure)
  :config
  (setq ocaml-eglot-syntax-checker 'flycheck))


(provide 'init-ocaml)
