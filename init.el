;;; init.el --- This is the  -*- lexical-binding: t no-byte-compile: t -*-

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

(setq custom-file (make-temp-file "emacs-custom-"))

(eval-and-compile
  (defvar user-cache-directory (expand-file-name ".cache/" user-emacs-directory))
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
                           ("gnu-elpa" . "https://elpa.gnu.org/packages/")
                           ("nongnu-elpa" . "https://elpa.nongnu.org/nongnu/"))
        package-archive-priorities '(("gnu-elpa" . 3)
                                     ("melpa" . 2)
                                     ("nongnu-elpa" . 1))
        package-install-upgrade-built-in t
        ;; package-quickstart-file (expand-file-name "quickstart.el" user-cache-directory)
        package-vc-register-as-project nil)

  (setq package-review-policy
        (delq nil
              (append
               (mapcar
                (lambda (archive)
                  (let ((archive-name (car archive)))
                    (unless (string= archive-name "gnu-elpa-devel")
                      (cons 'archive archive-name))))
                package-archives))))

  (setq package-review-diff-command
        (cons diff-command
              '("-u"
                "-x" "'*.elc'"
                "-x" "'*-autoloads.el'"
                "-x" "'*-pkg.el'"
                "-x" "'*.info'"
                "-x" "'*.texi'"
                "-x" "'*.txt'"
                "-x" "'*.md'"
                "-x" "'*.org'")))

  (setq package-pinned-packages
        '((leaf . "gnu-elpa-devel")))
  
  ;; (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (setq leaf-enable-imenu-support t)
  (leaf gnu-elpa-keyring-update)
  
  (leaf leaf-keywords :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf blackout :ensure t)
    :config (leaf-keywords-init)))

(leaf org
  :vc (org :url "https://code.200568.top/mirrors/org-mode/" :branch "dev"))

;; (require 'init-elpaca)
;; (require 'init-straight)
(require 'init-gc)

(leaf benchmark-init :ensure t
  :disabled t
  :require t
  :hook (after-init-hook . benchmark-init/deactivate))

(require 'init-ui)
(require 'init-better-default)
(require 'init-modeline)

(require 'init-corfu)
(require 'init-completion)

(require 'init-edit)
(require 'init-utils)

;; (require 'init-god)
;; (require 'init-meow)

(require 'init-window)
(require 'init-workspace)
(require 'init-dired)
(require 'init-shell)
(require 'init-vcs)

;; (require 'init-roam)
(require 'init-denote)

;; INPUT METHOD
(require 'init-input)

(require 'init-coding)
(require 'init-check)
(require 'init-snippet)
(require 'init-llm)
(require 'init-writing)

(require 'init-org)
(require 'init-markdown)

(require 'init-pretty-latex)

(require 'init-eglot)
;; (require 'init-lsp)

(require 'init-tex)
(require 'init-cc)
(require 'init-python)
(require 'init-haskell)
(require 'init-rust)
(require 'init-ocaml)
(require 'init-racket)
(require 'init-zig)
(require 'init-typst)

(require 'init-icons)

(provide 'init)
;;; init.el ends here


