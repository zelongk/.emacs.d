;; -*- lexical-binding: t;-*-


(use-package typst-ts-mode
  :ensure (:type git :host codeberg :repo "meow_king/typst-ts-mode")
  :hook (typst-ts-mode . lsp-deferred)
  :custom
  ;; (typst-ts-watch-options "--open")
  (typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory))
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu)
  (setq typst-ts-preview-function 'find-file-other-window))

(use-package typst-preview
  :ensure (:type git :host github :repo "havarddj/typst-preview.el")
  :init
  (setq typst-preview-autostart t) ; start preview automatically when typst-preview-mode is activated
  (setq typst-preview-open-browser-automatically t) ; open browser automatically when typst-preview-start is run

  :custom
  (typst-preview-browser "default") ; this is the default option; other options are `eaf-browser' or `xwidget'.
  (typst-preview-invert-colors "auto") ; invert colors depending on system theme
  (typst-preview-executable "tinymist") ; path to tinymist binary (relative or absolute)
  (typst-preview-partial-rendering t)   ; enable partial rendering

  :config
  (define-key typst-ts-mode-map (kbd "C-c C-j") 'typst-preview-send-position)
  (define-key typst-ts-mode-map (kbd "C-c C-l") #'typst-preview-mode))



(provide 'init-typst)
