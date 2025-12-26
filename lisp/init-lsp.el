;; -*- lexical-binding: t; -*-

(use-package lsp-mode
  :diminish
  :autoload lsp-enable-which-key-integration
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p
                                 'emacs-lisp-mode 'lisp-mode
                                 'makefile-mode 'snippet-mode
                                 'ron-mode)
                          (lsp-deferred))))
         ((markdown-mode yaml-mode yaml-ts-mode) . lsp-deferred)
         (lsp-mode . (lambda ()
                       ;; Integrate `which-key'
                       (lsp-enable-which-key-integration))))
  :bind (:map lsp-mode-map
              ("C-c c d" . lsp-describe-thing-at-point)
              ([remap xref-find-definitions] . lsp-find-definition)
              ([remap xref-find-references] . lsp-find-references))
  :init (setq lsp-use-plists t
              lsp-log-io nil

              lsp-keymap-prefix "C-c c"
              lsp-keep-workspace-alive nil
              lsp-signature-auto-activate nil
              lsp-modeline-code-actions-enable nil
              lsp-modeline-diagnostics-enable nil
              lsp-modeline-workspace-status-enable nil

              lsp-semantic-tokens-enable t
              lsp-progress-spinner-type 'progress-bar-filled

              lsp-enable-file-watchers nil
              lsp-enable-folding nil
              lsp-enable-symbol-highlighting nil
              lsp-enable-text-document-color nil

              lsp-enable-indentation nil
              lsp-enable-on-type-formatting nil)

  :config
  (use-package consult-lsp
    :bind (:map lsp-mode-map
                ("C-M-." . consult-lsp-symbols)))

  (use-package lsp-ui
    :custom-face
    (lsp-ui-sideline-code-action ((t (:inherit warning))))
    :pretty-hydra
    ((:color amaranth :quit-key ("q" "C-g"))
     ("Doc"
      (("d e" (progn
                (lsp-ui-doc-enable (not lsp-ui-doc-mode))
                (setq lsp-ui-doc-enable (not lsp-ui-doc-enable)))
        "enable" :toggle lsp-ui-doc-mode)
       ("d s" (setq lsp-ui-doc-include-signature (not lsp-ui-doc-include-signature))
        "signature" :toggle lsp-ui-doc-include-signature)
       ("d t" (setq lsp-ui-doc-position 'top)
        "top" :toggle (eq lsp-ui-doc-position 'top))
       ("d b" (setq lsp-ui-doc-position 'bottom)
        "bottom" :toggle (eq lsp-ui-doc-position 'bottom))
       ("d p" (setq lsp-ui-doc-position 'at-point)
        "at point" :toggle (eq lsp-ui-doc-position 'at-point))
       ("d h" (setq lsp-ui-doc-header (not lsp-ui-doc-header))
        "header" :toggle lsp-ui-doc-header)
       ("d f" (setq lsp-ui-doc-alignment 'frame)
        "align frame" :toggle (eq lsp-ui-doc-alignment 'frame))
       ("d w" (setq lsp-ui-doc-alignment 'window)
        "align window" :toggle (eq lsp-ui-doc-alignment 'window)))
      "Sideline"
      (("s e" (progn
                (lsp-ui-sideline-enable (not lsp-ui-sideline-mode))
                (setq lsp-ui-sideline-enable (not lsp-ui-sideline-enable)))
        "enable" :toggle lsp-ui-sideline-mode)
       ("s h" (setq lsp-ui-sideline-show-hover (not lsp-ui-sideline-show-hover))
        "hover" :toggle lsp-ui-sideline-show-hover)
       ("s d" (setq lsp-ui-sideline-show-diagnostics (not lsp-ui-sideline-show-diagnostics))
        "diagnostics" :toggle lsp-ui-sideline-show-diagnostics)
       ("s s" (setq lsp-ui-sideline-show-symbol (not lsp-ui-sideline-show-symbol))
        "symbol" :toggle lsp-ui-sideline-show-symbol)
       ("s c" (setq lsp-ui-sideline-show-code-actions (not lsp-ui-sideline-show-code-actions))
        "code actions" :toggle lsp-ui-sideline-show-code-actions)
       ("s i" (setq lsp-ui-sideline-ignore-duplicate (not lsp-ui-sideline-ignore-duplicate))
        "ignore duplicate" :toggle lsp-ui-sideline-ignore-duplicate))
      "Action"
      (("h" backward-char "←")
       ("j" next-line "↓")
       ("k" previous-line "↑")
       ("l" forward-char "→")
       ("C-a" mwim-beginning-of-code-or-line nil)
       ("C-e" mwim-end-of-code-or-line nil)
       ("C-b" backward-char nil)
       ("C-n" next-line nil)
       ("C-p" previous-line nil)
       ("C-f" forward-char nil)
       ("M-b" backward-word nil)
       ("M-f" forward-word nil)
       ("c" lsp-ui-sideline-apply-code-actions "apply code actions"))))
    :bind (("C-c u" . lsp-ui-imenu)
           :map lsp-ui-mode-map
           ("M-<f6>" . lsp-ui-hydra/body)
           ("s-<return>" . lsp-ui-sideline-apply-code-actions)
           ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
           ([remap xref-find-references] . lsp-ui-peek-find-references))
    :hook ((lsp-mode . lsp-ui-mode)
           (after-load-theme . lsp-ui-set-doc-border))
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
  
  (use-package lsp-pyright
    :functions lsp-pyright-format-buffer
    :hook (((python-mode python-ts-mode) . (lambda ()
                                             (require 'lsp-pyright)
                                             (add-hook 'after-save-hook #'lsp-pyright-format-buffer t t))))
    :init
    ;; (when (executable-find "python3")
    ;; (setq lsp-pyright-python-executable-cmd "python3"))
    
    (defun lsp-pyright-format-buffer ()
      "Use `yapf' to format the buffer."
      (interactive)
      (when (and (executable-find "yapf") buffer-file-name)
        (call-process "yapf" nil nil nil "-i" buffer-file-name))))
  
  (use-package ccls
    :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (require 'ccls)))
    :config
    (with-no-warnings
      ;; FIXME: fail to call ccls.xref
      ;; @see https://github.com/emacs-lsp/emacs-ccls/issues/109
      (cl-defmethod my-lsp-execute-command
        ((_server (eql ccls)) (command (eql ccls.xref)) arguments)
        (when-let* ((xrefs (lsp--locations-to-xref-items
                            (lsp--send-execute-command (symbol-name command) arguments))))
          (xref--show-xrefs xrefs nil)))
      (advice-add #'lsp-execute-command :override #'my-lsp-execute-command))))
          

(provide 'init-lsp)
