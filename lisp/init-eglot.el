;; -*- lexical-binding: t; -*-

(use-package flymake
  :hook (prog-mode)
  :diminish
  :functions my-elisp-flymake-byte-compile
  :bind ("C-c d" . flymake-show-buffer-diagnostics)
  :custom
  (flymake-no-changes-timeout nil)
  (flymake-fringe-indicator-position 'right-fringe)
  (flymake-margin-indicator-position 'right-margin)
  :config
  ;; Check elisp with `load-path'
  (defun my-elisp-flymake-byte-compile (fn &rest args)
    "Wrapper for `elisp-flymake-byte-compile'."
    (let ((elisp-flymake-byte-compile-load-path
           (append elisp-flymake-byte-compile-load-path load-path)))
      (apply fn args)))
  (advice-add 'elisp-flymake-byte-compile :around #'my-elisp-flymake-byte-compile))
  
(use-package flyover
  :diminish
  :hook flymake-mode
  :custom (flyover-checkers '(flymake)))

(use-package jsonrpc)

(use-package eglot
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p
                                 'emacs-lisp-mode 'lisp-mode
                                 'makefile-mode 'snippet-mode
                                 'ron-mode)
                          (eglot-ensure))))
            ((markdown-mode yaml-mode yaml-ts-mode) . eglot-ensure))
  :init (setq eglot-autoshutdown t
              eglot-events-buffer-config 0
              eglot-send-changes-idle-time 0.5)
  :bind (:map eglot-mode-map
	      ("C-c c a" . eglot-code-actions)))

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
