;; -*- lexical-binding: t;-*-

(leaf org-roam
  :elpaca t
  ;; :disabled t
  
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n t" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n n" . org-roam-capture)
         ("C-c n w" . org-roam-refile)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :bind (:org-mode-map
         ("C-c C-x i" . org-id-get-create))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag))
        org-id-locations-file (expand-file-name "org-id-locations" user-cache-directory)
        org-roam-db-location (expand-file-name "org-roam.db" org-directory))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)

  ;; Denote type filename
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target
           (file+head "%<%Y%m%dT%H%M%S>--${slug}.org" ":PROPERTIES:\n:ID:          %<%Y%m%dT%H%M%S>\n:END:\n#+title:      ${title}\n#+date:       [%<%Y-%m-%d %a %H:%S>]\n#+filetags: \n#+identifier: %<%Y%m%dT%H%M%S>\n\n")
           :immediate-finish t
           :unnarrowed t)))
  )

(leaf org-roam-ui
  ;; :disabled t
  :elpaca t
  :after org-roam)

(leaf consult-org-roam :elpaca t
  :after org-roam
  :hook elpaca-after-init-hook
  :custom
  ;; Use `ripgrep' for searching with `consult-org-roam-search'
  (consult-org-roam-grep-func . #'consult-ripgrep)
  :bind
  (([remap org-roam-node-find] . consult-org-roam-file-find)
   :org-mode-map
   ("C-c n b" . consult-org-roam-backlinks)
   ("C-c n B" . consult-org-roam-backlinks-recursive)
   ("C-c n l" . consult-org-roam-forward-links)
   ("C-c n g" . consult-org-roam-search)))

(provide 'init-roam)
