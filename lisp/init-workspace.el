;; -*- lexical-binding: t; -*-

;; (use-package persp-mode
;;   :hook (elpaca-after-init . persp-mode)
;;   :custom
;;   (persp-mode-prefix-key "o")
;;   :config
;;   (setq wg-morph-on nil)
;;   (setq persp-autokill-buffer-on-remove 'kill-weak))

;; (use-package persp-projectile
;;   :after (persp-mode projectile))

;; (use-package projectile
;;   :hook (elpaca-after-init . projectile-mode)
;;   :bind ([remap projectile-switch-project] . projectile-persp-switch-project)
;;   :custom
;;   (projectile-enable-caching t)
;;   :config
;;   ;; Recommended keymap prefix on Windows/Linux
;;   (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

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
  (tabspaces-keymap-prefix "C-c o")
  :config
  (with-no-warnings
    ;; Filter Buffers for Consult-Buffer
    (with-eval-after-load 'consult
      ;; hide full buffer list (still available with "b" prefix)
      (consult-customize consult--source-buffer :hidden t :default nil)
      ;; set consult-workspace buffer list
      (defvar consult--source-workspace
        (list :name     "Workspace Buffer"
              :narrow   ?w
              :history  'buffer-name-history
              :category 'buffer
              :state    #'consult--buffer-state
              :default  t
              :items    (lambda () (consult--buffer-query
                                    :predicate #'tabspaces--local-buffer-p
                                    :sort 'visibility
                                    :as #'buffer-name)))
        "Set workspace buffer list for consult-buffer.")
      (add-to-list 'consult-buffer-sources 'consult--source-workspace))

    (defun my-tabspaces-burry-window (&rest _)
      "Burry *Messages* buffer."
      (ignore-errors
        (quit-windows-on messages-buffer-name)))
    (advice-add #'tabspaces-restore-session :after #'my-tabspaces-burry-window)))

(provide 'init-workspace)
