;; -*- lexical-binding: t; -*-

(use-package transient)

(use-package which-key
  :diminish
  :functions childframe-completion-workable-p
  :bind ("C-h M-m" . which-key-show-major-mode)
  :hook (elpaca-after-init . which-key-mode)
  :init (setq which-key-max-description-length 30
	            which-key-idle-delay 0.5
              which-key-lighter nil
              which-key-show-remaining-keys t)
  :config
  (which-key-add-key-based-replacements "C-c a" "LSP")
  (which-key-add-key-based-replacements "C-c b" "beframe")
  (which-key-add-key-based-replacements "C-c c" "code")
  (which-key-add-key-based-replacements "C-c n" "org")
  (which-key-add-key-based-replacements "C-c l" "llm")
  (which-key-add-key-based-replacements "C-c f" "find")
  (which-key-add-key-based-replacements "C-x p" "project")
  (which-key-add-key-based-replacements "C-c !" "flycheck")
  (which-key-add-key-based-replacements "C-c &" "yasnippet")
  (which-key-add-key-based-replacements "C-c q" "quit")
  (which-key-add-key-based-replacements "C-c C-w" "workspace")
  (which-key-add-key-based-replacements "C-c w" "windows")
  (which-key-add-key-based-replacements "C-x a" "abbrevs")
  (which-key-add-key-based-replacements "C-x b" "abbrevs")
  (which-key-add-key-based-replacements "C-x r" "rectangle/bookmarks")
  (which-key-add-key-based-replacements "C-x t" "tabs")
  (which-key-add-key-based-replacements "C-x v" "version control"))

(use-package grep
  :ensure nil
  :autoload grep-apply-setting
  :init
  (when (executable-find "rg")
    (grep-apply-setting
     'grep-command "rg --color=auto --null -nH --no-heading -e ")
    (grep-apply-setting
     'grep-template "rg --color=auto --null --no-heading -g '!*/' -e <R> <D>")
    (grep-apply-setting
     'grep-find-command '("rg --color=auto --null -nH --no-heading -e ''" . 38))
    (grep-apply-setting
     'grep-find-template "rg --color=auto --null -nH --no-heading -e <R> <D>")))

;; Writable grep buffer
(use-package wgrep
  :init (setq wgrep-auto-save-buffer t
              wgrep-change-readonly-file t))

;; Fast search tool `ripgrep'
(use-package rg
  ;; :hook (elpaca-after-init . rg-enable-default-bindings)
  :bind (:map rg-global-map
              ("c" . rg-dwim-current-dir)
              ("f" . rg-dwim-current-file)
              ("m" . rg-menu))
  :init (setq rg-show-columns t)
  :config
  (add-to-list 'rg-custom-type-aliases '("tmpl" . "*.tmpl"))
  (rg-enable-default-bindings)
  )

;; (use-package pdf-tools
;;   :config
;;   (pdf-tools-install))

;; (use-package saveplace-pdf-view
;;   :after pdf-tools
;;   :demand t)

;; (use-package keycast
;;   :hook (elpaca-after-init . keycast-mode-line-mode)
;;   :config
;;   (setq keycast-mode-line-remove-tail-elements nil))

(use-package elcord)

(provide 'init-utils)
