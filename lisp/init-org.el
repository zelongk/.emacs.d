;; -*- lexical-binding: t -*-

;; (defun org-capture-init()
;;   (setq org-capture-templates
;; 	'(("t" "Personal todo" entry ("Inbox")
;; 	   "* TODO %?\n%i\n%a" :prepend t))))

(use-package org
  :defer
  :ensure `(org :repo "https://code.tecosaur.net/tec/org-mode.git/"
                :branch "dev")
  ;; :hook (org-mode . org-indent-mode)
  :config
  ;; (org-capture-init)
  (setq org-modules '(org-habit))
  (setq org-directory "~/org/")
  (add-to-list 'org-agenda-files "~/org")

  (setq org-highlight-latex-and-related '(native latex entities))
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  )

(use-package org-contrib)

(with-eval-after-load 'org
	(setq org-highlight-latex-and-related '(native script entities)))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :hook (org-agenda-finalize . org-modern-agenda)
  :init
  (with-eval-after-load 'org
    (setq org-hide-emphasis-markers t
	  org-pretty-entities t))
  :config
  (setq org-modern-table nil))
(use-package org-appear
  :defer)

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :hook (yaml-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(use-package org-latex-preview
  :ensure nil
  :hook (org-mode . org-latex-preview-mode)
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)
  
  ;; ;; Block C-n, C-p etc from opening up previews when using `org-latex-preview-mode'
  ;; (setq org-latex-preview-mode-ignored-commands
  ;;       '(next-line previous-line mwheel-scroll
  ;;         scroll-up-command scroll-down-command))

  (setq org-latex-preview-numbered t)
  (setq org-latex-preview-mode-display-live t)
  (setq org-latex-preview-mode-update-delay 0.25))

;; code for centering LaTeX previews -- a terrible idea
(use-package org-latex-preview
  :ensure nil
  :hook (org-latex-preview-mode . org-latex-preview-center-mode)
  :config
  (defun my/org-latex-preview-uncenter (ov)
    (overlay-put ov 'before-string nil))
  (defun my/org-latex-preview-recenter (ov)
    (overlay-put ov 'before-string (overlay-get ov 'justify)))
  (defun my/org-latex-preview-center (ov)
    (save-excursion
      (goto-char (overlay-start ov))
      (when-let* ((elem (org-element-context))
                  ((or (eq (org-element-type elem) 'latex-environment)
                       (string-match-p "^\\\\\\[" (org-element-property :value elem))))
                  (img (overlay-get ov 'display))
                  (prop `(space :align-to (- center (0.55 . ,img))))
                  (justify (propertize " " 'display prop 'face 'default)))
        (overlay-put ov 'justify justify)
        (overlay-put ov 'before-string (overlay-get ov 'justify)))))
  (define-minor-mode org-latex-preview-center-mode
    "Center equations previewed with `org-latex-preview'."
    :global nil
    (if org-latex-preview-center-mode
        (progn
          (add-hook 'org-latex-preview-overlay-open-functions
                    #'my/org-latex-preview-uncenter nil :local)
          (add-hook 'org-latex-preview-overlay-close-functions
                    #'my/org-latex-preview-recenter nil :local)
          (add-hook 'org-latex-preview-overlay-update-functions
                    #'my/org-latex-preview-center nil :local))
      (remove-hook 'org-latex-preview-overlay-close-functions
                    #'my/org-latex-preview-recenter)
      (remove-hook 'org-latex-preview-overlay-update-functions
                    #'my/org-latex-preview-center)
      (remove-hook 'org-latex-preview-overlay-open-functions
                    #'my/org-latex-preview-uncenter))))

(use-package org-roam
  :ensure t
  :defer
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui)

(provide 'init-org)
