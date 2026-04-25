;; -*- lexical-binding: t; -*-

(use-package flyspell
  :commands flyspell-mode
  :bind (:map flyspell-mode-map
              ("C-M-i" . nil)
              ("C-;" . nil)
              ("C-," . nil)
              ("C-; C-4" . 'flyspell-auto-correct-previous-word)
              ;; ("C-; n" . 'flyspell-goto-next-error)
              ))

(use-package jinx
  :ensure t
  :commands jinx-mode
  :bind ([remap ispell-word] . jinx-correct))

(provide 'init-writing)
