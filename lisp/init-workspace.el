;; -*- lexical-binding: t; -*-


;; (use-package project)
(use-package projectile
  :hook elpaca-after-init
  :config
  ;; Recommended keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :init (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))
(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))
(use-package ibuffer-projectile
  :init
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-projectile-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

(use-package beframe
  :hook elpaca-after-init
  :bind ("C-x f" . other-frame-prefix)
  :config
  (define-key global-map (kbd "C-c b") #'beframe-prefix-map)
  (setq beframe-functions-in-frames '(projectile-switch-project)
        beframe-rename-function #'ignore
        beframe-global-buffers '("*scratch*" "*Messages*" "*Backtrace*"))
  (use-package embark
    :defer
    :config
    (define-key embark-buffer-map (kbd "fu")
                (defun my/beframe-unassume-buffer (buf)
                  (interactive "bUnassume: ")
                  (beframe--unassume
                   (list (get-buffer buf)))))
    (define-key embark-buffer-map (kbd "fa")
                (defun my/beframe-assume-buffer (buf)
                  (interactive "bAssume: ")
                  (beframe--assume
                   (list (get-buffer buf))))))

  ;; Beframe integration with other packages
  (with-eval-after-load 'consult
    (defun consult-beframe-buffer-list (&optional frame)
      "Return the list of buffers from `beframe-buffer-names' sorted by visibility.
With optional argument FRAME, return the list of buffers of FRAME."
      (beframe-buffer-list frame :sort #'beframe-buffer-sort-visibility))

    (setq consult-buffer-list-function #'consult-beframe-buffer-list)))

(provide 'init-workspace)
