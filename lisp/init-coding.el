;; -*- lexical-binding: t -*-

(use-package xref
  :init
  ;; Use faster search tool
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))

  ;; Select from xref candidates in minibuffer
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-completing-read))

(setq blink-matching-paren-highlight-offscreen t
      show-paren-context-when-offscreen 'overlay)

(use-package apheleia
  :ensure t
  :defer t
  :diminish
  :hook (prog-mode))

(use-package eldoc
  :defer
  :diminish)

(use-package editorconfig
  :ensure t
  :diminish)

(use-package treesit-auto
  :ensure t
  :hook (prog-mode . treesit-auto-mode)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(add-hook 'prog-mode-hook #'toggle-truncate-lines)


;; Support for some lang
(use-package elvish-mode
  :ensure t
  :defer t)

(use-package docker-compose-mode
  :ensure t
  :defer t
  :hook yaml-ts-mode)

(use-package ansible
  :ensure t
  :defer t
  :hook yaml-ts-mode)
(use-package ansible-doc
  :ensure t
  :after ansible)

(use-package systemd
  :ensure t
  :defer t)

(use-package caddyfile-mode
  :ensure t
  :defer t)

(use-package dotenv-mode
  :ensure t
  :defer t)

(use-package envrc :ensure t :defer)

(provide 'init-coding)
