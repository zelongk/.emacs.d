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

(use-package beframe
  :hook elpaca-after-init
  :bind (("C-x b" . beframe-switch-buffer)
         ("C-x C-b" . beframe-buffer-menu)
         ("C-x f" . other-frame-prefix))
  :config
  (define-key global-map (kbd "C-c b") #'beframe-prefix-map))

(use-package desktop
  :ensure nil
  :demand t
  :init
  (setq desktop-dirname (expand-file-name user-emacs-directory)
		    desktop-path (list desktop-dirname)
		    desktop-save t
		    desktop-files-not-to-save "^$" ;reload tramp paths
		    desktop-load-locked-desktop nil
        desktop-restore-eager 4)
  :config
  (desktop-save-mode 1))

(use-package eyebrowse
  :hook elpaca-after-init
  :custom
  (eyebrowse-new-workspace t))

(provide 'init-workspace)
