;; init-writing --- Writing tools -*- lexical-binding: t; -*-

;;; Commentary:
;;  Basically spell checkers

;;; Code:

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
;;; init-writing.el ends here
