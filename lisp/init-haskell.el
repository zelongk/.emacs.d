;; -*- lexical-binding: t; -*-


(use-package haskell-mode
  :hook (haskell-mode . (lambda ()
                          (haskell-collapse-mode)
                          (interactive-haskell-mode)
                          (haskell-doc-mode)
                          (haskell-indent-mode)))
  :mode (("\\.hs\\'" . haskell-mode))
  :bind ("C-c C-z" . run-haskell)
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t)
  (add-to-list 'completion-ignored-extensions ".hi"))

(use-package haskell-ts-mode
  :custom
  (haskell-ts-font-lock-level 4)
  (haskell-ts-use-indent t)
  (haskell-ts-ghci "ghci")
  (haskell-ts-use-indent t)
  :config
  (add-to-list 'major-mode-remap-alist '(haskell-mode . haskell-ts-mode)))


(use-package lsp-haskell)

(provide 'init-haskell)
