;; -*- lexical-binding: t -*-

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("C-c C-p" . wdired-change-to-wdired-mode)
	            ("b" . dired-up-directory))
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-kill-when-opening-new-dired-buffer t)

  ;; Show directory first
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-use-ls-dired t)

  ;; Colorful dired
  (use-package diredfl
    :diminish
    :hook dired-mode
    :hook dirvish-directory-view-mode)


  ;; Extra Dired functionality
  (use-package dired-aux :straight nil))

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

;; (use-package dirvish
;;   :bind ("C-c o p" . dirvish-side)
;;   :init (dirvish-override-dired-mode)
;;   :config
;;   (setq dirvish-use-header-line nil
;; 	dirvish-use-mode-line nil))

(provide 'init-dired)
