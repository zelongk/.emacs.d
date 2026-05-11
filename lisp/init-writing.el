;; -*- lexical-binding: t; -*-

(leaf flyspell
  :commands flyspell-mode
  :bind (:flyspell-mode-map
         ("C-M-i" . nil)
         ("C-;" . nil)
         ("C-," . nil)
         ("C-; C-4" . 'flyspell-auto-correct-previous-word)))

(leaf jinx
  :ensure t
  :commands jinx-mode
  :bind ([remap ispell-word] . jinx-correct))

(provide 'init-writing)
