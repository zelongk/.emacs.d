;; -*- lexical-binding: t; -*-


(use-package project)

(use-package tab-bar
  :ensure nil
  :init
  (tab-bar-mode t)
  (setq tab-bar-new-tab-choice "*scratch*") ;; buffer to show in new tabs
  (setq tab-bar-close-button-show nil)      ;; hide tab close / X button
  (setq tab-bar-show 1)                     ;; hide bar if <= 1 tabs open
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))

  (setq tab-bar-tab-hints t))

(global-set-key (kbd "C-x C-b") #'ibuffer)

(use-package tabspaces
  :functions tabspaces-mode
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :hook (elpaca-after-init . tabspaces-mode)
  :bind (:map tabspaces-mode-map
              ([remap project-switch-project] . tabspaces-project-switch-project-open-file))
  :bind (:map tabspaces-command-map
              ("l" . tabspaces-restore-session)
              ("s" . tabspaces-save-session)
              ("TAB" . tabspaces-switch-or-create-workspace))

  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*Messages*"))
  (tabspaces-exclude-buffers '("*eat*" "*vterm*" "*shell*" "*eshell*"))
  ;; sessions
  (tabspaces-session t)
  ;; (tabspaces-session-auto-restore t)
  (tabspaces-keymap-prefix "C-c o")
  (tab-bar-new-tab-choice "default")
  
  (with-eval-after-load 'consult
    ;; hide full buffer list (still available with "b" prefix)
    (consult-customize consult--source-buffer :hidden nil :default nil)
    ;; set consult-workspace buffer list
    (defvar consult--source-workspace
      (list :name "Workspace Buffers"
            :narrow ?w
            :history 'buffer-name-history
            :category 'buffer
            :state #'consult--buffer-state
            :default t
            :items (lambda () (consult--buffer-query
                               :predicate #'tabspaces--local-buffer-p
                               :sort 'visibility
                               :as #'buffer-name)))

      "Set workspace buffer list for consult-buffer.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

;; (use-package beframe
;;   :hook elpaca-after-init
;;   :bind (("C-x b" . beframe-switch-buffer)
;;          ("C-x C-b" . beframe-buffer-menu))
;;   :config
;;   (setq beframe-functions-in-frames '(project-prompt-project-dir)))

(provide 'init-workspace)
