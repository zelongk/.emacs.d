;; -*- lexical-binding: t; -*-

(use-package project
  :config
  (setq project-list-file (expand-file-name "projects" user-cache-directory)))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :bind (:map ibuffer-mode-map
              ("M-o" . nil))
  :config
  (add-to-list 'ibuffer-help-buffer-modes 'helpful-mode)
  (add-to-list 'ibuffer-help-buffer-modes 'Man-mode)
  :init (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))
(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))
;; Group ibuffer's list by project
(use-package ibuffer-project
  :autoload (ibuffer-project-generate-filter-groups ibuffer-do-sort-by-project-file-relative)
  :hook (ibuffer . (lambda ()
                     "Group ibuffer's list by project."
                     (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
                     (unless (eq ibuffer-sorting-mode 'project-file-relative)
                       (ibuffer-do-sort-by-project-file-relative))))
  :init (setq ibuffer-project-use-cache t))

(use-package beframe
  :hook elpaca-after-init
  :bind-keymap ("C-c b" . beframe-prefix-map)
  :bind ("C-x f" . other-frame-prefix)
  :config
  (setq beframe-functions-in-frames '(project-switch-project)
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
