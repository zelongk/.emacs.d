;; -*- lexical-binding: t -*-

(use-package org
  :defer
  :ensure (org :repo "https://code.200568.top/mirrors/org-mode.git/"
               :branch "dev")
  :hook ((org-mode . org-cdlatex-mode)
         (org-mode . visual-line-mode)
         (org-mode . prettify-symbols-mode))
  :bind (("C-c n t" . org-todo-list)
         ("C-c n a" . org-agenda)
         ("C-c n c" . org-capture)
         :map org-mode-map
         ("M-<return>" . org-insert-subheading)
         ("C-'" . nil))
  :config
  (setq org-element-use-cache t
        org-element-cache-persistent t)

  ;; Share snippets with LaTeX-mode
  (setq org-highlight-latex-and-related '(native latex entities))
  (setq org-pretty-entities t
        org-pretty-entities-include-sub-superscripts nil)

  (setq org-tags-column 0
        org-agenda-tags-column 80)
  
  ;; Enable lsp in org-babel
  (cl-defmacro lsp-org-babel-enable (lang)
    "Support LANG in org source code block."
    (cl-check-type lang string)
    (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
           (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
      `(progn
         (defun ,intern-pre (info)
           (setq buffer-file-name (or (->> info caddr (alist-get :file))
                                      "org-src-babel.tmp"))
           (when (fboundp 'lsp-deferred)
             ;; Avoid headerline conflicts
             (setq-local lsp-headerline-breadcrumb-enable nil)
             (lsp-deferred)
             (_
              (user-error "LSP:: invalid type"))))
         (put ',intern-pre 'function-documentation
              (format "Enable lsp-mode in the buffer of org source block (%s)."
                      (upcase ,lang)))

         (if (fboundp ',edit-pre)
             (advice-add ',edit-pre :after ',intern-pre)
           (progn
             (defun ,edit-pre (info)
               (,intern-pre info))
             (put ',edit-pre 'function-documentation
                  (format "Prepare local buffer environment for org source block (%s)."
                          (upcase ,lang))))))))

  (defconst org-babel-lang-list
    '("go" "python" "ipython" "ruby" "js" "css" "sass" "c" "rust" "java" "cpp" "c++" "shell" "haskell")
    "The supported programming languages for interactive Babel.")
  (dolist (lang org-babel-lang-list)
    (eval `(lsp-org-babel-enable ,lang))))

;; org agenda-related
(use-package org
  :after org
  :config
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

(use-package org-contrib
  :ensure t
  :after org)

(use-package org-modern
  :ensure t
  ;; :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :init
  (with-eval-after-load 'org
    (setq org-hide-emphasis-markers t
	      org-pretty-entities t
          org-modern-block-name t
          org-modern-block-fringe nil))
  :config
  (setq org-modern-table-vertical 1
	    org-modern-table-horizontal 0.2
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
                          (42 . "•"))))

(use-package org-modern-indent
  :ensure (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :after org-modern org
  :hook (org-mode . org-indent-mode)
  :hook org-indent-mode)


(use-package org-appear
  :ensure t
  :defer t
  :hook (org-mode . org-appear-mode)
  :autoload org-appear--set-elements
  :config
  (setq org-appear-autoemphasis t
	    org-appear-autosubmarkers t
	    org-appear-autolinks nil)
  (run-at-time nil nil #'org-appear--set-elements))

(use-package org
  :after org
  :config
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

(use-package org-latex-preview
  :after org
  :hook (org-mode . org-latex-preview-mode)
  :bind ("C-c C-x SPC" . org-latex-preview-clear-cache)
  :config
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


(use-package org-download
  :ensure t
  :after org
  :autoload org-download-clipboard
  :hook ((org-mode dired-mode) . org-download-enable)
  :bind (:map org-mode-map
              ("C-M-y" . org-download-clipboard))
  :config
  (setq-default org-download-heading-lvl 1)
  (defconst org-download-image-dir "./attachments/")
  (setq-default org-download-method 'directory))

(use-package org-drawio :ensure t
  :commands (org-drawio-add
             org-drawio-open)
  :after org)

(use-package valign
  :ensure t
  :hook (org-mode . valign-mode))

;;; Miscs

;; Org latex preview center
(use-package org-latex-preview
  :after org-latex-preview
  :defer nil
  :hook (text-scale-mode . my/text-scale-adjust-latex-previews)
  :hook (org-latex-preview-mode . org-latex-preview-center-mode)
  :config
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
