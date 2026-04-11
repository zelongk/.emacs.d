;; -*- lexical-binding: t; -*-

(use-package dashboard :demand t)  

(use-package doom-dashboard
  ;; For Straight Users
  :ensure (doom-dashboard :host github
                          :repo "emacs-dashboard/doom-dashboard")
  ;; Or for built-in package-vc
  ;; :vc (:url "https://github.com/emacs-dashboard/doom-dashboard.git" :rev :newest)
  ;; :after dashboard
  :demand t
  ;; :hook (elpaca-after-init . dashboard-setup-startup-hook)
  ;; Movement keys like doom.
  :bind
  (:map dashboard-mode-map
        ("<remap> <dashboard-previous-line>" . widget-backward)
        ("<remap> <dashboard-next-line>" . widget-forward)
        ("<remap> <previous-line>" . widget-backward)
        ("<remap> <next-line>"  . widget-forward)
        ("<remap> <right-char>" . widget-forward)
        ("<remap> <left-char>"  . widget-backward))
  :custom
  (dashboard-banner-logo-title "E M A C S")
  ;; (dashboard-startup-banner 
  ;; (concat doom-dashboard-banner-directory "bcc.txt")) ; Use banner you want
  ;; (dashboard-footer-icon 
  ;; (nerd-icons-faicon "nf-fa-github_alt" :face 'success :height 1.5))
  (dashboard-page-separator "\n")
  (dashboard-startupify-list `(dashboard-insert-banner
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-items
                               ,(dashboard-insert-newline 2)
                               dashboard-insert-init-info
                               ,(dashboard-insert-newline 2)
                               doom-dashboard-insert-homepage-footer))
  (dashboard-item-generators
   '((recents   . doom-dashboard-insert-recents-shortmenu)
     (bookmarks . doom-dashboard-insert-bookmark-shortmenu)
     (projects  . doom-dashboard-insert-project-shortmenu)
     (agenda    . doom-dashboard-insert-org-agenda-shortmenu)))
  ;; (dashboard-items '(projects agenda bookmarks recents)))
  (dashboard-items '(projects bookmarks recents)))

;; Why doom 


(provide 'init-dashboard)
