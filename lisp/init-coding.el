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

(use-package apheleia :diminish
  :hook (prog-mode))

(use-package editorconfig
  :diminish
  :hook elpaca-after-init)

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
