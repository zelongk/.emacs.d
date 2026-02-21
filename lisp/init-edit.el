;; -*- lexical-binding: t -*-

;; (use-package smartparens
;;   :demand t
;;   :hook (prog-mode text-mode markdown-mode)
;;   :config
;;   (require 'smartparens-config))

(use-package smartparens
  :hook (elpaca-after-init . smartparens-global-mode)
  ;; :hook (elpaca-after-init . smartparens-global-strict-mode)
  :init (sp-use-paredit-bindings)
  :config
    ;; Autopair quotes more conservatively; if I'm next to a word/before another
    ;; quote, I don't want to open a new pair or it would unbalance them.
    (let ((unless-list '(sp-point-before-word-p
                         sp-point-after-word-p
                         sp-point-before-same-p)))
      (sp-pair "'"  nil :unless unless-list)
      (sp-pair "\"" nil :unless unless-list))
    (dolist (brace '("(" "{" "["))
      (sp-pair brace nil
               :post-handlers '(("||\n[i]" "RET") ("| " "SPC"))
               ;; Don't autopair opening braces if before a word character or
               ;; other opening brace. The rationale: it interferes with manual
               ;; balancing of braces, and is odd form to have s-exps with no
               ;; whitespace in between, e.g. ()()(). Insert whitespace if
               ;; genuinely want to start a new form in the middle of a word.
               :unless '(sp-point-before-word-p sp-point-before-same-p)))
    
    (sp-local-pair sp-lisp-modes "(" ")" :unless '(:rem sp-point-before-same-p))
    
    ;; Don't do square-bracket space-expansion where it doesn't make sense to
    (sp-local-pair '(emacs-lisp-mode org-mode markdown-mode markdown-ts-mode gfm-mode)
                   "[" nil :post-handlers '(:rem ("| " "SPC")))
    )

;; Hungry deletion
(use-package hungry-delete
  :diminish
  :hook (elpaca-after-init . global-hungry-delete-mode)
  :init (setq hungry-delete-chars-to-skip " \t\f\v"
              hungry-delete-except-modes
              '(help-mode minibuffer-mode minibuffer-inactive-mode calc-mode)))
    
;; Yasnippet settings
(use-package yasnippet
  :ensure t
  :hook (elpaca-after-init . yas-global-mode)
  :hook ((LaTeX-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (use-package warnings
    :ensure nil
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

(setq-default abbrev-mode t)
(setq abbrev-file-name (expand-file-name "abbrev.el" user-emacs-directory))

(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package multiple-cursors
  :hook elpaca-after-init
  :bind (("C-c m" . multiple-cursors-hydra/body)
         ("C-S-c C-S-c"   . mc/edit-lines)
         ("C->"           . mc/mark-next-like-this)
         ("C-<"           . mc/mark-previous-like-this)
         ("C-c C-<"       . mc/mark-all-like-this)
         ("C-M->"         . mc/skip-to-next-like-this)
         ("C-M-<"         . mc/skip-to-previous-like-this)
         ("s-<mouse-1>"   . mc/add-cursor-on-click)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)
         :map mc/keymap
         ("C-|" . mc/vertical-align-with-space))
  :pretty-hydra
  ((:color amaranth :quit-key ("q" "C-g") :hint nil)
   ("Up"
	(("p" mc/mark-previous-like-this "prev")
	 ("P" mc/skip-to-previous-like-this "skip")
	 ("M-p" mc/unmark-previous-like-this "unmark")
     ("|" mc/vertical-align "align with input CHAR"))
    "Down"
    (("n" mc/mark-next-like-this "next")
	 ("N" mc/skip-to-next-like-this "skip")
	 ("M-n" mc/unmark-next-like-this "unmark"))
    "Misc"
    (("l" mc/edit-lines "edit lines" :exit t)
	 ("a" mc/mark-all-like-this "mark all" :exit t)
	 ("s" mc/mark-all-in-region-regexp "search" :exit t)
     ("<mouse-1>" mc/add-cursor-on-click "click"))
    "% 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")"
	(("0" mc/insert-numbers "insert numbers" :exit t)
	 ("A" mc/insert-letters "insert letters" :exit t)))))

(use-package smart-region
  :hook (after-init . smart-region-on))

(use-package mwim
  :bind (([remap move-beginning-of-line] . mwim-beginning)
         ([remap move-end-of-line] . mwim-end)))

(use-package avy
  :bind
  (("C-'" . avy-goto-char-timer)))

;; Treat undo history as a tree
(use-package vundo
  :bind ("C-x u" . vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols))

(use-package olivetti
  :hook org-mode
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  (olivetti-body-width 90))

(provide 'init-edit)
