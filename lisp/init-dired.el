;; -*- lexical-binding: t -*-

(use-package dired
  :ensure nil
  :bind (("C-x x @" . tramp-revert-buffer-with-sudo)
         :map dired-mode-map
         ("C-c C-p" . wdired-change-to-wdired-mode)
	     ("b" . dired-up-directory))
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t)

  ;; Show directory first
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-use-ls-dired t))

;; Colorful dired
(use-package diredfl
  :diminish
  :hook dired-mode
  :hook dirvish-directory-view-mode)

;; Extra Dired functionality
(use-package dired-aux :ensure nil)

(use-package nerd-icons-dired
  :diminish
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package dirvish
  :disabled t
  :bind ("C-c o p" . dirvish-side)
  :config
  (setq dirvish-use-header-line nil
	    dirvish-use-mode-line nil))

(provide 'init-dired)
