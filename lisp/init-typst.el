;; -*- lexical-binding: t;-*-

;; (require 'compile)
(leaf typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode")
  :bind
  (:typst-ts-mode-map
   ("C-c C-c" . typst-ts-tmenu))
  :config
  (setq typst-ts-mode-enable-raw-blocks-highlight t
        typst-ts-preview-function 'find-file-other-window))

(leaf typst-preview
  :vc (:url "https://github.com/havarddj/typst-preview.el")
  :bind
  (:typst-ts-mode-map
   ("C-c C-j" . typst-preview-send-position)
   ("C-c C-l" . typst-preview-mode))
  :custom
  (typst-preview-browser . "default")
  (typst-preview-invert-colors . "auto")
  (typst-preview-executable . "tinymist")
  (typst-preview-partial-rendering . t)

  :config
  (setq typst-preview-autostart t)
  (setq typst-preview-open-browser-automatically t))

(provide 'init-typst)
