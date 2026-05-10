;; -*- lexical-binding: t -*-

(use-package dired
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
  :ensure t
  :hook (elpaca-after-init . diredfl-global-mode))

;; Extra Dired functionality
(use-package dired-aux :ensure nil)

(use-package nerd-icons-dired
  :ensure t
  :defer
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package dirvish
  :disabled t
  :bind ("C-c o p" . dirvish-side)
  :config
  (setq dirvish-use-header-line nil
	    dirvish-use-mode-line nil))

(provide 'init-dired)
