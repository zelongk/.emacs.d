;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :demand t
  :config
  ;; To disable collection of benchmark data after init is done.
  ;; (add-hook 'emacs-startup-hook 'benchmark-init/deactivate)
  )

;; Load some component of large package (org, magit etc.) before complete mount
(defvar elemacs-incremental-packages '(t)
  "A list of packages to load incrementally after startup. Any large packages
  here may cause noticeable pauses, so it's recommended you break them up into
  sub-packages. For example, `org' is comprised of many packages, and can be
  broken up into:

    (elemacs-load-packages-incrementally
     '(calendar find-func format-spec org-macs org-compat
       org-faces org-entities org-list org-pcomplete org-src
       org-footnote org-macro ob org org-clock org-agenda
       org-capture))

  This is already done by the lang/org module, however.

  If you want to disable incremental loading altogether, either remove
  `doom-load-packages-incrementally-h' from `emacs-startup-hook' or set
  `doom-incremental-first-idle-timer' to nil. Incremental loading does not occur
  in daemon sessions (they are loaded immediately at startup).")

(defvar elemacs-incremental-first-idle-timer 2.0
  "How long (in idle seconds) until incremental loading starts.

 Set this to nil to disable incremental loading.")

(defvar elemacs-incremental-idle-timer 0.75
  "How long (in idle seconds) in between incrementally loading packages.")

(defvar elemacs-incremental-load-immediately (daemonp)
  "If non-nil, load all incrementally deferred packages immediately at startup.")

(defun elemacs-load-packages-incrementally (packages &optional now)
  "Registers PACKAGES to be loaded incrementally.

  If NOW is non-nil, load PACKAGES incrementally, in `doom-incremental-idle-timer'
  intervals."
  (if (not now)
      (setq elemacs-incremental-packages (append elemacs-incremental-packages packages ))
    (while packages
      (let* ((gc-cons-threshold most-positive-fixnum)
             (req (pop packages)))
        (unless (featurep req)
          (message "Incrementally loading %s" req)
          (condition-case-unless-debug e
              (or (while-no-input
                    ;; If `default-directory' is a directory that doesn't exist
                    ;; or is unreadable, Emacs throws up file-missing errors, so
                    ;; we set it to a directory we know exists and is readable.
                    (let ((default-directory user-emacs-directory)
                          (inhibit-message t)
                          file-name-handler-alist)
                      (require req nil t))
                    t)
                  (push req packages))
            (error
             (message "Failed to load %S package incrementally, because: %s"
                      req e)))
          (if (not packages)
              (message "Finished incremental loading")
            (run-with-idle-timer elemacs-incremental-idle-timer
                                 nil #'elemacs-load-packages-incrementally
                                 packages t)
            (setq packages nil)))))))

(defun elemacs-load-packages-incrementally-h ()
  "Begin incrementally loading packages in `elemacs-incremental-packages'.

If this is a daemon session, load them all immediately instead."
  (if elemacs-incremental-load-immediately
      (mapc #'require (cdr elemacs-incremental-packages))
    (when (numberp elemacs-incremental-first-idle-timer)
      (run-with-idle-timer elemacs-incremental-first-idle-timer
                           nil #'elemacs-load-packages-incrementally
                           (cdr elemacs-incremental-packages) t))))

(add-hook 'emacs-startup-hook #'elemacs-load-packages-incrementally-h)

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :commands exec-path-from-shell-initialize
    :init
    (setq exec-path-from-shell-arguments '("-l"))
    (exec-path-from-shell-initialize)))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(add-hook 'after-init-hook (lambda () (load custom-file 'no-error 'no-message)))

;; Start server
(use-package server
  :hook (emacs-startup . (lambda ()
			                     (unless server-mode
                             (server-mode 1)))))

;; Save place
(use-package saveplace
  :hook (after-init . save-place-mode))

(use-package display-line-numbers
  :straight nil
  :hook (text-mode . display-line-numbers-mode)
  :hook (prog-mode . display-line-numbers-mode)
  :config
  (dolist (mode '(erc-mode-hook
                  circe-mode-hook
                  help-mode-hook
                  gud-mode-hook
		              treemacs-mode-hook
                  org-mode-hook
                  vterm-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode -1))))
  (setq display-line-numbers-type 'relative)
  )
(use-package del-trailing-white
  :straight nil
  :hook ((prog-mode markdown-mode conf-mode) . enable-trailing-whitespace)
  :init
  (setq-default show-trailing-whitespace nil)
  (defun enable-trailing-whitespace ()
    "Show trailing spaces and delete on saving."
    (setq show-trailing-whitespace t)
    (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))
  )

(use-package subword
  :straight nil
  :diminish
  :hook (prog-mode minibuffer-setup))

(use-package paren
  :straight nil
  :hook (after-init . show-paren-mode))

;; ;; Show trailing whitespace only in prog-mode and text-mode
;; (add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))
;; (add-hook 'text-mode-hook (lambda () (setq show-trailing-whitespace t)))

(use-package recentf
  :straight nil
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-saved-items 500
        recentf-exclude
        '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
          "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
          "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
          "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
          (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name)
  )

(use-package savehist
  :straight nil
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
                                              global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

(setq-default cursor-type 'bar)
(setq kill-whole-line t)
(setq make-backup-files nil)
(setq use-short-answers t)
;; (setq frame-title-format "\n")
(setq custom-safe-themes t)

(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 5))

(pcase system-type ('darwin (setq insert-directory-program "gls")))

(setq-default tab-width 2
              standard-indent 2
	            compilation-scroll-output t
	            indent-tabs-mode nil)

(setq ring-bell-function 'ignore)
(setq undo-limit 80000000
      password-cache-expiry nil)

(setq-default delete-by-moving-to-trash t
	            x-stretch-cursor t
	            window-combination-resize t)

(define-key global-map (kbd "C-<wheel-up>")  nil)
(define-key global-map (kbd "C-<wheel-down>")  nil)
(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;对应Windows上面的Ctrol-z 撤销

(setq kill-ring-max 200)
;; Save clipboard contents into kill-ring before replace them
(setq save-interprogram-paste-before-kill t)

;; Kill & Mark things easily
(use-package easy-kill
  :bind (([remap kill-ring-save] . easy-kill)
         ([remap mark-sexp] . easy-mark)))

(use-package browse-kill-ring
  :bind ("C-c k" . browse-kill-ring)
  :hook (after-init . browse-kill-ring-default-keybindings)
  :init (setq browse-kill-ring-separator "────────────────"
              browse-kill-ring-separator-face 'shadow))

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3
	      scroll-margin 0)
  :hook (after-init . ultra-scroll-mode))

(use-package helpful
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-command]  . helpful-command)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key]      . helpful-key)
         ([remap describe-symbol]   . helpful-symbol)
         :map emacs-lisp-mode-map
         ("C-c C-d"                 . helpful-at-point)
         :map lisp-interaction-mode-map
         ("C-c C-d"                 . helpful-at-point)
         :map helpful-mode-map
         ("r"                       . remove-hook-at-point)
         ("q"                       . kill-current-buffer))
  :hook (helpful-mode . cursor-sensor-mode) ; for remove-advice button
  :init
  (with-no-warnings
    (with-eval-after-load 'apropos
      ;; patch apropos buttons to call helpful instead of help
      (dolist (fun-bt '(apropos-function apropos-macro apropos-command))
        (button-type-put
         fun-bt 'action
         (lambda (button)
           (helpful-callable (button-get button 'apropos-symbol)))))
      (dolist (var-bt '(apropos-variable apropos-user-option))
        (button-type-put
         var-bt 'action
         (lambda (button)
           (helpful-variable (button-get button 'apropos-symbol))))))))

(setq delete-by-moving-to-trash t
      inhibit-compacting-font-caches t
      make-backup-files nil)

(setq-default auto-save-default nil)
(setq create-lockfiles nil)
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(use-package tramp-hlo
  :config
  (tramp-hlo-setup))

(use-package tramp-rpc
  :straight (tramp-rpc :host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :config
  (tramp-rpc-magit-enable)
  (tramp-rpc-projectile-enable))

(provide 'init-better-default)
