;; -*- lexical-binding: t;-*-

(use-package rime
  :custom
  (default-input-method "rime")
  (rime-librime-root "/opt/homebrew")
  (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/"))

(provide 'init-input)
