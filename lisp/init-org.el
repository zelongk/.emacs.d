;; init-org ---  org-mode -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf org
  :blackout org-indent-mode org-cdlatex-mode
  :hook
  (org-mode-hook . org-cdlatex-mode)
  (org-mode-hook . visual-line-mode)
  (org-mode-hook . prettify-symbols-mode)
  (org-mode-hook . turn-on-reftex)
  :custom-face
  (org-block . '((t (:background unspecified))))
  (org-block-begin-line . '((t (:background unspecified))))
  (org-block-end-line . '((t (:background unspecified))))
  :bind
  ("C-c n t" . org-todo-list)
  ("C-c n a" . org-agenda)
  ("C-c n c" . org-capture)
  (:org-mode-map
   ("M-<return>" . org-insert-subheading)
   ("C-'" . nil)
   ("C-c C-M-l" . org-toggle-link-display)
   ("C-c C-M-s" . org-store-link))
  :defer-config
  ;; Share snippets with LaTeX-mode
  (setq org-highlight-latex-and-related '(native latex entities))
  (setq org-pretty-entities t
        org-hide-emphasis-markers t
        org-pretty-entities-include-sub-superscripts nil)
  
  (setq org-tags-column 0
        org-agenda-tags-column 80
        org-startup-indented t
        org-indent-indentation-per-level 1)

  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          (todo . " %i")
          (tags . " %i %-12:c")
          (search . " %i %-12:c"))
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-compact-blocks t
        org-agenda-start-day "+0d"
        org-agenda-span 3
        org-agenda-remove-tags t))

;; org agenda-related
(leaf org-super-agenda :ensure t
  :hook org-agenda-mode-hook
  :defer-config
  (setq org-super-agenda-groups
        '(;; Each group has an implicit boolean OR operator between its selectors.
          (:name "Today"  ; Optionally specify section name
                 :time-grid t  ; Items that appear on the time grid
                 :todo "TODAY")  ; Items that have this TODO keyword
          (:name "Important"
                 ;; Single arguments given alone
                 :tag ("bills" "important")
                 :priority "A")
          (:name "Assignments"
                 ;; Single arguments given alone
                 :tag "Assignment")
          ;; Set order of multiple groups at once
          (:order-multi (2 (:name "Shopping"
                                  ;; Boolean AND group matches items that match all subgroups
                                  :and (:tag "shopping" :tag "@town"))
                           (:name "Food-related"
                                  ;; Multiple args given in list with implicit OR
                                  :tag ("food" "dinner"))
                           (:name "Personal"
                                  :habit t
                                  :tag "personal")
                           ))
          ;; Groups supply their own section names when none are given
          (:tag "questions" :order 7)
          (:todo "WAIT" :order 8)  ; Set order of this section
          (:todo "HOLD" :order 8)  ; Set order of this section
          (:name "NAS-related" :tag "NAS" :order 9)
          (:todo ("IDEA")
                 ;; Show this group at the end of the agenda (since it has the
                 ;; highest number). If you specified this group last, items
                 ;; with these todo keywords that e.g. have priority A would be
                 ;; displayed in that group instead, because items are grouped
                 ;; out in the order the groups are listed.
                 :order 9)
          (:name "Less Important" :priority<= "B"
                 ;; Show this section after "Today" and "Important", because
                 ;; their order is unspecified, defaulting to 0. Sections
                 ;; are displayed lowest-number-first.
                 :order 1)
          ;; After the last group, the agenda will display items that didn't
          ;; match any of these groups, with the default order position of 99
          )))

(leaf org
  :defer-config
  (add-to-list 'org-modules 'org-habit)
  (setq org-directory "~/org/")
  (add-to-list 'org-agenda-files "~/org")

  (setq org-default-note-file (expand-file-name "notes.org" org-directory)
        org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline "todo.org" "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline "notes.org" "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree "diary.org")
           "* %U %?\n%i\n%a" :prepend t)))
  (with-no-warnings
    (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) ""))
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "TODAY(a)" ; A task that needs to be done today
           "PROJ(p)"  ; A project, which usually contains other tasks
           "LOOP(r)"  ; A recurring task
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "IDEA(i)"  ; An unconfirmed and unapproved task or notion
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted, or is no longer applicable
          (sequence
           "|"
           "OKAY(o)"
           "YES(y)"
           "NO(n)"))
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("NO"   . +org-todo-cancel)
          ("KILL" . +org-todo-cancel)))

  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
  (add-hook 'org-after-refile-insert-hook
            (defun save-buffer-after-capture ()
              (when (bound-and-true-p org-capture-is-refiling)
                (save-buffer)))))

