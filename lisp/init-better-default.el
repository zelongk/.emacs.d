;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :ensure t
  :demand t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'elpaca-after-init-hook 'benchmark-init/deactivate))

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'no-error 'no-message)))

(use-package server
  :ensure nil
  :hook (elpaca-after-init . server-mode))

(use-package display-line-numbers
  :ensure nil
  :hook (elpaca-after-init . global-display-line-numbers-mode)
  :config
  (dolist (mode '(erc-mode-hook
                  circe-mode-hook
                  help-mode-hook
                  gud-mode-hook
		  treemacs-mode-hook
                  vterm-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode -1))))
  (setq display-line-numbers-type 'relative)
  )
(column-number-mode 1)

(use-package subword
  :ensure nil
  :hook (elpaca-after-init . global-subword-mode))

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
(setq frame-title-format "Emacs: %b")
(setq custom-safe-themes t)

(setq insert-directory-program "gls")

(setq-default tab-width 4
	          compilation-scroll-output t
	          indent-tabs-mode nil)

(setq ring-bell-function 'ignore)
(setq undo-limit 80000000
      auto-save-default t
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
  
(provide 'init-better-default)
