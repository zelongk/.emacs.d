;; -*- lexical-binding: t; -*-


(use-package project)

(use-package tabspaces
  :functions tabspaces-mode
  :hook (elpaca-after-init . tabspaces-mode)
  :custom
  (tab-bar-show nil)

  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*Messages*"))
  (tabspaces-exclude-buffers '("*eat*" "*vterm*" "*shell*" "*eshell*"))
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore t)
  (tabspaces-keymap-prefix "C-c o"))
  
(provide 'init-workspace)
