;; -*- lexical-binding: t; -*-

(leaf eglot
  :commands (eglot eglot-ensure)
  :hook ((markdown-mode-hook yaml-mode-hook
                             yaml-ts-mode-hook prog-mode-hook
                             LaTeX-mode-hook typst-ts-mode-hook)
         . eglot-ensure)
  :defvar eglot-server-programs
  :bind (:eglot-mode-map
	     ("C-c c a" . eglot-code-actions))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format 'short)
        eglot-send-changes-idle-time 0.5
        eglot-code-action-indications '(eldoc-hint))

  (add-to-list 'eglot-server-programs '((typst-ts-mode) "tinymist")))

(leaf consult-eglot :ensure t
  :after eglot consult
  :bind (:eglot-mode-map
	     ([remap xref-find-apropos] . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(leaf eldoc-mouse :ensure t
  :blackout t
  :hook eglot-managed-mode-hook)

(provide 'init-eglot)
