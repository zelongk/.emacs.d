;; init-lsp --- Powerful lsp client -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf lsp-mode
  :ensure t
  :defvar (lsp-diagnostics-disabled-modes lsp-clients-python-library-directories)
  :leaf-autoload lsp-enable-which-key-integration
  :commands (lsp-format-buffer lsp-organize-imports lsp lsp-deferred)
  :hook ((prog-mode-hook . (lambda ()
                             (unless (derived-mode-p
                                      'dotenv-mode
                                      'caddyfile-mode 'elvish-mode
                                      'emacs-lisp-mode 'lisp-mode
                                      'makefile-mode 'snippet-mode
                                      'lisp-data-mode 'ron-mode)
                               (lsp-deferred))))
         ((markdown-mode yaml-mode yaml-ts-mode) . lsp-deferred)
         (lsp-mode . (lambda ()
                       ;; Integrate `which-key'
                       (lsp-enable-which-key-integration)
                       ;; (add-hook 'before-save-hook #'lsp-format-buffer t t)
                       (add-hook 'before-save-hook #'lsp-organize-imports t t)))
         (lsp-completion-mode . my/lsp-mode-setup-completion))
  :bind
  (:lsp-mode-map
   ("C-c C-d" . lsp-describe-thing-at-point)
   ([remap xref-find-definitions] . lsp-find-definition)
   ([remap xref-find-references] . lsp-find-references))
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))
  
  (setq lsp-use-plists t
        lsp-log-io nil
        lsp-session-file (expand-file-name "lsp-sessions" user-cache-directory)

        lsp-enable-suggest-server-download t
        lsp-auto-configure t

        lsp-keymap-prefix "C-c c"
        lsp-keep-workspace-alive nil
        lsp-signature-auto-activate nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil
        lsp-modeline-workspace-status-enable nil

        lsp-completion-enable t
        lsp-completion-provider :none ;; using corfu
        lsp-completion-enable-additional-text-edit t
        lsp-enable-snippet t
        lsp-completion-show-kind t

        lsp-semantic-tokens-enable t
        lsp-progress-spinner-type 'progress-bar-filled

        lsp-enable-file-watchers nil
        lsp-enable-folding nil
        lsp-enable-symbol-highlighting nil
        lsp-enable-text-document-color nil
        lsp-enable-imenu t

        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil

        ;; For diagnostics
        lsp-diagnostics-disabled-modes '(markdown-mode gfm-mode))
  :config
  (with-no-warnings
    ;; Disable `lsp-mode' in `git-timemachine-mode'
    (defun my/lsp--init-if-visible (fn &rest args)
      (unless (bound-and-true-p git-timemachine-mode)
        (apply fn args)))
    (advice-add #'lsp--init-if-visible :around #'my/lsp--init-if-visible))

  ;; Enable `lsp-mode' in sh/bash/zsh
  (defun my/lsp-bash-check-sh-shell (&rest _)
    (and (memq major-mode '(sh-mode bash-ts-mode))
         (memq sh-shell '(sh bash zsh))))
  (advice-add #'lsp-bash-check-sh-shell :override #'my/lsp-bash-check-sh-shell)
  (add-to-list 'lsp-language-id-configuration '(bash-ts-mode . "shellscript")))

(leaf consult-lsp
  :ensure t
  :after lsp-mode
  :bind
  (:lsp-mode-map
   ("C-M-." . consult-lsp-symbols)))

(leaf lsp-ui
  :ensure t
  :after lsp-mode
  :blackout t
  :custom-face
  (lsp-ui-sideline-code-action . '((t (:inherit warning))))
  :bind
  (("C-c u" . lsp-ui-imenu))
  (:lsp-ui-mode-map
   ("s-<return>" . lsp-ui-sideline-apply-code-actions)
   ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
   ([remap xref-find-references] . lsp-ui-peek-find-references))
  :hook ((lsp-mode-hook . lsp-ui-mode)
         (after-load-theme-hook . lsp-ui-set-doc-border))
  :init
  (setq lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-delay 0.1
        lsp-ui-doc-show-with-cursor (not (display-graphic-p))
        lsp-ui-imenu-auto-refresh 'after-save
        lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                              ,(face-foreground 'font-lock-string-face)
                              ,(face-foreground 'font-lock-constant-face)
                              ,(face-foreground 'font-lock-variable-name-face))))

(leaf lsp-ui
  :bind (:lsp-ui-mode-map
         ("M-<f6>" . lsp-ui-transient-menu))
  :after transient lsp-ui
  :transient
  (lsp-ui-transient-menu
   ()
   "LSP UI Configuration"
   :transient-suffix 'transient--do-stay
   [["Doc"
     ("de" "enable" lsp-ui-doc-mode) ; Note: transient-infix-mode automatically handles toggle
     ;; ("ds" "signature" lsp-ui-doc-include-signature)
     ("dt" "top" (lambda () (interactive) (setq lsp-ui-doc-position 'top)))
     ("db" "bottom" (lambda () (interactive) (setq lsp-ui-doc-position 'bottom)))
     ("dp" "at point" (lambda () (interactive) (setq lsp-ui-doc-position 'at-point)))
     ("df" "align frame" (lambda () (interactive) (setq lsp-ui-doc-alignment 'frame)))
     ("dw" "align window" (lambda () (interactive) (setq lsp-ui-doc-alignment 'window)))]
    
    ["Navigation"
     ("h" "←" backward-char)
     ("j" "↓" next-line)
     ("k" "↑" previous-line)
     ("l" "→" forward-char)
     ("C-a" "start code" mwim-beginning-of-code-or-line)
     ("C-e" "end code" mwim-end-of-code-or-line)]
    
    ["Action"
     ("c" "apply code" lsp-ui-sideline-apply-code-actions)
     ("C-b" "back char" backward-char)
     ("C-n" "next line" next-line)
     ("C-p" "prev line" previous-line)
     ("C-f" "fwd char" forward-char)]]))

(leaf lsp-haskell :ensure t
  :after lsp-mode)

(leaf lsp-ltex-plus
  :vc (:url "https://github.com/emacs-languagetool/lsp-ltex-plus")
  :after lsp-mode
  :init
  (setq lsp-ltex-plus-version "18.6.1"
        lsp-ltex-plus-active-modes '(text-mode bibtex-mode context-mode
                                               latex-mode LaTeX-mode markdown-mode
                                               gfm-mode rst-mode message-mode
                                               mu4e-compose-mode)
        lsp-ltex-plus-user-rules-path (expand-file-name "lsp-ltex-plus" user-cache-directory)))

(provide 'init-lsp)
;;; init-lsp.el ends here
