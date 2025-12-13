;; -*- lexical-binding: t -*-

(use-package magit
  :defer
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-show-long-lines-warning nil))

;; (use-package eat
;;   :ensure `(eat :repo "https://codeberg.org/akib/emacs-eat"
;; 		:files ("*.el" ("term" "term/*.el") "*.texi"
;; 			"*.ti" ("terminfo/e" "terminfo/e/*")
;; 			("terminfo/65" "terminfo/65/*")
;; 			("integration" "integration/*")
;; 			(:exclude ".dir-locals.el" "*-tests.el")))
;;   :config  
;;   )

(use-package vterm
  :defer
  :bind ("C-\\" . vterm))
(use-package editorconfig
  :diminish
  :hook after-init)


(use-package yaml-mode)
;; Fish shell mode and auto-formatting
(use-package fish-mode
  :defer t
  :commands fish_indent-before-save
  :defines eglot-server-programs
  :hook (fish-mode . (lambda ()
                       "Integrate `fish_indent` formatting with Fish shell mode."
                       (add-hook 'before-save-hook #'fish_indent-before-save)))
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(fish-mode . ("fish-lsp" "start")))))

(provide 'init-coding)
