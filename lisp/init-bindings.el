;; -*- lexical-binding: t -*-

(define-prefix-command 'orgmode-map)
(global-set-key (kbd "C-c n") 'orgmode-map)

(define-key orgmode-map (kbd "a") #'org-agenda)
(define-key orgmode-map (kbd "n") #'org-capture)
(define-key orgmode-map (kbd "t") #'org-todo-list)

(global-set-key (kbd "C-\\") #'vterm)


(provide 'init-bindings)
