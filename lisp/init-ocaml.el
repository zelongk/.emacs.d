;; -*- lexical-binding: t; -*-


(leaf tuareg
  :ensure t  
  :mode (("\\.ocamlinit\\'" . tuareg-mode))
  :config
  (setq tuareg-prettify-symbols-full t))

;; (leaf dune)

(leaf opam-switch-mode
  :ensure t
  :after tuareg
  :hook (tuareg-mode-hook . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(leaf ocp-indent
  :ensure t
  :after tuareg
  :hook (tuareg-mode-hook . ocp-setup-indent))

(leaf utop
  :ensure t
  :after tuareg)

(provide 'init-ocaml)
