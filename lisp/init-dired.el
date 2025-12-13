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
  )

(provide 'init-dired)
