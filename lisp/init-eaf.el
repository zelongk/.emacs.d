;; -*- lexical-binding: t; -*-

(leaf eaf
  :leaf-defer nil
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework/"
  :custom ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  ;; (browse-url-browser-function 'eaf-open-browser)
  :defvar eaf-pdf-viewer-keybinding
  :config
  (require 'eaf-pdf-viewer)
  (require 'eaf-music-player)
  ;; (require 'eaf-jupyter)
  (require 'eaf-mindmap)
  (require 'eaf-markdown-previewer)
  (require 'eaf-system-monitor)
  (require 'eaf-js-video-player)
  (require 'eaf-image-viewer)
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  )





(provide 'init-eaf)
