;; -*- lexical-binding: t; -*-


(use-package haskell-mode
  :hook (haskell-mode . (haskell-collapse-mode
                         interactive-haskell-mode
                         haskell-doc-mode
                         hindent-mode))
  :mode (("\\.hs\\'" . haskell-mode))
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t)
  (add-to-list 'completion-ignored-extensions ".hi"))


(provide 'init-haskell)
