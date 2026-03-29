;; -*- lexical-binding: t; -*-

(use-package eglot
  :commands (eglot eglot-ensure)
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p
                                 'emacs-lisp-mode 'lisp-mode
                                 'makefile-mode 'snippet-mode
                                 'lisp-interaction-mode
                                 'ron-mode)
                          (eglot-ensure))))
         ((markdown-mode yaml-mode yaml-ts-mode) . eglot-ensure))
  :bind (:map eglot-mode-map
	            ("C-c c a" . eglot-code-actions))
  :config
  (setq completion-category-defaults nil)
  (setq eglot-autoshutdown t
        eglot-events-buffer-config 0
        eglot-send-changes-idle-time 0.5
        eglot-code-action-indications '(eldoc-hint)))

(use-package eglot-booster
  :straight (eglot-booster :type git :host nil :repo "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode))

(use-package flycheck-eglot
  :hook (eglot-managed-mode . flycheck-eglot-mode))

(use-package consult-eglot
  :after consult eglot
  :bind (:map eglot-mode-map
	            ([remap xref-find-apropos] . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

;; (use-package eldoc-box
;;   :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode))

(use-package eldoc
  :ensure nil
  :diminish)

(use-package eldoc-mouse
  :diminish
  :hook eldoc-mode)

(provide 'init-eglot)
