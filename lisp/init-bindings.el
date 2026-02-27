;; -*- lexical-binding: t -*-

(define-prefix-command 'orgmode-map)
(global-set-key (kbd "C-c n") 'orgmode-map)

(define-key orgmode-map (kbd "a") #'org-agenda)
(define-key orgmode-map (kbd "n") #'org-capture)
(define-key orgmode-map (kbd "t") #'org-todo-list)


(setq duplicate-line-final-position 1)
(global-set-key (kbd "M-p") #'duplicate-dwim)
(global-set-key (kbd "C-c y") #'copy-from-above-command)
(global-set-key (kbd "s-k") #'kill-current-buffer)

(global-set-key (kbd "C-c C-c") #'compile)

(provide 'init-bindings)
