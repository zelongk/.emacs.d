;; -*- lexical-binding: t -*-

(use-package smartparens
  :demand t
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(use-package winum
  :init
  (winum-mode)
  :config
  (winum-set-keymap-prefix (kbd "C-c w")))

;; Yasnippet settings
(use-package yasnippet
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (use-package warnings
    :config
    (cl-pushnew '(yasnippet backquote-change)
                warning-suppress-types
                :test 'equal))

  (setq yas-triggers-in-field t)
  
  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand)))))


(provide 'init-edit)
