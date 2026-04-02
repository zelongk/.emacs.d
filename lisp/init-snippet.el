;; -*- lexical-binding: t; -*-

;; Yasnippet settings
(use-package yasnippet
  :diminish
  :hook (elpaca-after-init . yas-global-mode)
  :hook ((post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (elemacs-load-packages-incrementally '(eldoc easymenu help-mode))
  (use-package warnings
    :ensure nil
    :config
    (cl-pushnew '(yasnippet backquote-change)
                warning-suppress-types
                :test 'equal))

  (setq yas-triggers-in-field t)

  ;; Snippets trigger inside a word
  (setq yas-key-syntaxes (list #'yas-longest-key-from-whitespace "w_.()" "w_." "w_" "w"))

  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand)))))

;; Collection of yasnippet snippets
(use-package yasnippet-snippets)



(provide 'init-snippet)
