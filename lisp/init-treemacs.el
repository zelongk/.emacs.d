;; -*- lexical-binding: t; -*-
(use-package treemacs
  :custom-face
  (cfrs-border-color ((t (:inherit posframe-border))))
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (pcase (cons (not (null (executable-find "git")))
               (not (null (executable-find "python3"))))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))

  (setq treemacs-collapse-dirs           (if treemacs-python-executable 3 0)
        treemacs-missing-project-action  'remove
        treemacs-user-mode-line-format   'none
        treemacs-sorting                 'alphabetic-asc
        treemacs-follow-after-init       t
        treemacs-width                   30
	    treemacs-show-hidden-files       nil
	    treemacs-silent-refresh          t
        treemacs-no-png-images           1)  
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-c o p"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-magit
  :hook ((magit-post-commit
          git-commit-post-finish
          magit-post-stage
          magit-post-unstage)
         . treemacs-magit--schedule-update))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :straight t
  :config (treemacs-set-scope-type 'Tabs))

(use-package treemacs-nerd-icons
  :demand t
  :config (treemacs-nerd-icons-config))

(use-package treemacs-persp
  :after (treemacs persp-mode)
  :demand t
  :functions treemacs-set-scope-type
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-projectile
  :after (treemacs projectile-mode))

(provide 'init-treemacs)
