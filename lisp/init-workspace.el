;; -*- lexical-binding: t; -*-


;; (use-package project)
(use-package projectile
  :hook elpaca-after-init
  :config
  ;; Recommended keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map))

(use-package ibuffer-projectile
  :config
  (add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic)))))

(use-package consult-projectile
  :bind (([remap projectile-find-file] . consult-projectile-find-file)
         ([remap projectile-recentf] . consult-projectile-recentf)
         ([remap projectile-switch-project] . consult-projectile-switch-project)
         ([remap projectile-switch-to-buffer] . consult-projectile-switch-to-buffer)
         ([remap projectile-find-dir] . consult-projectile-find-dir)))

;; (use-package org-project-capture)

;; (use-package org-projectile
;;   :config
;;   (setq org-project-capture-default-backend
;;         (make-instance 'org-project-capture-projectile-backend)))

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
  :diminish
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
         ;; ("C-c C-s l" . easysession-switch-to)
         ;; ("C-c C-s L" . easysession-switch-to-and-restore-geometry)
         ;; ("C-c C-s s" . easysession-save)
         ;; ("C-c C-s r" . easysession-rename)
         ;; ("C-c C-s R" . easysession-reset)
         ;; ("C-c C-s u" . easysession-unload)
         ;; ("C-c C-s d" . easysession-delete))

  :custom
  (easysession-switch-to-save-session t)
  (easysession-switch-to-exclude-current nil)
  :config
  (setq easysession-setup-load-session t)
  (easysession-setup)
  (easysession-magit-mode)
  (easysession-scratch-mode))

(provide 'init-workspace)
