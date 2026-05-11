;; -*- lexical-binding: t; -*-

(when (treesit-available-p)
  (leaf c-ts-mode
    
    :commands treesit-available-p
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
