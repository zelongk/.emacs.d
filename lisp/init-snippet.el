;; -*- lexical-binding: t; -*-

;; Yasnippet settings
(use-package yasnippet
  :ensure t
  :defer 
  :diminish
  :hook (((prog-mode LaTeX-mode org-mode
                     eval-expression-minibuffer-setup)
          . yas-minor-mode-on)
         (yas-minor-mode . my/yas-auto-setup))
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

(use-package doom-snippets
  :ensure (doom-snippets :type git :host github :repo "doomemacs/snippets" :files ("*.el" "*")
                         :post-build
                         (let ((default-directory
                                (file-name-as-directory
                                 (file-name-concat
                                  elpaca-builds-directory
                                  "doom-snippets"
                                  "latex-mode"))))
                           (unless (file-directory-p default-directory)
                             (make-directory default-directory 'parents))
                           (with-temp-buffer
                             (write-file ".yas-skip")))) ;; Ignore their latex-mode snippets
  :after yasnippet)

(use-package consult-yasnippet
  :ensure t
  :after yasnippet
  :bind ("M-g y" . consult-yasnippet))

(provide 'init-snippet)
