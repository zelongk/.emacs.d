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
      show-paren-context-when-offscreen 'child-frame)

(use-package apheleia
  :ensure t
  :defer t
  :diminish
  :hook prog-mode)

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


;; Keep focus in the current window when starting compilation
;; (defun my/compile-keep-focus (orig &rest args)
;;   (save-selected-window
;;     (apply orig args)))
;; (advice-add 'compile   :around #'my/compile-keep-focus)
;; (advice-add 'recompile :around #'my/compile-keep-focus)

(add-hook 'prog-mode-hook #'toggle-truncate-lines)

(add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))

;; Support for some lang
(use-package elvish-mode
  :ensure t
  :defer t)

(use-package fish-mode
  :ensure t
  :defer t)

(use-package docker-compose-mode
  :ensure t
  :defer t)

(use-package ansible
  :ensure t
  :defer t)
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
