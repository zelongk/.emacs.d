;; -*- lexical-binding: t -*-

(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
(defconst IS-GUIX    (and IS-LINUX
                          (with-temp-buffer
                            (insert-file-contents "/etc/os-release")
                            (re-search-forward "ID=\\(?:guix\\|nixos\\)" nil t))))

(leaf benchmark-init :elpaca t
  :leaf-defer nil
  :hook (elpaca-after-init-hook . benchmark-init/deactivate))

(defun native-compile-elpaca ()
  "Native-compile packages in elpa directory."
  (interactive)
  (if (fboundp 'native-compile-async)
      (native-compile-async elpaca-builds-directory t)))

(defun native-compile-site-lisp ()
  "Native compile packages in site-lisp directory."
  (interactive)
  (let ((dir (locate-user-emacs-file "site-lisp")))
    (if (fboundp 'native-compile-async)
        (native-compile-async dir t))))

(when (memq window-system '(ns x))
  (leaf exec-path-from-shell
    :elpaca t
    :commands exec-path-from-shell-initialize
    :init
    (setq exec-path-from-shell-arguments '("-l")
          exec-path-from-shell-variables '("PATH" "MANPATH" "HOMEBREW_NO_AUTO_UPDATE"
                                           "HOMEBREW_NO_ENV_HINTS" "LIBGS" "PYTHONPATH"))
    (exec-path-from-shell-initialize)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'no-error 'no-message)))

(setq secrets-file (expand-file-name "secrets.el" user-emacs-directory))
(add-hook 'elpaca-after-init-hook (lambda () (when (file-exists-p secrets-file)
                                               (load secrets-file 'no-error 'no-message))))

(setq package-user-dir (expand-file-name "elpa" user-cache-directory))

;; Start server
(leaf server
  :require t
  :hook (emacs-startup-hook . (lambda ()
			                    (unless (server-running-p)
                                  (server-mode 1)))))

(leaf saveplace
  :require t
  :hook (elpaca-after-init-hook . save-place-mode)
  :config
  (setq save-place-file (expand-file-name "places" user-cache-directory)))

(leaf display-line-numbers
  :require t
  :hook (text-mode-hook . display-line-numbers-mode)
  :hook (prog-mode-hook . display-line-numbers-mode)
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
  (setq display-line-numbers-width-start 4))

(leaf subword
  :require t
  :hook (prog-mode-hook minibuffer-setup-hook))

(leaf paren
  :require t
  :hook (elpaca-after-init-hook . show-paren-mode))

(leaf recentf
  :require t
  :hook (elpaca-after-init-hook . recentf-mode)
  :init
  (setq recentf-max-saved-items 500
        recentf-exclude
        '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
          "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
          "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
          "^/tmp/" "^/var/folders/.+$" "^/ssh:" "^/rpc:" "/persp-confs/"
          "^/sshx:" "^/sudo:"
          (lambda (file) (file-in-directory-p file package-user-dir)))
        recentf-auto-cleanup 'never)
  (setq recentf-save-file (expand-file-name "recentf" user-cache-directory))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

(leaf savehist
  :require t
  :hook (elpaca-after-init-hook . savehist-mode)
  :init
  (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
        history-length 1000
        savehist-file (expand-file-name "history" user-cache-directory)
        savehist-additional-variables '(mark-ring
                                        global-mark-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history)
        savehist-autosave-interval 300))

