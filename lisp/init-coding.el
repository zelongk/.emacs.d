;; -*- lexical-binding: t -*-

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

(leaf apheleia
  :elpaca t
  :blackout t
  :hook prog-mode-hook)

(leaf editorconfig
  :elpaca t)

(leaf treesit-auto
  :elpaca t
  :hook (prog-mode-hook . treesit-auto-mode)
  :custom
  (treesit-auto-install . 'prompt)
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
(leaf elvish-mode
  :elpaca t
  )

(leaf fish-mode
  :elpaca t
  )

(leaf docker-compose-mode
  :elpaca t
  )

(leaf ansible
  :elpaca t
  )
(leaf ansible-doc
  :elpaca t
  :after ansible)

(leaf systemd
  :elpaca t
  )

(leaf caddyfile-mode
  :elpaca t
  )

(leaf dotenv-mode
  :elpaca t
  )

(leaf envrc :elpaca t)

(provide 'init-coding)
