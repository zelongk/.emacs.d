;; -*- lexical-binding: t; -*-


(use-package project)

(use-package tabspaces
  :functions tabspaces-mode
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :hook (elpaca-after-init . tabspaces-mode)
  :bind (:map tabspaces-mode-map
              ([remap project-switch-project] . tabspaces-open-or-create-project-and-workspace))
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
  (tabspaces-keymap-prefix "C-c o")
  (tab-bar-new-tab-choice "default"))

(provide 'init-workspace)
