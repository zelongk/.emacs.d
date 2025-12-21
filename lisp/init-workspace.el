;; -*- lexical-binding: t; -*-

(use-package persp-mode
  :hook (elpaca-after-init . persp-mode)
  :custom
  (persp-mode-prefix-key "w")
  :config
  (setq wg-morph-on nil)
  (setq persp-autokill-buffer-on-remove 'kill-weak))

(use-package persp-projectile
  :after (persp-mode projectile))

(use-package projectile
  :hook (elpaca-after-init . projectile-mode)
  :bind ([remap projectile-switch-project] . projectile-persp-switch-project)
  :custom
  (projectile-enable-caching t)
  :config
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(provide 'init-workspace)
