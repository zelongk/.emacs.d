;; -*- lexical-binding: t; -*-

(leaf which-key
  :elpaca t
  :commands childframe-completion-workable-p
  :bind ("C-h M-m" . which-key-show-major-mode)
  :hook (elpaca-after-init-hook . which-key-mode)
  :hook (god-mode-hook . which-key--god-mode-support-enabled)
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

;; Writable grep buffer
(leaf wgrep
  :elpaca t
  
  :init (setq wgrep-auto-save-buffer t
              wgrep-change-readonly-file t))

;; Fast search tool `ripgrep'
(leaf rg
  :disabled t
  :elpaca t
  :bind
  (("C-c s" . rg-menu))
  (:rg-global-map
   ("c" . rg-dwim-current-dir)
   ("f" . rg-dwim-current-file)
   ("m" . rg-menu))
  :init (setq rg-show-columns t)
  :config
  (add-to-list 'rg-custom-type-aliases '("tmpl" . "*.tmpl"))
  (rg-enable-default-bindings))

(leaf elcord
  :elpaca t)

(provide 'init-utils)
