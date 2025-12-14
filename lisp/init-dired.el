;; -*- lexical-binding: t -*-

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("C-c C-p" . wdired-change-to-wdired-mode))
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always)

  ;; Show directory first
  ;; (setq dired-listing-switches "-alh --group-directories-first")
  
  ;; Colorful dired
  (use-package diredfl
    :diminish
    :hook dired-mode)
  
  (use-package nerd-icons-dired
    :diminish
    :functions (nerd-icons-icon-for-dir my-nerd-icons-icon-for-dir)
    :hook dired-mode
    :init
    (defface nerd-icons-dired-dir-face
      '((t (:inherit 'font-lock-doc-face)))
      "Face for the directory icon."
      :group 'nerd-icons-faces)
    (defun my-nerd-icons-icon-for-dir (dir)
      (nerd-icons-icon-for-dir dir :face 'nerd-icons-dired-dir-face))
    (setq nerd-icons-dired-dir-icon-function #'my-nerd-icons-icon-for-dir))
    ;; Extra Dired functionality
  (use-package dired-aux :ensure nil))

(provide 'init-dired)
