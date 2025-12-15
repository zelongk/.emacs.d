;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :ensure t
  :demand t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'elpaca-after-init-hook 'benchmark-init/deactivate))

(server-mode 1)

(global-display-line-numbers-mode)
(dolist (mode '(erc-mode-hook
                circe-mode-hook
                help-mode-hook
                gud-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(setq-default cursor-type 'bar)
(setq display-line-numbers-type 'relative)
(show-paren-mode t)
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq make-backup-files nil)
(setq use-short-answers t)
(setq frame-title-format "Emacs: %b")

(setq-default delete-by-moving-to-trash t
	      x-stretch-cursor t
	      window-combination-resize t)

(global-subword-mode 1)

(setq undo-limit 80000000
      auto-save-default t
      password-cache-expiry nil)

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'no-error 'no-message)))

(setq custom-safe-themes t)

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

;; Interactively insert and edit items from kill-ring
;; (use-package browse-kill-ring
;;   :hook (elpaca-after-init . browse-kill-ring-default-keybindings)
;;   :init (setq browse-kill-ring-separator "────────────────"
;;               browse-kill-ring-separator-face 'shadow))

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(global-set-key (kbd "C-x b") 'ibuffer)

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3
	scroll-margin 0)
  :hook (elpaca-after-init . ultra-scroll-mode))
  

(provide 'init-better-default)
