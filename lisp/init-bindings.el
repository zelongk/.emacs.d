;; -*- lexical-binding: t -*-

(define-prefix-command 'orgmode-map)
(global-set-key (kbd "C-c n") 'orgmode-map)

(define-key orgmode-map (kbd "a") #'org-agenda)
(define-key orgmode-map (kbd "n") #'org-capture)

(global-set-key (kbd "C-c g") #'magit-status)


(provide 'init-bindings)
