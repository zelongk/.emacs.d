;; -*- lexical-binding: t -*-

(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)

(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'init-elpaca)
(require 'init-gc)

(setq use-package-enable-imenu-support t)
(setq load-prefer-newer noninteractive)

(prefer-coding-system 'utf-8)
;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Optimize `auto-mode-alist`
(setq auto-mode-case-fold nil)
(unless (or (daemonp) noninteractive init-file-debug)
  ;; Temporarily suppress file-handler processing to speed up startup
  (let ((default-handlers file-name-handler-alist))
    (setq file-name-handler-alist nil)
    ;; Recover handlers after startup
    (add-hook 'emacs-startup-hook
              (lambda ()
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist default-handlers))))
              101)))

;; Faster to disable these here (before they've been initialized)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))
  ;; (push '(ns-appearance . dark) default-frame-alist))

;; Prevent flash of unstyled mode line
(setq mode-line-format nil)

(provide 'early-init)
