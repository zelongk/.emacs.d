;; -*- lexical-binding: t -*-

;; Optimize Garbage Collection for Startup
(setq gc-cons-threshol 33554432)

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


(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
(require 'init-elpaca)

(require 'init-better-default)
(require 'init-completion)
(require 'init-meow)
(require 'init-edit)
(require 'init-ui)
(require 'init-bindings)

(require 'init-dired)
(require 'init-dashboard)

(require 'init-llm)

(require 'init-lsp)
(require 'init-coding)
(require 'init-org)
(require 'init-tex)
(require 'init-typst)
(require 'init-cc)
(require 'init-python)
