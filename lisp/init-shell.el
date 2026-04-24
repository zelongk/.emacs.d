;; -*- lexical-binding: t; -*-

(use-package comint
  :init
  (setq ansi-color-for-comint-mode t
        ansi-color-for-compilation-mode t))

(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter)) 


(use-package xterm-color
  :ensure t
  :defines (compilation-environment)
  :init
  (setenv "TERM" "xterm-256color")
  (setq comint-output-filter-functions
        (remove 'ansi-color-process-output comint-output-filter-functions))
  (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)

  (setq compilation-environment '("TERM=xterm-256color"))
  (defun my/advice-compilation-filter (fn proc string)
    (funcall fn proc
             (if (eq major-mode 'rg-mode) ; compatible with `rg'
                 string
               (xterm-color-filter string))))
  (advice-add 'compilation-filter :around #'my/advice-compilation-filter)
  (advice-add 'gud-filter :around #'my/advice-compilation-filter))

(use-package eat
  :bind (("C-`" . eat-toggle)
         ("C-<escape>" . eshell-toggle)
         ([remap project-shell] . eat-project))
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :ensure `(eat :repo "https://codeberg.org/akib/emacs-eat"
		        :files ("*.el" ("term" "term/*.el") "*.texi"
			            "*.ti" ("terminfo/e" "terminfo/e/*")
			            ("terminfo/65" "terminfo/65/*")
			            ("integration" "integration/*")
			            (:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-kill-buffer-on-exit t)
  (eat-shell "/opt/homebrew/bin/elvish")
  (eat-tramp-shells '(("docker" . "/bin/sh")
                      ("ssh" . "/bin/bash")
                      ("sshx" . "/bin/bash")
                      ("rpc" . "/bin/bash")))
  ;; Clear commands eshell considers visual by default.
  (eshell-visual-commands '())
  (eat-minimum-latency 0.002)
  (eat-enable-directory-tracking t)
  (eat-enable-shell-prompt-annotation t)
  
  :config
  (defun eshell-toggle () (interactive)
         (if (string= (buffer-name) "*eshell*")
             (delete-window)
           (eshell)))
  (defun eat-toggle () (interactive)
         (if (string= (buffer-name) "*eat*")
             (delete-window)
           (eat)))

  ;; Improve latency
  (setq process-adaptive-read-buffering t)  

  (when (eq system-type 'darwin)
    (define-key eat-semi-char-mode-map (kbd "C-h")  #'eat-self-input)
    (define-key eat-semi-char-mode-map (kbd "<backspace>") (kbd "C-h"))))



;;; Eshell related
(use-package eshell
  :defer
  :defines eshell-prompt-function
  :bind (:map eshell-mode-map
              ([remap recenter-top-bottom] . eshell/clear))
  :config
  (setq eshell-banner-message ""))

(use-package eshell-prompt-extras
  :ensure t
  :after esh-opt
  :defines eshell-highlight-prompt
  :autoload (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
  :init
  (setq eshell-highlight-prompt t)
  (setq eshell-prompt-function #'epe-theme-lambda))

(use-package eshell-syntax-highlighting
  :ensure t
  :after eshell
  :hook (elpaca-after-init . eshell-syntax-highlighting-global-mode))


(provide 'init-shell)
