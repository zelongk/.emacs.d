;;; init.el --- This is the  -*- lexical-binding: t -*-
;;; Commentary:
;; Personal Emacs config
;; Greatly referred to Centaur Emacs

;;; Code:

;; A helper to keep track of start-up time:
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

(eval-and-compile
  (defvar user-cache-directory (expand-file-name ".cache/" user-emacs-directory))

  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (add-hook 'after-init-hook (lambda () (load custom-file t t)))

  (defvar secrets-file (expand-file-name "secrets.el" user-emacs-directory))
  (add-hook 'after-init-hook (lambda () (load secrets-file t t)))

  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
                           ("nongnu-elpa" . "https://elpa.nongnu.org/nongnu/"))
        package-archive-priorities '(("gnu-elpa-devel" . 3)
                                     ("nongnu-elpa" . 2)
                                     ("melpa" . 1))
        package-install-upgrade-built-in t
        package-quickstart-file (expand-file-name "quickstart.el" user-cache-directory)
        package-vc-register-as-project nil)

  ;; <leaf-install-code>
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (setq leaf-expand-minimally t
        leaf-enable-imenu-support t)

  (leaf leaf-keywords :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf blackout :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))
  ;; </leaf-install-code>
  )

;; (require 'init-elpaca)
;; (require 'init-straight)

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

(require 'init-eglot)
;; (require 'init-lsp)
(require 'init-tex)
(require 'init-cc)
(require 'init-python)
(require 'init-haskell)
(require 'init-rust)
(require 'init-ocaml)
(require 'init-zig)
(require 'init-typst)

(provide 'init)
;;; init.el ends here
