;; -*- lexical-binding: t -*-

(use-package delsel
  :hook (elpaca-after-init . delete-selection-mode))

(use-package electric-pair-mode
  :hook elpaca-after-init
  :config
  (dolist (mode '(LaTeX-mode-hook org-mode-hook))
    (add-hook mode
              (lambda ()
                (setq-local electric-pair-pairs
                            (append electric-pair-pairs '((?\\ . ?\\))))
                (setq-local electric-pair-text-pairs electric-pair-pairs)))))

(use-package puni
  :ensure t
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
              ("s-[" . puni-barf-backward)
              ("s-]" . puni-barf-forward)
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

(use-package combobulate
  :disabled
  :ensure (:host github :repo "mickeynp/combobulate")
  :hook prog-mode
  :config
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-c o")
  )

(use-package abbrev
  :init
  (setq-default abbrev-mode t)
  (setq abbrev-file-name (expand-file-name "abbrev.el" user-emacs-directory)))


(use-package autorevert
  :diminish
  :hook (elpaca-after-init . global-auto-revert-mode))

(use-package goto-addr
  :defer
  :hook ((text-mode . goto-address-mode)
         (prog-mode . goto-address-prog-mode)))

(use-package macrursors
  :ensure (:host github :repo "karthink/macrursors"
                 :branch "expand-region")
  :hook elpaca-after-init
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
         ("C-; C-j" . macrursors-end)
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
  :ensure t
  :bind (([remap move-beginning-of-line] . mwim-beginning)
         ([remap move-end-of-line] . mwim-end)))

(use-package avy
  :ensure t
  :bind
  (("C-'" . avy-goto-char-timer)
   :map isearch-mode-map
   ("C-'" . avy-isearch))
  :config
  (setq avy-all-windows nil
        avy-all-windows-alt t
        avy-background nil
        avy-style 'at-full))

;; Kill text between cursor and char
(use-package avy-zap
  :ensure t
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

(use-package ace-pinyin
  :ensure t
  :diminish
  :hook (elpaca-after-init . ace-pinyin-global-mode))

;; show number of matches
(use-package anzu
  :ensure t
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (elpaca-after-init . global-anzu-mode))

;; Goto last change
(use-package goto-chg
  :ensure t
  :bind ("C-," . goto-last-change))

;; Treat undo history as a tree
(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols))

;; Remember undo history
(use-package undo-fu-session
  :ensure t
  :hook (elpaca-after-init . undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-directory (expand-file-name "undo-fu-session" user-cache-directory)))

;; Process
(use-package proced
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3
        proced-enable-color-flag t))

(use-package olivetti
  :ensure t
  :hook org-mode
  :bind (("<f7>" . olivetti-mode))
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  (olivetti-body-width 90)
  (olivetti-minimum-body-width 76))

(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right
              bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(provide 'init-edit)
