;; -*- lexical-binding: t -*-

(use-package xref
  :ensure nil
  :init
  ;; Use faster search tool
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))

  ;; Select from xref candidates in minibuffer
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-completing-read))

(use-package apheleia
  :diminish
  :hook (elpaca-after-init . apheleia-global-mode))

(use-package editorconfig
  :diminish
  :hook elpaca-after-init)

(use-package cask-mode)
(use-package csv-mode)
(use-package cue-sheet-mode)
(use-package dart-mode)
(use-package lua-mode)
(use-package v-mode)
(use-package vimrc-mode)
(use-package julia-ts-mode)
(use-package scala-ts-mode)
(use-package yaml-ts-mode
  :ensure nil
  :mode ("\\.yaml\\'" . yaml-ts-mode))

;; Fish shell mode and auto-formatting
(use-package fish-mode
  :commands fish_indent-before-save
  :defines eglot-server-programs
  :hook (fish-mode . (lambda ()
                       "Integrate `fish_indent` formatting with Fish shell mode."
                       (add-hook 'before-save-hook #'fish_indent-before-save)))
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(fish-mode . ("fish-lsp" "start")))))

(use-package docker-compose-mode)

(use-package treesit-auto
  :hook (elpaca-after-init . global-treesit-auto-mode)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(use-package systemd)

(add-hook 'prog-mode-hook #'toggle-truncate-lines)

(provide 'init-coding)
