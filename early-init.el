;; -*- lexical-binding: t -*-

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; After init, use gcmh
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold #x6400000
                  gc-cons-percentage 0.1)))

(setq package-enable-at-startup nil)

(setq native-comp-jit-compilation t)
(setq native-comp-async-report-warnings-errors nil)

(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
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
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(horizontal-scroll-bars . nil) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))
;; (push '(ns-appearance . light) default-frame-alist))

;; Prevent flash of unstyled mode line
(setq mode-line-format nil)

(provide 'early-init)
