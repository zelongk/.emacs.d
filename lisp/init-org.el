;; -*- lexical-binding: t -*-

;; (defun org-capture-init()
;;   (setq org-capture-templates
;; 	'(("t" "Personal todo" entry ("Inbox")
;; 	   "* TODO %?\n%i\n%a" :prepend t))))

(use-package org
  :straight (org :fork (:host nil
                              :repo "https://code.tecosaur.net/tec/org-mode.git"
                              :branch "dev"
                              :remote "tecosaur")
                 :branch "dev"
                 :files (:defaults "etc")
                 :build t
                 :pre-build
                 (with-temp-file "org-version.el"
                   (require 'lisp-mnt)
                   (let ((version
                          (with-temp-buffer
                            (insert-file-contents "lisp/org.el")
                            (lm-header "version")))
                         (git-version
                          (string-trim
                           (with-temp-buffer
                             (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
                             (buffer-string)))))
                     (insert
                      (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
                      (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
                      "(provide 'org-version)\n")))
                 :pin nil)
  :hook (org-mode . org-cdlatex-mode)
  :hook (org-mode . org-indent-mode)
  :hook (org-mode . visual-line-mode)

  :pretty-hydra
  ;; See `org-structure-template-alist'
  ((:color blue :quit-key ("q" "C-g"))
   ("Basic"
    (("a" (hot-expand "<a") "ascii")
     ("c" (hot-expand "<c") "center")
     ("C" (hot-expand "<C") "comment")
     ("x" (hot-expand "<e") "example")
     ("E" (hot-expand "<E") "export")
     ("l" (hot-expand "<l") "latex")
     ("n" (hot-expand "<n") "note")
     ("O" (hot-expand "<q") "quote")
     ("v" (hot-expand "<v") "verse"))
    "Head"
    (("i" (hot-expand "<i") "index")
     ("A" (hot-expand "<A") "ASCII")
     ("I" (hot-expand "<I") "INCLUDE")
     ("H" (hot-expand "<H") "HTML")
     ("L" (hot-expand "<L") "LaTeX"))
    "Source"
    (("s" (hot-expand "<s") "src")
     ("e" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
     ("y" (hot-expand "<s" "python :results output") "python")
     ("p" (hot-expand "<s" "perl") "perl")
     ("w" (hot-expand "<s" "powershell") "powershell")
     ("r" (hot-expand "<s" "ruby") "ruby")
     ("S" (hot-expand "<s" "sh") "sh")
     ("h" (hot-expand "<s" "haskell") "haskell")
     ("o" (hot-expand "<s" "ocaml") "ocaml")
     ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
    "Misc"
    (("m" (hot-expand "<s" "mermaid :file chart.png") "mermaid")
     ("u" (hot-expand "<s" "plantuml :file chart.png") "plantuml")
     ("Y" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0") "ipython")
     ("P" (progn
            (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
            (hot-expand "<s" "perl")) "Perl tangled")
     ("<" self-insert-command "ins"))))
  :bind (:map org-mode-map
              ("<" . (lambda ()
                       "Insert org template."
                       (interactive)
                       (if (or (region-active-p) (looking-back "^\s*" 1))
                           (org-hydra/body)
                         (self-insert-command 1))))
              ("M-<return>" . org-insert-subheading))
  :config
  (elemacs-load-packages-incrementally
   '(calendar find-func format-spec org-macs org-compat
              org-faces org-entities org-list org-pcomplete org-src
              org-footnote org-macro ob org org-clock org-agenda
              org-capture))
  ;; For hydra
  (defun hot-expand (str &optional mod)
    "Expand org template.

STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the structure
element. HEADER string includes more parameters that are prepended to
the element after the #+HEADER: tag."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (if (fboundp 'org-try-structure-completion)
          (org-try-structure-completion) ; < org 9
        (progn
          ;; New template expansion since org 9
          (require 'org-tempo nil t)
          (org-tempo-complete-tag)))
      (when mod (insert mod) (forward-line))
      (when text (insert text))))


  ;; (org-capture-init)
  (add-to-list 'org-modules 'org-habit)
  (setq org-directory "~/org/")
  (add-to-list 'org-agenda-files "~/org")
  (setq org-highlight-latex-and-related '(native latex entities))
  (setq org-startup-indented t)
  (setq org-pretty-entities t
        org-pretty-entities-include-sub-superscripts nil)

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
           "* %U %?\n%i\n%a" :prepend t))

        org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "ON-HOLD(h)" "|" "DONE(d)" "NO(n)")))

  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
  (add-hook 'org-after-refile-insert-hook
            (defun save-buffer-after-capture ()
              (when (bound-and-true-p org-capture-is-refiling)
                (save-buffer)))))

(use-package org-contrib)

(with-eval-after-load 'org
	(setq org-highlight-latex-and-related '(native script entities)))

(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :hook (org-agenda-finalize . org-modern-agenda)
  :init
  (with-eval-after-load 'org
    (setq org-hide-emphasis-markers t
	        org-pretty-entities t))
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
                          (42 . "•"))
	      ))

(use-package org-modern-indent
  :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
	      org-appear-autosubmarkers t
	      org-appear-autolinks nil)
  (run-at-time nil nil #'org-appear--set-elements))

(use-package hl-todo
  :hook (after-init . global-hl-todo-mode)
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

(add-hook 'org-mode-hook
          (lambda ()
            (yas-activate-extra-mode 'LaTeX-mode)))

(use-package org-latex-preview
  :ensure nil
  :hook (org-mode . org-latex-preview-mode)
  :hook (org-latex-preview-mode . org-latex-preview-center-mode)
  :config
  ;; Higher resolution when using dvipng
  (plist-put org-latex-preview-appearance-options :page-width 1.0)
  ;; (plist-put org-latex-preview-appearance-options :margin 1)
  (plist-put org-latex-preview-appearance-options :scale 2.0)

  ;; ;; Block C-n, C-p etc from opening up previews when using `org-latex-preview-mode'
  ;; (setq org-latex-preview-mode-ignored-commands
  ;;       '(next-line previous-line mwheel-scroll
  ;;         scroll-up-command scroll-down-command))

  (setq org-latex-preview-numbered t)
  (setq org-latex-preview-mode-display-live t)
  (setq org-latex-preview-process-default 'dvipng)
  (setq org-latex-preview-mode-update-delay 0.25)
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
            :scale (+ 1.0 (* 0.25 text-scale-mode-amount))))))

  (add-hook 'text-scale-mode-hook #'my/text-scale-adjust-latex-previews))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n w" . org-roam-refile)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :bind (:map org-mode-map
              ("C-c C-x i" . org-id-get-create))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui)

(use-package org-download
  :autoload org-download-clipboard
  :hook ((org-mode dired-mode) . org-download-enable)
  :bind (:map org-mode-map
              ("C-M-y" . org-download-clipboard))
  :config
  (setq-default org-download-heading-lvl 1)
  (defconst org-download-image-dir "./attachments/")
  (setq-default org-download-method 'directory))

(use-package valign
  :hook (org-mode . valign-mode))

(use-package org-noter
  :config
  (use-package djvu))

(provide 'init-org)
