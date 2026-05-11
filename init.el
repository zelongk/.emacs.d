;;; init.el --- This is the  -*- lexical-binding: t -*-

;; A helper to keep track of start-up time:
(eval-when-compile (require 'cl-lib))
(let ((emacs-start-time (current-time)))
  (add-hook 'emacs-startup-hook
            (lambda ()
              (let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
                (message "[Emacs initialized in %.3fs]" elapsed)))))

;; Optimize `auto-mode-alist`
(setq auto-mode-case-fold nil)

;; Restore file-name-handler-alist after startup.
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

(defvar user-cache-directory (expand-file-name ".cache/" user-emacs-directory))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-hook 'after-init-hook (lambda () (load custom-file t t)))

(setq secrets-file (expand-file-name "secrets.el" user-emacs-directory))
(eval-and-compile
  (when (boundp 'secrets-file)
    (load secrets-file t t)))

;; (require 'init-elpaca)
;; (require 'init-straight)
(require 'init-package)
(require 'init-gc)
(require 'init-better-default)

(require 'init-ui)
(require 'init-edit)
(require 'init-completion)
(require 'init-corfu)
(require 'init-snippet)

(require 'init-bindings)
(require 'init-dired)
(require 'init-window)
(require 'init-shell)
(require 'init-workspace)

;; (require 'init-god)
;; (require 'init-meow)

(require 'init-input)
(require 'init-utils)
;; (require 'init-svg)
;; (require 'init-eaf)

(require 'init-coding)
(require 'init-vcs)
(require 'init-llm)
(require 'init-check)
(require 'init-writing)

(require 'init-pretty-latex)

(require 'init-org)
(require 'init-markdown)

;; (require 'init-roam)
(require 'init-denote)

;; (require 'init-eglot)
(require 'init-lsp)
(require 'init-tex)
(require 'init-cc)
(require 'init-python)
(require 'init-haskell)
(require 'init-rust)
(require 'init-ocaml)
(require 'init-zig)
;; (require 'init-typst)


(provide 'init)
;;; init.el ends here
