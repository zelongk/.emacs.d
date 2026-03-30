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


(provide 'init-haskell)
