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

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(defun reload-init-file ()
  "Reload Emacs configurations."
  (interactive)
  (load user-init-file))

(bind-keys ("s-r"     . revert-buffer-quick)
           ("C-x K"   . delete-this-file)
           ("C-c C-l" . reload-init-file)
           ("C-c C-w 0" . desktop-clear))

(provide 'init-bindings)
