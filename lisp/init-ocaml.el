;; -*- lexical-binding: t; -*-


(leaf tuareg
  :elpaca t
  
  :mode (("\\.ocamlinit\\'" . tuareg-mode))
  :config
  (setq tuareg-prettify-symbols-full t))

;; (leaf dune)

(leaf opam-switch-mode
  :elpaca t
  :after tuareg
  :hook (tuareg-mode-hook . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(leaf ocp-indent
  :elpaca t
  :after tuareg
  :hook (tuareg-mode-hook . ocp-setup-indent))

(leaf utop
  :elpaca t
  :after tuareg)

(leaf ocaml-eglot
  :disabled t
  :elpaca t
  :after tuareg
  :hook (tuareg-mode-hook . ocaml-eglot)
  :hook (ocaml-eglot-hook . eglot-ensure)
  :config
  (setq ocaml-eglot-syntax-checker 'flycheck))


(provide 'init-ocaml)
