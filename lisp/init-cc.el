;; -*- lexical-binding: t; -*-

(use-package cc-mode
  :init (setq-default c-basic-offset 4))

(when (treesit-available-p)
  (use-package c-ts-mode
    :functions centaur-treesit-available-p
    :init
    (setq c-ts-mode-indent-offset 4)

    (when (boundp 'major-mode-remap-alist)
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
      (add-to-list 'major-mode-remap-alist
                   '(c-or-c++-mode . c-or-c++-ts-mode)))))

(use-package eglot
  :hook (c-mode . eglot-ensure)
  :hook (c++-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd")))

(provide 'init-cc)
