;; -*- lexical-binding: t -*-

(use-package delsel
  :ensure nil
  :hook (elpaca-after-init . delete-selection-mode))

(use-package electric-pair-mode
  :ensure nil
  :hook elpaca-after-init)

(use-package puni
  :hook (elpaca-after-init . puni-global-mode)
  :bind (:map puni-mode-map
              ("M-s" . puni-splice)
              ("DEL" . my-backspace))
  :init
  (defun my-backspace ()
    (interactive)
    (if (looking-back (rx line-start (+ blank)))
        (delete-region (line-beginning-position) (point))
      (puni-backward-delete-char))))

;; ;; Hungry deletion
;; (use-package hungry-delete
;;   :diminish
;;   :hook (elpaca-after-init . global-hungry-delete-mode)
;;   :init (setq hungry-delete-chars-to-skip " \t\f\v"
;;               backward-delete-char-untabify-method 'all
;;               hungry-delete-except-modes
;;               '(help-mode minibuffer-mode minibuffer-inactive-mode calc-mode)))

(use-package abbrev
  :ensure nil
  :diminish
  :config
  (setq-default abbrev-mode t)
  (setq abbrev-file-name (expand-file-name "abbrev.el" user-emacs-directory)))

(use-package autorevert
  :ensure nil
  :diminish
  :hook (elpaca-after-init . global-auto-revert-mode))

(use-package goto-addr
  :ensure nil
  :hook ((text-mode . goto-address-mode)
         (prog-mode . goto-address-prog-mode)))

(use-package multiple-cursors
  :hook elpaca-after-init
  :bind (("C-S-c C-S-c"   . mc/edit-lines)
         ("C->"           . mc/mark-next-like-this)
         ("C-<"           . mc/mark-previous-like-this)
         ("C-c C-<"       . mc/mark-all-like-this)
         ("C-M->"         . mc/skip-to-next-like-this)
         ("C-M-<"         . mc/skip-to-previous-like-this)
         ("s-<mouse-1>"   . mc/add-cursor-on-click)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)
         :map mc/keymap
         ("C-|" . mc/vertical-align-with-space)))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package mwim
  :bind (([remap move-beginning-of-line] . mwim-beginning)
         ([remap move-end-of-line] . mwim-end)))

(use-package avy
  :bind
  (("C-'" . avy-goto-char-timer))
  :config
  (setq avy-all-windows nil
        avy-all-windows-alt t
        avy-background t
        avy-style 'pre))

;; Kill text between cursor and char
(use-package avy-zap
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

(use-package ace-pinyin
  :diminish
  :hook (elpaca-after-init . ace-pinyin-global-mode))

;; show number of matches
(use-package anzu
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (elpaca-after-init . global-anzu-mode))

;; Goto last change
(use-package goto-chg
  :bind ("C-," . goto-last-change))

;; Treat undo history as a tree
(use-package vundo
  :bind ("C-x u" . vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols))

;; Remember undo history
(use-package undo-fu-session
  :hook (elpaca-after-init . undo-fu-session-global-mode))

;; Process
(use-package proced
  :ensure nil
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3
        proced-enable-color-flag t))

(use-package olivetti
  :hook org-mode
  :diminish
  :bind (("<f7>" . olivetti-mode))
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  (olivetti-body-width 90))

(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right
              bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(provide 'init-edit)
