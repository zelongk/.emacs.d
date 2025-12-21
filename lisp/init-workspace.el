;; -*- lexical-binding: t; -*-

(use-package persp-mode
  :hook (elpaca-after-init . persp-mode)
  :custom
  (persp-keymap-prefix "w")
  :config
  (setq wg-morph-on nil)
  (setq persp-autokill-buffer-on-remove 'kill-weak)
  (add-hook 'window-setup-hook #'(lambda () (persp-mode 1))))

(use-package projectile
  :hook (elpaca-after-init . projectile-mode)
  :config
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(provide 'init-workspace)
