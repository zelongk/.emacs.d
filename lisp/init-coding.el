;; -*- lexical-binding: t -*-

(use-package magit
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

(use-package vterm)

(provide 'init-coding)
