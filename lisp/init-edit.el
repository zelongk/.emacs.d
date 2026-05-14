;; init-edit --- Better editing experience -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(setq long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(leaf delsel
  :global-minor-mode delete-selection-mode)

(leaf elec-pair
  :global-minor-mode electric-pair-mode)

(leaf puni :ensure t
  :hook prog-mode-hook
  :custom
  (puni-confirm-when-delete-unbalanced-active-region . nil)
  :bind
  ("M-r" . puni-raise)
  ("M-s" . puni-splice)
  ("M-S" . puni-split)
  ("C-=" . puni-expand-region)
  ("M-[" . puni-slurp-backward)
  ("M-]" . puni-slurp-forward)
  ("s-[" . puni-barf-backward)
  ("s-]" . puni-barf-forward)
  ("C-(" . puni-wrap-round)
  ("C-{" . puni-wrap-curly)
  ([remap backward-kill-word] . puni-backward-kill-word)
  :bind* ("DEL" . my/backspace)
  :init
  (defun my/backspace ()
    (interactive)
    (if (looking-back (rx line-start (+ blank)))
        (delete-region (line-beginning-position) (point))
      (puni-backward-delete-char))))

(leaf combobulate
  :disabled t
  :vc (:url "https://github.com/mickeynp/combobulate")
  :config
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-c o"))

(leaf abbrev
  :blackout t
  :init
  (setq-default abbrev-mode t)
  (setq abbrev-file-name (expand-file-name "abbrev.el" user-emacs-directory)))


(leaf autorevert
  :global-minor-mode global-auto-revert-mode)

(leaf goto-addr
  :hook (((text-mode-hook org-mode-hook) . goto-address-mode)
         (prog-mode . goto-address-prog-mode)))

(define-prefix-command 'macrursors-mark-map)
(leaf macrursors
  :blackout t
  :vc (:url "https://github.com/karthink/macrursors" :branch "expand-region")
  :global-minor-mode macrursors-mode
  :bind-keymap ("C-;" . macrursors-mark-map)
  :bind
  ("C-c C-<" . macrursors-mark-previous-line)
  ("C-c C->" . macrursors-mark-next-line)
  ("M-P" . macrursors-mark-previous-instance-of)
  ("M-N" . macrursors-mark-next-instance-of)
  ("C-M-;" . macrursors-mark-all-instances-of)
  ("C-c SPC" . macrursors-select)
  (:isearch-mode-map
   ("C-;" . macrursors-mark-from-isearch)
   ("M-s n" . macrursors-mark-next-from-isearch)
   ("M-s p" . macrursors-mark-previous-from-isearch))
  (:macrursors-mode-map
   ("C-;" . nil)
   ("C-; C-;" . macrursors-end)
   ("C-; C-j" . macrursors-end))
  (:macrursors-mark-map
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
  (leaf macrursors-select
    :bind (:macrursors-mark-map
           ("C-g" . macrursors-select-clear))))

(leaf mwim :ensure t
  :bind
  ([remap move-beginning-of-line] . mwim-beginning)
  ([remap move-end-of-line] . mwim-end))

(leaf avy :ensure t
  :bind
  ("C-'" . avy-goto-char-timer)
  (:isearch-mode-map
   ("C-'" . avy-isearch))
  :config
  (setq avy-all-windows nil
        avy-all-windows-alt t
        avy-background nil
        avy-style 'at-full))

;; Kill text between cursor and char
(leaf avy-zap :ensure t
  :bind
  ("M-z" . avy-zap-to-char-dwim)
  ("M-Z" . avy-zap-up-to-char-dwim))

(leaf ace-pinyin :ensure t
  :blackout t
  :global-minor-mode ace-pinyin-global-mode)

;; show number of matches
(leaf anzu :ensure t
  :blackout t
  :bind
  ([remap query-replace] . anzu-query-replace)
  ([remap query-replace-regexp] . anzu-query-replace-regexp)
  (:isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :global-minor-mode global-anzu-mode)

;; Goto last change
(leaf goto-chg :ensure t
  :bind ("C-," . goto-last-change))

;; Treat undo history as a tree
(leaf vundo :ensure t
  :bind ("C-x u" . vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols))

;; Remember undo history
(leaf undo-fu-session :ensure t
  :global-minor-mode undo-fu-session-global-mode
  :config
  (setq undo-fu-session-directory (expand-file-name "undo-fu-session" user-cache-directory)))

(leaf olivetti :ensure t
  :hook org-mode-hook
  :bind (("<f7>" . olivetti-mode))
  :custom
  (olivetti-style . 'fancy)
  (olivetti-margin-width . 5)
  (olivetti-body-width . 90)
  (olivetti-minimum-body-width . 40))

(provide 'init-edit)
;;; init-edit.el ends here
