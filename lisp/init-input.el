;; -*- lexical-binding: t;-*-

(leaf rime
  :elpaca t
  :custom
  (default-input-method . "rime")
  (rime-librime-root . "/opt/homebrew")
  ;; (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/")
  (rime-show-candidate . 'popup)
  (rime-popup-properties . nil))

(provide 'init-input)
