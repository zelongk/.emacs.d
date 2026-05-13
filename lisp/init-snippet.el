;; init-snippet --- snippet -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; Yasnippet settings
(leaf yasnippet :ensure t
  :blackout yas-minor-mode
  :hook (((prog-mode-hook LaTeX-mode-hook
                          org-mode-hook yaml-ts-mode)
          . yas-minor-mode-on)
         (yas-minor-mode-hook . my/yas-auto-setup))
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
  :config 
  (yas-reload-all)

  ;; Snippets trigger inside a word
  ;; (setq yas-key-syntaxes (list #'yas-longest-key-from-whitespace "w_.()" "w_." "w_" "w"))
  (defun my/yas-try-2-suffix (pt)
    (skip-syntax-backward "w" (- (point) 2)))
  (defun my/yas-try-3-suffix (pt)
    (skip-syntax-backward "w" (- (point) 3)))
  (add-to-list 'yas-key-syntaxes #'my/yas-try-2-suffix)
  (add-to-list 'yas-key-syntaxes #'my/yas-try-3-suffix)

  (setq yas-triggers-in-field t
        yas-wrap-around-region t)

  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (defun my/yas-auto-setup ()
    (add-hook 'post-self-insert-hook #'my/yas-try-expanding-auto-snippets nil t))

  (with-eval-after-load 'corfu
    (defun my/yas-corfu-cancel ()
      "company-abort or yas-abort-snippet."
      (interactive)
      (if corfu--candidates
          (corfu-quit)
        (yas-abort-snippet)))
    (define-key yas-keymap (kbd "C-g") #'my/yas-corfu-cancel)))

(leaf consult-yasnippet
  :ensure t
  :after yasnippet
  :bind ("M-g y" . consult-yasnippet))

(leaf doom-snippets
  :vc (:url "https://github.com/doomemacs/snippets"))

(provide 'init-snippet)
;;; init-snippet.el ends here
