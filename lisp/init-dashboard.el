;; -*- lexical-binding: t; -*-

(use-package dashboard
  :demand t
  :bind ("<f2>" . dashboard-open)
  :diminish dashboard-mode
  :custom-face
  (dashboard-heading ((t (:inherit (font-lock-string-face bold)))))
  (dashboard-items-face ((t (:weight normal))))
  (dashboard-no-items-face ((t (:weight normal))))
  :hook (dashboard-mode . (lambda () (setq-local frame-title-format nil)))
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  :init
  (setq dashboard-banner-logo-title "ZEMACS - Enjoy Programming & Writing"
        ;; dashboard-page-separator "\n\f\n"
        dashboard-projects-backend 'project-el
        dashboard-path-style 'truncate-middle
        dashboard-path-max-length 60
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-show-shortcuts nil
        dashboard-items '((recents  . 10)
                          (bookmarks . 5)
                          (projects . 5))
	
        dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer)))

(provide 'init-dashboard)
