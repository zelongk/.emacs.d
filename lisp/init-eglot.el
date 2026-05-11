;; -*- lexical-binding: t; -*-

(leaf eglot
  :commands (eglot eglot-ensure)
  :hook ((prog-mode-hook . (lambda ()
                             (unless (derived-mode-p
                                      'emacs-lisp-mode 'lisp-mode
                                      'makefile-mode 'snippet-mode
                                      'lisp-interaction-mode
                                      'ron-mode)
                               (eglot-ensure))))
         ((markdown-mode-hook yaml-mode-hook yaml-ts-mode-hook) . eglot-ensure))
  :bind (:eglot-mode-map
	     ("C-c c a" . eglot-code-actions))
  :config
  (setq completion-category-defaults nil)
  (setq eglot-autoshutdown t
        eglot-events-buffer-config 0
        eglot-send-changes-idle-time 0.5
        eglot-code-action-indications '(eldoc-hint)))

(leaf eglot-booster
  :elpaca (eglot-booster :type git :host nil :repo "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode))

(leaf flycheck-eglot
  :after eglot
  :hook (eglot-managed-mode-hook . flycheck-eglot-mode))

(leaf consult-eglot
  :after consult
  :after eglot
  :bind (:eglot-mode-map
	     ([remap xref-find-apropos] . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

;; (leaf eldoc-box
;;   :hook (eglot-managed-mode-hook . eldoc-box-hover-at-point-mode))

(leaf eldoc-mouse
  :after eldoc
  :hook eldoc-mode-hook)

(provide 'init-eglot)
