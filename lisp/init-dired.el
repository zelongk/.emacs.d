;; -*- lexical-binding: t -*-

(leaf dired
  :bind (("C-x x @" . tramp-revert-buffer-with-sudo)
         (:dired-mode-map
          ("C-c C-p" . wdired-change-to-wdired-mode)
	      ("b" . dired-up-directory)))
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t)

  ;; Show directory first
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-use-ls-dired t))

(leaf diredfl :ensure t)
(leaf dired-aux)
(leaf dired-filter :ensure t
  :blackout t
  :after dired
  :hook dired-mode-hook)

(leaf nerd-icons-dired
  :ensure t
  :blackout t
  :hook (dired-mode-hook . nerd-icons-dired-mode))

(leaf dirvish
  :disabled t
  :bind ("C-c o p" . dirvish-side)
  :config
  (setq dirvish-use-header-line nil
	    dirvish-use-mode-line nil))

(provide 'init-dired)
