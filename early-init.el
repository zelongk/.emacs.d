;; early-init --- Setup before init.el -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(if noninteractive  ; in CLI sessions
    (setq-default gc-cons-threshold (* 128 1024 1024)   ; 128MB
                  ;; Backport from 29 (see emacs-mirror/emacs@73a384a98698)
                  gc-cons-percentage 1.0)
  (setq-default gc-cons-threshold most-positive-fixnum
                gc-cons-percentage 1.0))

(setq read-process-output-max (* 1024 1024))

(setq package-enable-at-startup nil
      load-prefer-newer t)

(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "site-lisp/" user-emacs-directory))

(setenv "LSP_USE_PLISTS" "true") ;; Lsp-mode plists
(setenv "LIBGS" "/opt/homebrew/lib/libgs.dylib")

;; PERF: Many elisp file API calls consult `file-name-handler-alist'.
;; Setting it to nil speeds up startup significantly.
;; We restore it in init.el after startup.
(setq file-name-handler-alist nil)

;; PERF: Reduce file-name operations on `load-path'.
;; No dynamic modules are loaded this early, so we skip .so/.dll search.
;; Also skip .gz to avoid decompression checks.
(setq load-suffixes '(".elc" ".el")
      load-file-rep-suffixes '(""))

(prefer-coding-system 'utf-8)
;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)
(setq auto-mode-case-fold nil)
(setq jka-compr-verbose init-file-debug)
(setq bidi-inhibit-bpa t)

;; Suppress GUI features
(setq inhibit-x-resources t
      inhibit-startup-buffer-menu t
      initial-buffer-choice t)
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(advice-add #'display-startup-screen :override #'ignore)
(fset #'display-startup-echo-area-message #'ignore)

;; Faster to disable these here (before they've been initialized)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(horizontal-scroll-bars . nil) default-frame-alist)
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))
(when (featurep 'mac)
  (push '(mac-transparent-titlebar . t) default-frame-alist))

;; Prevent flash of unstyled mode line
(setq mode-line-format nil)

(when (boundp 'native-comp-eln-load-path)
  (setcar native-comp-eln-load-path
          (expand-file-name "~/.cache/eln-cache/")))

(when (native-comp-available-p)
  (setq native-comp-jit-compilation nil
        native-comp-async-jobs-number 10
        native-comp-async-report-warnings-errors 'silent))

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))

(provide 'early-init)
;;; early-init.el ends here
