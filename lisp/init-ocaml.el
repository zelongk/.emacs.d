;; -*- lexical-binding: t; -*-


(use-package tuareg
  :straight t
  :mode (("\\.ocamlinit\\'" . tuareg-mode))
  :config
  (setq tuareg-prettify-symbols-full t))

;; (use-package dune)

(use-package opam-switch-mode
  :hook (tuareg-mode . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(use-package ocp-indent
  :hook (tuareg-mode . ocp-setup-indent))

(use-package utop)

;; (use-package ocaml-eglot
;;   :straight t
;;   :after tuareg
;;   :hook (tuareg-mode . ocaml-eglot)
;;   :hook (ocaml-eglot . eglot-ensure)
;;   :config
;;   (setq ocaml-eglot-syntax-checker 'flycheck))


;; (use-package merlin
;;   :hook (tuareg-mode . +ocaml-init-merlin)
;;   :init
;;   (defun +ocaml-init-merlin ()
;;     (when (executable-find "ocamlmerlin")
;;       (merlin-mode)))
;;   :config
;;   (setq merlin-completion-with-doc t))

;; (use-package merlin-eldoc
;;   :hook (merlin-mode . merlin-eldoc-setup))

(use-package flycheck-ocaml)



(provide 'init-ocaml)