(leaf emacs
  :init
  (setq-default cursor-type 'bar)
  (setq kill-whole-line t
        make-backup-files nil
        use-short-answers t
        confirm-kill-processes nil)

  (if IS-MAC
      (setq mac-command-modifier 'super
            mac-option-modifier 'meta))
  
  (add-to-list 'default-frame-alist '(drag-internal-border . 1))
  (add-to-list 'default-frame-alist '(internal-border-width . 5))

  (pcase system-type ('darwin (setq insert-directory-program "gls")))

  (defvar my/tab-size 4)
  (setq-default tab-width my/tab-size
                standard-indent my/tab-size
                c-basic-offset my/tab-size
                compilation-scroll-output t
	            indent-tabs-mode nil)

  (setq ring-bell-function 'ignore)
  (setq undo-limit 80000000
        password-cache-expiry nil)

  (setq-default delete-by-moving-to-trash t
	            x-stretch-cursor t
	            window-combination-resize t)

  (setq kill-ring-max 200)
  ;; Save clipboard contents into kill-ring before replace them
  (setq save-interprogram-paste-before-kill t)

  ;; Kill & Mark things easily
  (leaf easy-kill
    :elpaca t
    :bind (([remap kill-ring-save] . easy-kill)
           ([remap mark-sexp] . easy-mark))))

(leaf ultra-scroll
  :elpaca t
  :init
  (setq scroll-conservatively 3
	    scroll-margin 0)
  :hook (elpaca-after-init-hook . ultra-scroll-mode))

(leaf helpful
  :elpaca t
  :bind
  (([remap describe-function] . helpful-callable)
   ([remap describe-command]  . helpful-command)
   ([remap describe-variable] . helpful-variable)
   ([remap describe-key]      . helpful-key)
   ([remap describe-symbol]   . helpful-symbol))
  (:emacs-lisp-mode-map
   ("C-c C-d"                 . helpful-at-point))
  (:lisp-interaction-mode-map
   ("C-c C-d"                 . helpful-at-point))
  (:helpful-mode-map
   ("r"                       . remove-hook-at-point)
   ("q"                       . kill-current-buffer))
  :hook (helpful-mode-hook . cursor-sensor-mode) ; for remove-advice button
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

;; file related
(leaf emacs
  :init
  (setq auto-save-list-file-prefix (expand-file-name ".saves-" user-cache-directory)
        auto-save-list-file-name (expand-file-name ".saves-mac" user-cache-directory))
  (setq-default auto-save-default nil)
  (setq delete-by-moving-to-trash t
        inhibit-compacting-font-caches t
        make-backup-files nil)

  (setq create-lockfiles nil))

(leaf tramp
  :elpaca t
  :commands (sudo-find-file sudo-this-file)
  :bind ("C-x C-S-f" . sudo-find-file)
  :config
  (setq tramp-default-method "sshx")
  (defun sudo-find-file (file)
    "Open FILE as root."
    (interactive "FOpen file as root: ")
    (when (file-writable-p file)
      (user-error "File is user writeable, aborting sudo"))
    (find-file (if (file-remote-p file)
                   (concat "/" (file-remote-p file 'method) ":"
                           (file-remote-p file 'user) "@" (file-remote-p file 'host)
                           "|sudo:root@"
                           (file-remote-p file 'host) ":" (file-remote-p file 'localname))
                 (concat "/sudo:root@localhost:" file))))
  (defun sudo-this-file ()
    "Open the current file as root."
    (interactive)
    (sudo-find-file (file-truename buffer-file-name)))

  (setq tramp-verbose 1
        tramp-persistency-file-name (expand-file-name "tramp" user-cache-directory)
        tramp-allow-unsafe-temporary-files t)
  (setq remote-file-name-inhibit-locks t
        remote-file-name-inhibit-auto-save-visited t
        tramp-copy-size-limit (* 1024 1024)))

(leaf bookmark
  :config
  (setq bookmark-default-file (expand-file-name "bookmarks" user-cache-directory)
        bookmark-fringe-mark nil))

(leaf tramp-rpc
  :disabled t
  :elpaca (tramp-rpc :host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :config
  (setq tramp-rpc-deploy-local-cache-directory (expand-file-name "tramp-rpc" user-cache-directory))
  (tramp-rpc-magit-enable))

(leaf tramp-hlo :elpaca t
  :after tramp
  :require t
  :config
  (tramp-hlo-setup))

(leaf transient
  :elpaca (transient :host github :repo "magit/transient")
  :require t
  :config
  (transient-bind-q-to-quit)
  (setq transient-history-file (expand-file-name "transient/history.el" user-cache-directory)
        transient-levels-file (expand-file-name "transient/levels.el" user-cache-directory)
        transient-values-file (expand-file-name "transient/values.el" user-cache-directory)
        transient-show-popup t))

(provide 'init-better-default)
