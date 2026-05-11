;; -*- lexical-binding: t; -*-


(leaf haskell-mode
  :ensure t
  
  :hook (haskell-mode-hook . (lambda ()
                               (haskell-collapse-mode)
                               (interactive-haskell-mode)
                               (turn-on-haskell-doc)))
  :mode (("\\.hs\\'" . haskell-mode))
  :bind ("C-c C-z" . run-haskell)
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t)
  (add-to-list 'completion-ignored-extensions ".hi"))

;; (leaf haskell-ts-mode
;;   :ensure t
;;   :leaf-defer t
;;   :custom
;;   (haskell-ts-font-lock-level . 4)
;;   (haskell-ts-use-indent t)
;;   (haskell-ts-ghci "ghci")
;;   (haskell-ts-use-indent t)
;;   :config
;;   (add-to-list 'major-mode-remap-alist '(haskell-mode . haskell-ts-mode)))

(provide 'init-haskell)
