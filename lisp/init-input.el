;; init-input ---  Input methods -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf rime
  :ensure t
  :custom
  (default-input-method . "rime")
  (rime-librime-root . "/opt/homebrew")
  ;; (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/")
  (rime-show-candidate . 'popup)
  (rime-popup-properties . nil))
(provide 'init-input)
;;; init-input.el ends here
