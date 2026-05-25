;;; init-eglot.el --- Code for eglot setting -*- lexical-binding: t; -*-

;;; Commentary:
;; blablabla

;;; Code:

(leaf eglot
  :commands (eglot eglot-ensure)
  :hook
  (prog-mode-hook
   . (lambda ()
       (unless (derived-mode-p
                'dotenv-mode 'fish-mode
                'caddyfile-mode 'elvish-mode
                'emacs-lisp-mode 'lisp-mode
                'makefile-mode 'snippet-mode
                'lisp-data-mode 'ron-mode)
         (eglot-ensure))))
  ((markdown-mode-hook yaml-mode-hook yaml-ts-mode-hook
                       LaTeX-mode-hook typst-ts-mode-hook)
   . eglot-ensure)
  :defvar eglot-server-programs
  :bind (:eglot-mode-map
	     ("C-c c a" . eglot-code-actions))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format 'short)
        eglot-send-changes-idle-time 0.5
        eglot-code-action-indications '(eldoc-hint))

  (dolist (mode '(((typst-ts-mode) "tinymist")
                  ((LaTeX-mode) "texlab")))
    (add-to-list 'eglot-server-programs mode)))

(leaf eldoc-box :ensure t
  :blackout eldoc-box-hover-mode
  :hook
  ((eglot-managed-mode-hook prog-mode-hook)
   . eldoc-box-hover-mode))

;; (leaf eldoc-mouse :ensure t
;;   :hook
;;   eglot-managed-mode-hook
;;   prog-mode-hook)

(leaf consult-eglot :ensure t
  :after eglot consult
  :bind
  (:eglot-mode-map
   :package eglot
   ([remap xref-find-apropos] . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (leaf consult-eglot-embark :ensure t
    :after eglot consult
    :global-minor-mode consult-eglot-embark-mode))

(provide 'init-eglot)
;;; init-eglot.el ends here
