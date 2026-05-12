;; -*- lexical-binding: t -*-

(define-key global-map (kbd "C-<wheel-up>")  nil)
(define-key global-map (kbd "C-<wheel-down>")  nil)
(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-n") 'make-frame-command)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-v") 'yank)
(global-set-key (kbd "s-x") 'execute-extended-command)
(global-set-key (kbd "s-z") 'undo)

(setq duplicate-line-final-position 1)
(global-set-key (kbd "M-p") #'duplicate-dwim)
(global-set-key (kbd "C-c y") #'copy-from-above-command)
(global-set-key (kbd "s-k") #'kill-current-buffer)
(global-set-key (kbd "C-x k") #'kill-current-buffer)

(define-key prog-mode-map (kbd "C-c k") #'compile)

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
