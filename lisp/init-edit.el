;; -*- lexical-binding: t -*-

(use-package delsel
  :ensure nil
  :hook (elpaca-after-init . delete-selection-mode))

(use-package electric-pair-mode
  :ensure nil
  :hook elpaca-after-init
  :config
  (dolist (mode '(LaTeX-mode-hook org-mode-hook))
    (add-hook mode
              (lambda ()
                (setq-local electric-pair-pairs
                            (append electric-pair-pairs '((?\\ . ?\\))))
                (setq-local electric-pair-text-pairs electric-pair-pairs)))))

(use-package puni
  :hook (elpaca-after-init . puni-global-mode)
  :custom
  (puni-confirm-when-delete-unbalanced-active-region nil)
  :bind (:map puni-mode-map
              ("M-r" . puni-raise)
              ("M-s" . puni-splice)
              ("M-S" . puni-split)
              ("DEL" . my-backspace)
              ("C-=" . puni-expand-region)
              ("M-[" . puni-slurp-backward)
              ("M-]" . puni-slurp-forward)
              ;; ("M-<left>" . puni-slurp-backward)
              ;; ("M-<right>" . puni-slurp-forward)
              ("C-M-[" . puni-barf-backward)
              ("C-M-]" . puni-barf-forward)
              ;; ("C-M-<left>" . puni-barf-backward)
              ;; ("C-M-<right>" . puni-barf-forward)
              ([remap backward-kill-word] . puni-backward-kill-word)
              )
  :init
  (defun my-backspace ()
    (interactive)
    (if (looking-back (rx line-start (+ blank)))
        (delete-region (line-beginning-position) (point))
      (puni-backward-delete-char))))

;; (use-package combobulate
;;   :ensure (:host github :repo "mickeynp/combobulate")
;;   :hook prog-mode
;;   :config
;;   ;; You can customize Combobulate's key prefix here.
;;   ;; Note that you may have to restart Emacs for this to take effect!
;;   (setq combobulate-key-prefix "C-c o")
;;   )

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

(use-package macrursors
  :hook elpaca-after-init
  :ensure (:host github :repo "karthink/macrursors"
                 :branch "expand-region")
  :bind-keymap ("C-;" . macrursors-mark-map)
  :bind (("C-<" . macrursors-mark-previous-line)
         ("C->" . macrursors-mark-next-line)
         ("M-P" . macrursors-mark-previous-instance-of)
         ("M-N" . macrursors-mark-next-instance-of)
         ("C-M-;" . macrursors-mark-all-instances-of)
         ("C-c SPC" . macrursors-select)
         :map isearch-mode-map
         ("C-;" . macrursors-mark-from-isearch)
         ("M-s n" . macrursors-mark-next-from-isearch)
         ("M-s p" . macrursors-mark-previous-from-isearch)
         :map macrursors-mode-map
         ("C-'" . macrursors-hideshow)
         ("C-;" . nil)
         ("C-; C-;" . macrursors-end)
         :map macrursors-mark-map
         ("C-n" . macrursors-mark-next-line)
         ("C-p" . macrursors-mark-previous-line)
         ("." . macrursors-mark-all-instances-of)
         ("o" . macrursors-mark-all-instances-of)
         ("SPC" . macrursors-select)
         ("l" . macrursors-mark-all-lists)
         ("s" . macrursors-mark-all-symbols)
         ("w" . macrursors-mark-all-words)
         ("C-M-e" . macrursors-mark-all-sexps)
         ("d" . macrursors-mark-all-defuns)
         ("n" . macrursors-mark-all-numbers)
         (")" . macrursors-mark-all-sentences)
         ("M-e" . macrursors-mark-all-sentences)
         ("e" . macrursors-mark-all-lines))
  
  :init
  (define-prefix-command 'macrursors-mark-map)
  (use-package macrursors-select
    :defer nil :ensure nil
    :bind (:map macrursors-mark-map
                ("C-g" . macrursors-select-clear))))

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
  :hook (elpaca-after-init . undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-directory (expand-file-name "undo-fu-session" user-cache-directory)))

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
  (olivetti-body-width 80))

(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right
              bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(provide 'init-edit)
