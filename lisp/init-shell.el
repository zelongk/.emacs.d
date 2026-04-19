;; -*- lexical-binding: t; -*-

(use-package shell
  :hook ((shell-mode . my/shell-mode-hook)
         (comint-output-filter-functions . comint-strip-ctrl-m))
  :init
  (setq system-uses-terminfo nil)

  (with-no-warnings
    (defun my/shell-simple-send (proc command)
      "Various PROC COMMANDs pre-processing before sending to shell."
      (cond
       ;; Checking for clear command and execute it.
       ((string-match "^[ \t]*clear[ \t]*$" command)
        (comint-send-string proc "\n")
        (erase-buffer))
       ;; Checking for man command and execute it.
       ((string-match "^[ \t]*man[ \t]*" command)
        (comint-send-string proc "\n")
        (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
        (setq command (replace-regexp-in-string "[ \t]+$" "" command))
        ;;(message (format "command %s command" command))
        (funcall 'man command))
       ;; Send other commands to the default handler.
       (t (comint-simple-send proc command))))

    (defun my/shell-mode-hook ()
      "Shell mode customization."
      (local-set-key '[up] 'comint-previous-input)
      (local-set-key '[down] 'comint-next-input)
      (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)

      (ansi-color-for-comint-mode-on)
      (setq comint-input-sender 'my/shell-simple-send))))

;; Emacs command shell
(use-package eshell
  :defer
  :defines eshell-prompt-function
  :bind (:map eshell-mode-map
              ([remap recenter-top-bottom] . eshell/clear))
  :config
  (setq eshell-banner-message ""))

(use-package xterm-color
  :ensure t
  :defer t
  :defines (compilation-environment)
  :init
  (setenv "TERM" "xterm-256color")
  (setq compilation-environment '("TERM=xterm-256color")))

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
  (eat-term-name "xterm-256color")
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
