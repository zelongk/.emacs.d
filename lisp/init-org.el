;; -*- lexical-binding: t -*-

;; (defun org-capture-init()
;;   (setq org-capture-templates
;; 	'(("t" "Personal todo" entry ("Inbox")
;; 	   "* TODO %?\n%i\n%a" :prepend t))))

(use-package org
  :defer
  :ensure `(org :repo "https://code.tecosaur.net/tec/org-mode.git/"
                :branch "dev")
  :hook (org-mode . org-modern-mode)
  :config
  ;; (org-capture-init)
  (add-to-list 'org-modules 'org-habit)
  (setq org-directory "~/org/")
  )
(use-package org-modern
  :config
  (setq org-modern-table nil))

(use-package org-latex-preview
  :defer
  :ensure nil
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)

  ;; ;; Use dvisvgm to generate previews
  ;; ;; You don't need this, it's the default:
  ;; (setq org-latex-preview-process-default 'dvisvgm)
  
  ;; Turn on `org-latex-preview-mode', it's built into Org and much faster/more
  ;; featured than org-fragtog. (Remember to turn off/uninstall org-fragtog.)
  (add-hook 'org-mode-hook 'org-latex-preview-mode)

  ;; ;; Block C-n, C-p etc from opening up previews when using `org-latex-preview-mode'
  ;; (setq org-latex-preview-mode-ignored-commands
  ;;       '(next-line previous-line mwheel-scroll
  ;;         scroll-up-command scroll-down-command))

  ;; ;; Enable consistent equation numbering
  ;; (setq org-latex-preview-numbered t)

  ;; Bonus: Turn on live previews.  This shows you a live preview of a LaTeX
  ;; fragment and updates the preview in real-time as you edit it.
  ;; To preview only environments, set it to '(block edit-special) instead
  (setq org-latex-preview-mode-display-live t)

  ;; More immediate live-previews -- the default delay is 1 second
  (setq org-latex-preview-mode-update-delay 0.25))

(provide 'init-org)
