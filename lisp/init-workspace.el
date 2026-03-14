;; -*- lexical-binding: t; -*-


;; (use-package project)
(use-package projectile
  :hook elpaca-after-init
  :config
  ;; Recommended keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map))

(global-set-key (kbd "C-x C-b") #'ibuffer)

;; (use-package beframe
;;   :hook elpaca-after-init
;;   :bind (("C-x b" . beframe-switch-buffer)
;;          ("C-x C-b" . beframe-buffer-menu)
;;          ("C-x f" . other-frame-prefix))
;;   :config
;;   (define-key global-map (kbd "C-c b") #'beframe-prefix-map))


(use-package eyebrowse
  :hook elpaca-after-init
  :custom
  (eyebrowse-new-workspace t))

(use-package easysession
  :demand t
  ;; :hook (elpaca-after-init easysession-scratch-mode)
  ;; :hook (elpaca-after-init easysession-magit-mode)
  :bind (("s-1" . eyebrowse-switch-to-window-config-1)
         ("s-2" . eyebrowse-switch-to-window-config-2)
         ("s-3" . eyebrowse-switch-to-window-config-3)
         ("s-4" . eyebrowse-switch-to-window-config-4)
         ("s-5" . eyebrowse-switch-to-window-config-5)
         ("s-6" . eyebrowse-switch-to-window-config-6)
         ("s-7" . eyebrowse-switch-to-window-config-7)
         ("s-8" . eyebrowse-switch-to-window-config-8))
  :custom
  (easysession-switch-to-save-session t)
  (easysession-switch-to-exclude-current nil)
  :config
  (setq easysession-setup-load-session t)
  (easysession-setup))

(provide 'init-workspace)
