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

(use-package subword
  :ensure nil
  :diminish
  :hook (prog-mode minibuffer-setup))

(use-package paren
  :ensure nil
  :hook (elpaca-after-init . show-paren-mode))

(recentf-mode 1)
(use-package recentf
  :ensure nil
  :hook (elpaca-after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 500))

(setq-default cursor-type 'bar)
(setq make-backup-files nil)
(setq use-short-answers t)
(setq frame-title-format "\n")
(setq custom-safe-themes t)

;; 隐藏 title bar
(setq default-frame-alist '((undecorated-round . t)))
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 5))

(pcase system-type ('darwin (setq insert-directory-program "gls")))
    
(setq-default tab-width 4
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
         ("r"                       . remove-hook-at-point))
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

;; (setq auto-save-file-name-transforms
;;       `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(provide 'init-better-default)