(leaf org-modern :ensure t
  :after org
  :require t
  :hook
  (org-mode-hook . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :config
  (setq org-modern-block-name t
        org-modern-block-fringe nil
        org-modern-table nil
        org-modern-hide-stars nil
	    org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
	    org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-fold-stars
        '(("" . ""))))

(leaf org-modern-indent
  :vc (:url "https://github.com/jdtsmith/org-modern-indent")
  :require t
  :after org-modern org
  :hook org-indent-mode-hook)

(leaf org-appear :ensure t
  :hook org-mode-hook
  :leaf-autoload org-appear--set-elements
  :defer-config
  (setq org-appear-autoemphasis t
	    org-appear-autosubmarkers t
	    org-appear-autolinks nil)
  (run-at-time nil nil #'org-appear--set-elements))

(leaf org
  :defer-config
  (setq org-latex-packages-alist
        '(("T1" "fontenc" t)
          ("" "amsmath" t)
          ("" "bm" t) ; Bold math required
          ("" "mathtools" t)
          ("" "siunitx" t)
          ("" "physics2" t)
          ("" "algpseudocode" t)
          ("" "algorithm" t)
          ("" "mlmodern" t)
          ("" "tikz" t)
          ("" "tikz-cd" t)))

  (setq org-latex-preview-preamble
        "\\documentclass{article}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{xcolor}
\\usephysicsmodule{ab,ab.braket,diagmat,xmat}%
"))

(leaf org-latex-preview
  :hook org-mode-hook
  :bind ("C-c C-x SPC" . org-latex-preview-clear-cache)
  :custom
  (org-latex-preview-numbered . nil)
  :defer-config
  (plist-put org-latex-preview-appearance-options :page-width 0.4)
  ;; Add margin and rescale display math
  (defvar my/org-latex-display-math-scale 1)
  (defvar my/org-latex-display-math-margin 5)
  (defun my/org-latex-preview-add-margin-advice (ov _path-info)
    (save-excursion
      (goto-char (overlay-start ov))
      (when-let* ((elem (org-element-context))
                  ((or (eq (org-element-type elem) 'latex-environment)
                       (string-match-p "^\\\\\\[" (org-element-property :value elem))))
                  (img (overlay-get ov 'preview-image))
                  ((and (consp img) (eq (car img) 'image))))
        (let* ((plist (copy-sequence (cdr img)))
               (height (plist-get plist :height)))
          (when (and (consp height) (numberp (car height)))
            (setq plist
                  (plist-put plist :height
                             (cons (* my/org-latex-display-math-scale (car height))
                                   (cdr height)))))
          (setq plist (plist-put plist :margin my/org-latex-display-math-margin))
          (let ((new-img (cons 'image plist)))
            (overlay-put ov 'preview-image new-img)
            (when (overlay-get ov 'display)
              (overlay-put ov 'display new-img)))))))
  (advice-add 'org-latex-preview--update-overlay :after
              #'my/org-latex-preview-add-margin-advice)
  
  ;; (setq org-latex-preview-numbered t)
  (setq org-latex-preview-mode-display-live t)
  (setq org-latex-preview-process-default 'dvisvgm)
  (setq org-latex-preview-mode-update-delay 0.25))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;              org utils              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(leaf org-download :ensure t
  :leaf-autoload org-download-clipboard
  :hook ((org-mode-hook dired-mode-hook) . org-download-enable)
  :bind (:org-mode-map
         ("C-M-y" . org-download-clipboard))
  :config
  (setq-default org-download-heading-lvl 1)
  (defconst org-download-image-dir "./attachments/")
  (setq-default org-download-method 'directory))

(leaf org-drawio :ensure t
  :commands (org-drawio-add
             org-drawio-open))

(leaf valign :ensure t
  :blackout t
  :hook org-mode-hook)

;;; Miscs
;; Org latex preview center
(leaf org-latex-preview
  :hook
  (text-scale-mode-hook . my/text-scale-adjust-latex-previews)
  (org-latex-preview-mode-hook . org-latex-preview-center-mode)
  :defer-config
  ;; Centre display maths
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
                   #'my/org-latex-preview-uncenter)))
  (defun my/text-scale-adjust-latex-previews ()
    "Adjust the size of latex preview fragments when changing the buffer's text scale."
    (pcase major-mode
      ('latex-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'category)
                 'preview-overlay)
             (my/text-scale--resize-fragment ov))))
      ('org-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'org-overlay-type)
                 'org-latex-overlay)
             (my/text-scale--resize-fragment ov))))))
  
  (defun my/text-scale--resize-fragment (ov)
    (overlay-put
     ov 'display
     (cons 'image
           (plist-put
            (cdr (overlay-get ov 'display))
            :scale (+ 1.0 (* 0.25 text-scale-mode-amount)))))))

(provide 'init-org)
;;; init-org.el ends here
