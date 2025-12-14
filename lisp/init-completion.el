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
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil)
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
  :init
  (vertico-mode t))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :init
  (marginalia-mode))

;; Consulting completing-read
(use-package consult
  :defines (xref-show-xrefs-function xref-show-definitions-function)
  :defines shr-color-html-colors-alist
  :autoload (consult-register-format consult-register-window consult-xref)
  :autoload (consult--read consult--customize-put)
  :commands (consult-narrow-help)
  :functions (list-colors-duplicates consult-colors--web-list)
  :bind (("s-f" . consult-line)
	 ("C-c s s" . consult-line)
	 ("C-c p f" . consult-project-buffer)
	 ("C-c f r" . consult-recent-file)
	 ("C-c s p" . consult-ripgrep)))
 

(use-package consult-dir
  :ensure t
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package embark
  :commands embark-prefix-help-command
  :bind (("C-;"   . embark-act)
         ("M-."   . embark-dwim)        ; overrides `xref-find-definitions'
         ([remap describe-bindings] . embark-bindings)
         :map minibuffer-local-map
         ("M-." . my-embark-preview))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command))
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
  (advice-add #'persistent-scratch-save :before #'corfu-quit))


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
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(provide 'init-completion)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-completion.el ends here
