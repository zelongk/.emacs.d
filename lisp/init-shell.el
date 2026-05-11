;; -*- lexical-binding: t; -*-

(leaf comint
  :init
  (setq ansi-color-for-comint-mode t
        ansi-color-for-compilation-mode t))

(leaf ansi-color
  :hook (compilation-filter-hook . ansi-color-compilation-filter)) 


(leaf xterm-color
  :ensure t
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

(leaf ghostel
  :ensure t
  :bind (("C-`" . ghostel-toggle))
  :hook (eshell-load-hook . ghostel-eshell-visual-command-mode)
  :custom
  (ghostel-shell . "/opt/homebrew/bin/fish")
  (ghostel-tramp-integration . t)
  (ghostel-tramp-default-method . 'tramp-default-method)
  :config
  (defun ghostel-toggle () (interactive)
         (if (string-match-p "ghostel" (buffer-name))
             (delete-window)
           (ghostel))))

;;; Eshell related
(leaf eshell  
  :defvar eshell-prompt-function
  :config
  (setq eshell-banner-message ""))

(leaf eshell-prompt-extras
  :ensure t
  :require t
  :after esh-opt
  :defvar eshell-highlight-prompt
  :leaf-autoload (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
  :init
  (setq eshell-highlight-prompt t)
  (setq eshell-prompt-function #'epe-theme-lambda))

(leaf eshell-syntax-highlighting
  :ensure t
  :after eshell
  :hook (after-init-hook . eshell-syntax-highlighting-global-mode))


(provide 'init-shell)
