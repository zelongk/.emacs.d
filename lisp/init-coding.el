;; init-coding --- Utilities for coding -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf xref
  :init
  ;; Use faster search tool
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))

  ;; Select from xref candidates in minibuffer
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-completing-read))

(setq blink-matching-paren-highlight-offscreen t
      show-paren-context-when-offscreen 'child-frame)

(leaf eldoc
  :blackout t)

(leaf apheleia :ensure t
  :blackout t
  :hook prog-mode-hook)

(leaf editorconfig :ensure t)

(leaf treesit-auto :ensure t
  :global-minor-mode global-treesit-auto-mode
  :custom
  (treesit-auto-install . t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(add-hook 'prog-mode-hook #'toggle-truncate-lines)

(add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))

;; Support for some lang
(leaf elvish-mode :ensure t)

(leaf fish-mode :ensure t)

(leaf docker-compose-mode :ensure t)

(leaf ansible :ensure t)
(leaf ansible-doc :ensure t
  :after ansible)

(leaf systemd :ensure t)

(leaf caddyfile-mode :ensure t)

(leaf dot-env :ensure t)

(leaf envrc :ensure t)

(provide 'init-coding)
;;; init-coding.el ends here
