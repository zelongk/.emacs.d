;; -*- lexical-binding: t; -*-


(use-package haskell-mode
  :hook (haskell-mode . haskell-collapse-mode)
  :hook (haskell-mode . interactive-haskell-mode)
  :mode (("\\.hs\\'" . haskell-mode))
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t)
  (add-hook 'haskell-mode-local-vars-hook #'lsp! 'append)
  (add-hook 'haskell-literate-mode-local-vars-hook #'lsp! 'append)
  (add-to-list 'completion-ignored-extensions ".hi")
  )


(provide 'init-haskell)
