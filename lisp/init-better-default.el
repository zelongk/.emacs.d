;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :ensure t
  :demand t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'elpaca-after-init-hook 'benchmark-init/deactivate))

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :init
    (exec-path-from-shell-initialize)))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'no-error 'no-message)))

(use-package server
  :ensure nil
  :hook (elpaca-after-init . server-mode))

(use-package display-line-numbers
  :ensure nil
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
(column-number-mode 1)
(scroll-bar-mode -1)

;; (use-package delete-trailing
;;   :ensure nil
;;   :hook (text-mode delete-trailing-whitespace-mode)
;;   :hook (prog-mode delete-trailing-whitespace-mode))
(add-hook 'prog-mode #'delete-trailing-whitespace-mode)
(add-hook 'text-mode #'delete-trailing-whitespace-mode)

(use-package subword
  :ensure nil
  :diminish
  :hook (prog-mode minibuffer-setup))

(use-package paren
  :ensure nil
  :hook (elpaca-after-init . show-paren-mode))

;; Show trailing whitespace only in prog-mode and text-mode
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))
(add-hook 'text-mode-hook (lambda () (setq show-trailing-whitespace t)))

(use-package recentf
  :ensure nil
  :hook (elpaca-after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 500)
  (recentf-exclude
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
  :ensure nil
  :hook (elpaca-after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
                                              global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

(setq-default cursor-type 'bar)
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
  :hook (elpaca-after-init . browse-kill-ring-default-keybindings)
  :init (setq browse-kill-ring-separator "────────────────"
              browse-kill-ring-separator-face 'shadow))

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3
	scroll-margin 0)
  :hook (elpaca-after-init . ultra-scroll-mode))

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

(setq-default auto-save-default nil)
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(use-package tramp-hlo
  :config
  (tramp-hlo-setup))

(use-package tramp-rpc
  :ensure (tramp-rpc :host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :config
  (tramp-rpc-magit-enable)
  (tramp-rpc-projectile-enable))

(provide 'init-better-default)
