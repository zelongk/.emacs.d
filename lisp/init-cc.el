;; -*- lexical-binding: t; -*-

(use-package cc-mode
  :defer
  :init (setq-default c-basic-offset 2))


(when (treesit-available-p)
  (use-package c-ts-mode
    :defer
    :functions treesit-available-p
    :init
    (setq c-ts-mode-indent-offset 2)
    (setq-default c-basic-offset 2)

    (when (boundp 'major-mode-remap-alist)
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
      (add-to-list 'major-mode-remap-alist
                   '(c-or-c++-mode . c-or-c++-ts-mode)))))

(with-eval-after-load 'eglot
  (add-hook 'c-ts-mode-hook #'eglot-ensure)
  (add-hook 'c++-ts-mode-hook #'eglot-ensure)
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd")))


(provide 'init-cc)
