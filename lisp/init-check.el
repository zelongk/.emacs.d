;; -*- lexical-binding: t; -*-

(use-package flycheck :ensure t
  :defer t
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit)

  ;; Rerunning checks on every newline is a mote excessive.
  (delq 'new-line flycheck-check-syntax-automatically)

  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  ;; And don't recheck on idle as often
  (setq flycheck-idle-change-delay 1.0

        ;; For the above functionality, check syntax in a buffer that you switched to
        ;; only briefly. This allows "refreshing" the syntax check state for several
        ;; buffers quickly after e.g. changing a config file.
        flycheck-buffer-switch-check-intermediate-buffers t

        ;; Display errors a little quicker (default is 0.9s)
        flycheck-display-errors-delay 0.25))

(use-package consult-flycheck :ensure t
  :after flycheck)

(use-package flyover :ensure t
  ;; :disabled t
  :diminish
  :after flycheck
  :hook flycheck-mode
  :config
  ;; Disable flyover-mode in emacs-lisp-mode
  (add-hook 'emacs-lisp-mode-hook (lambda () (flyover-mode -1)))
  (setq flyover-checkers '(flycheck)
        flyover-display-mode 'hide-on-same-line
        flyover-background-lightness 60
        flyover-icon-background-tint-percent 50))


(provide 'init-check)
