;; -*- lexical-binding: t; -*-

;; Yasnippet settings
(use-package yasnippet
  :diminish
  :hook (elpaca-after-init . yas-global-mode)
  :hook ((post-self-insert . my/yas-try-expanding-auto-snippets))
  :commands (yas-minor-mode-on
             yas-expand
             yas-expand-snippet
             yas-lookup-snippet
             yas-insert-snippet
             yas-new-snippet
             yas-visit-snippet-file
             yas-activate-extra-mode
             yas-deactivate-extra-mode
             yas-maybe-expand-abbrev-key-filter)
  :init
  (defvar yas-verbosity 2)
  ;; :config
  ;; (elemacs-load-packages-incrementally '(eldoc easymenu help-mode))
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

(use-package doom-snippets
  :after yasnippet
  :ensure (doom-snippets :type git :host github :repo "doomemacs/snippets" :files ("*.el" "*")))

(provide 'init-snippet)
