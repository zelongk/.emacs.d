;; -*- lexical-binding: t -*-
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-line-numbers-mode 1)
(setq-default cursor-type 'bar)
(setq display-line-numbers 'relative)
(show-paren-mode t)
(recentf-mode 1)
(setq recentf-max-menu-item 10)
(setq make-backup-files nil)
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'no-error 'no-message)

(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-x") 'sexp) ;对应Windows上面的Ctrol-x 剪切

(provide 'init-better-default)
