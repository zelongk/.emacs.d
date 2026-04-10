;;; init.el --- This is the  -*- lexical-binding: t -*-
;;; Commentary:
;;; blablabla

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

(require 'init-elpaca)
;; (require 'init-straight)
(require 'init-gc)
(require 'init-better-default)
(require 'init-hydra)

(require 'init-ui)
(require 'init-edit)
(require 'init-completion)
(require 'init-snippet)

(require 'init-bindings)
(require 'init-dired)
;; (require 'init-dashboard) ;; not working
(require 'init-window)
(require 'init-shell)
;; (require 'init-treemacs) ;; not working
(require 'init-workspace)

;; (require 'init-god)
;; (require 'init-meow)

(require 'init-input)
(require 'init-utils)
;; (require 'init-eaf)

(require 'init-coding)
(require 'init-vcs)
(require 'init-llm)
(require 'init-check)
(require 'init-writing)

;; (require 'init-eglot)
(require 'init-lsp)

(require 'init-org)
(require 'init-tex)
(require 'init-cc)
(require 'init-python)
(require 'init-haskell)
(require 'init-rust)
(require 'init-ocaml)
(require 'init-typst)


(provide 'init)
;;; Code:
;;; alskdjasd
;;; init.el ends here
