;;; init.el --- This is the  -*- lexical-binding: t -*-

;;; Commentary:
;; Personal Emacs config
;; Based largely on Centaur Emacs

;;; Code:

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

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (load custom-file 'no-error 'no-message)

(eval-and-compile
  (defvar user-cache-directory (expand-file-name ".cache/" user-emacs-directory))
  
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
                           ("gnu-elpa" . "https://elpa.gnu.org/packages/")
                           ("nongnu-elpa" . "https://elpa.nongnu.org/nongnu/"))
        package-archive-priorities '(("gnu-elpa" . 3)
                                     ("nongnu-elpa" . 2)
                                     ("melpa" . 1))
        package-install-upgrade-built-in t
        ;; package-quickstart-file (expand-file-name "quickstart.el" user-cache-directory)
        package-vc-register-as-project nil)

  (setq package-pinned-packages
        '((leaf . "gnu-elpa-devel")))
  
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (unless (package-installed-p 'leaf)
    (package-install 'leaf))

  (setq leaf-enable-imenu-support t)

  (leaf leaf-keywords :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf blackout :ensure t)
    :config (leaf-keywords-init)))

(leaf gnu-elpa-keyring-update)
;; This has to be installed/loaded ahead.
(leaf org
  :vc (org-mode :url "https://code.200568.top/mirrors/org-mode/" :branch "dev"))
(leaf org-contrib :ensure t)

;; (require 'init-elpaca)
;; (require 'init-straight)

(require 'init-gc)
(require 'init-better-default)
(require 'init-bindings)

(require 'init-modeline)
(require 'init-ui)
(require 'init-edit)
(require 'init-completion)
(require 'init-corfu)

(require 'init-dired)
(require 'init-window)
(require 'init-shell)
(require 'init-workspace)

;; (require 'init-god)
;; (require 'init-meow)

(require 'init-input)
(require 'init-utils)

(require 'init-coding)
(require 'init-snippet)
(require 'init-vcs)
(require 'init-llm)
(require 'init-check)
(require 'init-writing)

(require 'init-org)
(require 'init-markdown)

(require 'init-pretty-latex)

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
