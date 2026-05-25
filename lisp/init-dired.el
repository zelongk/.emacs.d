;; init-dired --- Best file manager -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf dired
  :bind
  (:dired-mode-map
   ("C-c C-p" . wdired-change-to-wdired-mode)
   ("b" . dired-up-directory))
  :hook
  (dired-mode-hook . toggle-truncate-lines)
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t)

  ;; Show directory first
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-use-ls-dired t)
  (leaf dired-aux)
  (leaf dired-filter :ensure t
    :blackout t))

(provide 'init-dired)
;;; init-dired.el ends here
