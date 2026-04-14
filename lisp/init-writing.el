;; -*- lexical-binding: t; -*-

(use-package flyspell
  :ensure nil
  :commands flyspell-mode
  :bind (:map flyspell-mode-map
              ("C-M-i" . nil)
              ("C-;" . nil)
              ("C-," . nil)
              ("C-; C-4" . 'flyspell-auto-correct-previous-word)
              ;; ("C-; n" . 'flyspell-goto-next-error)
              ))

(use-package jinx
  :diminish
  :hook ((text-mode prog-mode conf-mode org-mode) . jinx-mode)
  :commands jinx-mode
  :bind ([remap ispell-word] . jinx-correct))

(provide 'init-writing)
