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

;; Writable grep buffer
(use-package wgrep
  :init (setq wgrep-auto-save-buffer t
              wgrep-change-readonly-file t))

;; Fast search tool `ripgrep'
(use-package rg
  :bind ("C-c s" . rg-menu)
  :bind (:map rg-global-map
              ("c" . rg-dwim-current-dir)
              ("f" . rg-dwim-current-file)
              ("m" . rg-menu))
  :init (setq rg-show-columns t)
  :config
  (add-to-list 'rg-custom-type-aliases '("tmpl" . "*.tmpl"))
  (rg-enable-default-bindings)
  )


(use-package elcord)

;; (when (display-graphic-p)
;;   (use-package pdf-view
;;     :ensure pdf-tools
;;     :diminish (pdf-view-themed-minor-mode
;;                pdf-view-midnight-minor-mode
;;                pdf-view-roll-minor-mode
;;                pdf-view-printer-minor-mode)
;;     :functions pdf-tools-install
;;     :hook ((pdf-tools-enabled . pdf-view-auto-slice-minor-mode)
;;            (pdf-tools-enabled . pdf-view-roll-minor-mode)
;;            (pdf-tools-enabled . pdf-isearch-minor-mode))
;;     ;; :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
;;     :magic ("%PDF" . pdf-view-mode)
;;     :bind (:map pdf-view-mode-map
;;                 ("C-s" . isearch-forward))
;;     ;; :init (setq pdf-view-use-scaling t
;;     ;;             pdf-view-use-imagemagick nil)
;;     :config
;;     ;; Activate the package
;;     (pdf-tools-install t nil t nil))
;;   ;; Recover last viewed position
;;   (use-package saveplace-pdf-view
;;     :when (ignore-errors (pdf-info-check-epdfinfo) t)
;;     :autoload (saveplace-pdf-view-find-file-advice saveplace-pdf-view-to-alist-advice)
;;     :functions pdf-info-check-epdfinfo
;;     :init
;;     (advice-add 'save-place-find-file-hook :around #'saveplace-pdf-view-find-file-advice)
;;     (advice-add 'save-place-to-alist :around #'saveplace-pdf-view-to-alist-advice)))


(provide 'init-utils)
