;; -*- lexical-binding: t; -*-

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
  (which-key-add-key-based-replacements "C-c n" "org-mode")
  (which-key-add-key-based-replacements "C-c l" "llm")
  (which-key-add-key-based-replacements "C-c s" "search")
  (which-key-add-key-based-replacements "C-c f" "find")
  (which-key-add-key-based-replacements "C-c p" "project")
  (which-key-add-key-based-replacements "C-c q" "quit")
  (which-key-add-key-based-replacements "C-c w" "windows"))

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

(use-package pdf-tools)

(provide 'init-utils)
