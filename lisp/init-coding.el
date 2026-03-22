;; -*- lexical-binding: t -*-

(use-package transient)

(use-package magit
  :bind (("C-c g" . magit-dispatch))
  :config
  (setq magit-show-long-lines-warning nil)
  )

(setq system-uses-terminfo nil)
(setq compilation-environment '("TERM=xterm-256color"))
(setq eshell-banner-message "")


(use-package eat
  :bind ("C-`" . eat-toggle)
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :ensure `(eat :repo "https://codeberg.org/akib/emacs-eat"
		:files ("*.el" ("term" "term/*.el") "*.texi"
			"*.ti" ("terminfo/e" "terminfo/e/*")
			("terminfo/65" "terminfo/65/*")
			("integration" "integration/*")
			(:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-term-name "xterm-256color")
  (eat-kill-buffer-on-exit t)
  (eat-shell )
  :config
  (defun eat-toggle () (interactive)
       (if (string= (buffer-name) "*eshell*")
           (delete-window)
         (eshell)))

  (setq tramp-remote-process-environment '("TERM=xterm-256color" "TERMINFO=''" "ENV=''" "TMOUT=0" "LC_CTYPE=''" "CDPATH=" "HISTORY=" "MAIL=" "MAILCHECK=" "MAILPATH=" "PAGER=cat" "autocorrect=" "correct="))
  (when (eq system-type 'darwin)
    (define-key eat-semi-char-mode-map (kbd "C-h")  #'eat-self-input)
    (define-key eat-semi-char-mode-map (kbd "<backspace>") (kbd "C-h"))))

(use-package eshell-prompt-extras
  :after esh-opt
  :defines eshell-highlight-prompt
  :autoload (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
  :init
  (setq eshell-highlight-prompt t
        eshell-prompt-function #'epe-theme-lambda))

(use-package eshell-z
  :hook (eshell-mode . (lambda () (require 'eshell-z))))

(use-package esh-help
  :commands setup-esh-help-eldoc
  :init (setup-esh-help-eldoc))

(use-package eshell-syntax-highlighting
  :after eshell-mode
  :hook (elpaca-after-init . eshell-syntax-highlighting-global-mode))

(use-package editorconfig
  :diminish
  :hook elpaca-after-init)

(use-package yaml-mode)
;; Fish shell mode and auto-formatting
(use-package fish-mode
  :commands fish_indent-before-save
  :defines eglot-server-programs
  :hook (fish-mode . (lambda ()
                       "Integrate `fish_indent` formatting with Fish shell mode."
                       (add-hook 'before-save-hook #'fish_indent-before-save)))
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(fish-mode . ("fish-lsp" "start")))))

(use-package docker-compose-mode)

(use-package treesit-auto
  :hook (elpaca-after-init . global-treesit-auto-mode)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(use-package systemd)

(add-hook 'prog-mode-hook #'toggle-truncate-lines)

(provide 'init-coding)
