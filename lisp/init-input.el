;; init-input ---  Input methods -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; (leaf rime
;;   :ensure t
;;   :custom
;;   (default-input-method . "rime")
;;   (rime-librime-root . "/opt/homebrew")
;;   ;; (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/")
;;   (rime-show-candidate . 'popup)
;;   (rime-popup-properties . nil))

(leaf liberime :ensure t
  :if IS-MAC
  :custom
  ;; Point to liberime module built by oneself
  (liberime-module-file . "~/.local/lib/liberime-core.dylib")
  (liberime-user-data-dir . "~/Library/Rime/"))

(leaf rimel :ensure t
  :custom
  (default-input-method . "rimel")
  ;; horizontal or vertical
  (rimel-posframe-style . 'horizontal)
  :setq
  (rimel-disable-predicates
   . '(rimel-predicate-prog-in-code-p
       rimel-predicate-after-alphabet-char-p
       rimel-predicate-current-uppercase-letter-p
       rimel-predicate-org-latex-mode-p
       rimel-predicate-org-in-src-block-p)))

(provide 'init-input)
;;; init-input.el ends here
