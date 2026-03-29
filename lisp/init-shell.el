;; -*- lexical-binding: t; -*-

(use-package shell
  :ensure nil
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

(use-package xterm-color
  :defines (compilation-environment
            eshell-preoutput-filter-functions
            eshell-output-filter-functions)
  :init
  ;; For shell and interpreters
  (setenv "TERM" "xterm-256color")

  (with-eval-after-load 'esh-mode
    (add-hook 'eshell-before-prompt-hook
              (lambda ()
                (setq xterm-color-preserve-properties t)))
    (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
    (setq eshell-output-filter-functions
          (remove 'eshell-handle-ansi-color eshell-output-filter-functions)))
  (setq compilation-environment '("TERM=xterm-256color"))
  )

(setq eshell-banner-message "")

(use-package eat
  :bind ("C-`" . eshell-toggle)
  :bind ("C-<escape>" . eat-toggle)
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :straight `(eat :repo "https://codeberg.org/akib/emacs-eat"
		              :files ("*.el" ("term" "term/*.el") "*.texi"
			                    "*.ti" ("terminfo/e" "terminfo/e/*")
			                    ("terminfo/65" "terminfo/65/*")
			                    ("integration" "integration/*")
			                    (:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-term-name "xterm-256color")
  (eat-kill-buffer-on-exit t)
  ;; (eat-shell )
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

;; (use-package eshell-z
;;   :hook (eshell-mode . (lambda () (require 'eshell-z))))

;; (use-package esh-help
;;   :commands setup-esh-help-eldoc
;;   :init (setup-esh-help-eldoc))

(use-package eshell-syntax-highlighting
  :after eshell-mode
  :hook (after-init . eshell-syntax-highlighting-global-mode))


(provide 'init-shell)
