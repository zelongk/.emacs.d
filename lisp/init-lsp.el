;; -*- lexical-binding: t; -*-

(use-package flymake)

(use-package eglot
     :hook ((prog-mode . (lambda ()
                           (unless (derived-mode-p
                                    'emacs-lisp-mode 'lisp-mode
                                    'makefile-mode 'snippet-mode
                                    'ron-mode)
                             (eglot-ensure))))
            ((markdown-mode yaml-mode yaml-ts-mode) . eglot-ensure))
     :init (setq eglot-autoshutdown t
                 eglot-events-buffer-size 0
                 eglot-send-changes-idle-time 0.5))

(use-package eglot-booster
  :ensure (eglot-booster :type git :host nil :repo "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode))

(use-package consult-eglot
  :after consult eglot
  :bind (:map eglot-mode-map
	      ("C-M-." . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

(provide 'init-lsp)
