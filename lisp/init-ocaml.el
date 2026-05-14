;; init-ocaml --- Ocaml -*- lexical-binding: t; -*-


;;; Commentary:
;;  Blablabla

;;; Code:

(leaf tuareg
  :ensure t  
  :mode (("\\.ocamlinit\\'" . tuareg-mode))
  :config
  (setq tuareg-prettify-symbols-full t))

(leaf opam-switch-mode :ensure t
  :hook (tuareg-mode-hook . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(leaf ocp-indent
  :ensure t
  :hook (tuareg-mode-hook . ocp-setup-indent))

(leaf utop
  :ensure t)

(leaf ocaml-eglot :ensure t
  :hook
  (tuareg-mode-hook . ocaml-eglot)
  (ocaml-eglot-mode-hook . eglot-ensure))

(provide 'init-ocaml)
;;; init-ocaml.el ends here
