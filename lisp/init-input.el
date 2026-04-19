;; -*- lexical-binding: t;-*-

(use-package rime
  :ensure t
  :custom
  (default-input-method "rime")
  (rime-librime-root "/opt/homebrew")
  (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/")
  (rime-show-candidate 'posframe)
  (rime-posframe-properties nil))

(use-package sis
  :disabled t
  :ensure t
  :hook ((elpaca-after-init . sis-global-respect-mode)
         (elpaca-after-init . sis-global-context-mode)
         (elpaca-after-init . sis-global-inline-mode)))


(provide 'init-input)
