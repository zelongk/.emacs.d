;;; init-completion.el --- Initialize completion configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2016-2025 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; Modern completion configuration.
;;


;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles orderless partial-completion))))
  (orderless-component-separator #'orderless-escapable-split-on-space))

;; Support Pinyin
(use-package pinyinlib
  :after orderless
  :functions orderless-regexp
  :autoload pinyinlib-build-regexp-string
  :init
  (defun orderless-regexp-pinyin (str)
    "Match COMPONENT as a pinyin regex."
    (orderless-regexp (pinyinlib-build-regexp-string str)))
  (add-to-list 'orderless-matching-styles 'orderless-regexp-pinyin))

;; VERTical Interactive COmpletion
(use-package vertico
  :custom (vertico-count 15)
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (elpaca-after-init . vertico-mode)
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))


;; (use-package vertico-posframe
;;   :after vertico
;;   :hook (vertico-mode . vertico-posframe-mode))

(use-package vertico-multiform
  :ensure nil
  :hook (vertico-mode . vertico-multiform-mode)
  :config
  (defvar +vertico-transform-functions nil)

  (cl-defmethod vertico--format-candidate :around
    (cand prefix suffix index start &context ((not +vertico-transform-functions) null))
    (dolist (fun (ensure-list +vertico-transform-functions))
      (setq cand (funcall fun cand)))
    (cl-call-next-method cand prefix suffix index start))

  (defun +vertico-highlight-directory (file)
    "If FILE ends with a slash, highlight it as a directory."
    (when (string-suffix-p "/" file)
      (add-face-text-property 0 (length file) 'marginalia-file-priv-dir 'append file))
    file)

  (defun +vertico-highlight-enabled-mode (cmd)
    "If MODE is enabled, highlight it as font-lock-constant-face."
    (let ((sym (intern cmd)))
      (with-current-buffer (nth 1 (buffer-list))
        (if (or (eq sym major-mode)
                (and
                 (memq sym minor-mode-list)
                 (boundp sym)
                 (symbol-value sym)))
            (add-face-text-property 0 (length cmd) 'font-lock-constant-face 'append cmd)))
      cmd))

  (add-to-list 'vertico-multiform-categories
               '(file
                 (+vertico-transform-functions . +vertico-highlight-directory)))
  (add-to-list 'vertico-multiform-commands
               '(execute-extended-command
                 (+vertico-transform-functions . +vertico-highlight-enabled-mode))))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :hook (elpaca-after-init . marginalia-mode))


;; Add icons to completion candidates
(use-package nerd-icons-completion
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

;; Consulting completing-read
(use-package consult
  :commands consult-customize
  :bind (("C-." . consult-imenu)
	       ("C-c T" . consult-theme)
	       ([remap Info-search]        . consult-info)
         ;; ([remap isearch-forward]    . consult-line)
         ([remap recentf-open-files] . consult-recent-file)
         ([remap bookmark-jump] . consult-bookmark)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)

         ;; M-g bindings in `search-map'
	       ("s-f" . consult-line)
         ("M-g d" . consult-find)                  ;; Alternative: consult-fd
         ("M-g c" . consult-locate)
         ("M-g G" . consult-git-grep)
         ("M-g r" . consult-ripgrep)
         ("M-g l" . consult-line)
         ("M-g L" . consult-line-multi)
         ("M-g k" . consult-keep-lines)
         ("M-g u" . consult-focus-lines)
	       ("C-x C-r" . consult-recent-file)
	       ("C-x b" . consult-buffer)

         ("M-g e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-g e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-g l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-g L" . consult-line-multi))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; (use-package consult-projectile)
(use-package consult-flycheck)

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-yasnippet
  :bind ("M-g y" . consult-yasnippet))

(use-package embark
  :commands embark-prefix-help-command
  :bind (("C-;"   . embark-act)
         ("M-."   . embark-dwim)        ; overrides `xref-find-definitions'
         ([remap describe-bindings] . embark-bindings)
         :map minibuffer-local-map
         ("M-." . my-embark-preview))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (eval-when-compile
    (defmacro my/embark-ace-action (fn)
      `(defun ,(intern (concat "my/embark-ace-" (symbol-name fn))) ()
         (interactive)
         (with-demoted-errors "%s"
           (require 'ace-window)
           (let ((aw-dispatch-always t))
             (aw-switch-to-window (aw-select nil))
             (call-interactively (symbol-function ',fn)))))))

  (define-key embark-file-map     (kbd "o") (my/embark-ace-action find-file))
  (define-key embark-buffer-map   (kbd "o") (my/embark-ace-action switch-to-buffer))
  (define-key embark-bookmark-map (kbd "o") (my/embark-ace-action bookmark-jump))
  (eval-when-compile
    (defmacro my/embark-split-action (fn split-type)
      `(defun ,(intern (concat "my/embark-"
                               (symbol-name fn)
                               "-"
                               (car (last  (split-string
                                            (symbol-name split-type) "-"))))) ()
         (interactive)
         (funcall #',split-type)
         (call-interactively #',fn))))

  (define-key embark-file-map     (kbd "2") (my/embark-split-action find-file split-window-below))
  (define-key embark-buffer-map   (kbd "2") (my/embark-split-action switch-to-buffer split-window-below))
  (define-key embark-bookmark-map (kbd "2") (my/embark-split-action bookmark-jump split-window-below))

  (define-key embark-file-map     (kbd "3") (my/embark-split-action find-file split-window-right))
  (define-key embark-buffer-map   (kbd "3") (my/embark-split-action switch-to-buffer split-window-right))
  (define-key embark-bookmark-map (kbd "3") (my/embark-split-action bookmark-jump split-window-right)))

(use-package embark-consult
  :bind (:map minibuffer-mode-map
              ("C-c C-o" . embark-export))
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Auto completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-count 12)
  (corfu-preview-current nil)
  (corfu-on-exact-match nil)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  (global-corfu-modes '((not erc-mode
                             circe-mode
                             help-mode
                             gud-mode
                             vterm-mode)
                        t))
  :custom-face
  (corfu-border ((t (:inherit region :background unspecified))))
  :bind ("M-/" . completion-at-point)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :config
  ;;Quit completion before saving
  (add-hook 'before-save-hook #'corfu-quit)
  (advice-add #'persistent-scratch-save :before #'corfu-quit)
  (add-to-list 'corfu-continue-commands #'corfu-move-to-minibuffer)
  (use-package nerd-icons-corfu
    :init
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)))


;; A few more useful configurations...
(use-package emacs
  :ensure nil
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  (text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package cape
  :commands (cape-file cape-elisp-block cape-keyword)
  :autoload (cape-wrap-noninterruptible cape-wrap-nonexclusive cape-wrap-buster)
  :autoload (cape-wrap-silent)
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; Make these capfs composable.
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'comint-completion-at-point :around #'cape-wrap-nonexclusive)
  ;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  ;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive))

;; (use-package yasnippet-capf
;;   :after cape
;;   :config
;;   (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(provide 'init-completion)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-completion.el ends here
