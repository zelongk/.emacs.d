;; -*- lexical-binding: t; -*-

(use-package dashboard
  :demand t
  :bind ("<f2>" . dashboard-open)
  :config
  (dashboard-setup-startup-hook))


(provide 'init-dashboard)
