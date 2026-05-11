;; -*- lexical-binding: t;-*-

;; (require 'compile)
(leaf typst-ts-mode
  :elpaca (typst-ts-mode :type git :host codeberg :repo "meow_king/typst-ts-mode")
  
  :hook (typst-ts-mode-hook . lsp-deferred)
  :config
  ;; (typst-ts-watch-options "--open")
  (setq typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory))
  (setq typst-ts-mode-enable-raw-blocks-highlight t)
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu)
  (setq typst-ts-preview-function 'find-file-other-window))

(leaf typst-preview
  :elpaca (typst-preview :type git :host github :repo "havarddj/typst-preview.el")
  :after typst-ts-mode
  :custom
  (typst-preview-browser . "default") ; this is the default option; other options are `eaf-browser' or `xwidget'.
  (typst-preview-invert-colors . "auto") ; invert colors depending on system theme
  (typst-preview-executable . "tinymist") ; path to tinymist binary (relative or absolute)
  (typst-preview-partial-rendering . t)   ; enable partial rendering

  :config
  (setq typst-preview-autostart t) ; start preview automatically when typst-preview-mode is activated
  (setq typst-preview-open-browser-automatically t) ; open browser automatically when typst-preview-start is run
  (define-key typst-ts-mode-map (kbd "C-c C-j") 'typst-preview-send-position)
  (define-key typst-ts-mode-map (kbd "C-c C-l") #'typst-preview-mode))

(provide 'init-typst)
