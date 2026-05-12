;; init-check --- Diagnostic -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf flymake
  :blackout t
  :bind ("C-c f" . flymake-show-buffer-diagnostics)
  :defun my/elisp-flymake-byte-compile
  :hook prog-mode-hook
  :custom
  (flymake-no-changes-timeout . nil)
  (flymake-fringe-indicator-position . 'right-fringe)
  (flymake-margin-indicator-position . 'right-margin)
  :init
  ;; Check elisp with `load-path'
  (defun my/elisp-flymake-byte-compile (fn &rest args)
    "Wrapper for `elisp-flymake-byte-compile'."
    (let ((elisp-flymake-byte-compile-load-path
           (append elisp-flymake-byte-compile-load-path load-path)))
      (apply fn args)))
  (advice-add 'elisp-flymake-byte-compile :around #'my/elisp-flymake-byte-compile))

(leaf flyover :ensure t
  :blackout t
  :hook flymake-mode-hook
  :config
  (setq flyover-checkers '(flymake)
        flyover-display-mode 'hide-on-same-line
        flyover-background-lightness 60
        flyover-icon-background-tint-percent 50))


(provide 'init-check)
;;; init-check.el ends here
