;; init-utils --- Utilities that makes life better -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf which-key
  :ensure t
  :commands childframe-completion-workable-p
  :bind ("C-h M-m" . which-key-show-major-mode)
  :global-minor-mode which-key-mode
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
  :ensure t
  
  :init (setq wgrep-auto-save-buffer t
              wgrep-change-readonly-file t))

;; Fast search tool `ripgrep'
(leaf rg
  :disabled t
  :ensure t
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
  :ensure t)

(leaf epa :require t
  :custom
  (epa-pinentry-mode . 'loopback)
  (epa-keys-select-method . 'minibuffer))

(leaf auth-source-pass
  :config
  (auth-source-pass-enable))

(leaf pass :ensure t)

;; Process
(leaf proced
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3
        proced-enable-color-flag t))

(provide 'init-utils)
;;; init-utils.el ends here
