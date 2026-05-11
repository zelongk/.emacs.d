;; -*- lexical-binding: t; -*-

(leaf comint
  :init
  (setq ansi-color-for-comint-mode t
        ansi-color-for-compilation-mode t))

(leaf ansi-color
  :hook (compilation-filter-hook . ansi-color-compilation-filter)) 


(leaf xterm-color
  :elpaca t
  :defvar (compilation-environment)
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

(leaf eat
  :bind (("C-`" . eat-toggle)
         ("C-<escape>" . eshell-toggle)
         ([remap project-shell] . eat-project))
  :hook ((eshell-load-hook . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :elpaca `(eat :repo "https://codeberg.org/akib/emacs-eat"
		        :files ("*.el" ("term" "term/*.el") "*.texi"
			            "*.ti" ("terminfo/e" "terminfo/e/*")
			            ("terminfo/65" "terminfo/65/*")
			            ("integration" "integration/*")
			            (:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-kill-buffer-on-exit . t)
  (eat-shell . "/opt/homebrew/bin/fish")
  (eat-tramp-shells . '(("docker" . "/bin/sh")
                        ("ssh" . "/bin/bash")
                        ("sshx" . "/bin/bash")
                        ("rpc" . "/bin/bash")))
  ;; Clear commands eshell considers visual by default.
  (eshell-visual-commands . '())
  (eat-minimum-latency . 0.002)
  (eat-enable-directory-tracking . t)
  (eat-enable-shell-prompt-annotation . t)
  
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
(leaf eshell  
  :defvar eshell-prompt-function
  :config
  (setq eshell-banner-message ""))

(leaf eshell-prompt-extras
  :elpaca t
  :after esh-opt
  :defvar eshell-highlight-prompt
  :leaf-autoload (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
  :init
  (setq eshell-highlight-prompt t)
  (setq eshell-prompt-function #'epe-theme-lambda))

(leaf eshell-syntax-highlighting
  :elpaca t
  :after eshell
  :hook (elpaca-after-init-hook . eshell-syntax-highlighting-global-mode))


(provide 'init-shell)
