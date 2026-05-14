;; init-ui ---  Almost everything about how emacs looks like -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      frame-resize-pixelwise t)

(setq frame-title-format "stop looking at me, time to work")

;;; FONTS
(leaf show-font
  :vc (:url "https://github.com/protesilaos/show-font"))

(leaf fontaine :ensure t
  :global-minor-mode fontaine-mode
  :setq
  `(fontaine-latest-state-file . ,(expand-file-name "fontaine-latest.eld" user-cache-directory))
  (fontaine-presets
   . '((small
        :default-family "Sarasa Term SC"
        :default-height 180
        :variable-pitch-family "Bookerly")
       (regular)
       (medium
        :default-weight semilight
        :default-height 235
        :bold-weight extrabold)
       (large
        :inherit medium
        :default-height 250)
       (presentation
        :default-height 280)
       (t
        :default-family "Sarasa Term SC"
        :default-weight regular
        :default-height 220
        
        :variable-pitch-family "Bookerly")))
  :config
  (fontaine-set-preset 'regular))

;; Use Symbols Nerd Font as fallback for private-use icons
(set-fontset-font t 'unicode (font-spec :family "Symbols Nerd Font Mono" :size 22 nil 'prepend))

(leaf mixed-pitch :ensure t
  :blackout t
  :hook (org-mode-hook LaTeX-mode-hook markdown-mode-hook))

;; Easily adjust the font size in all frames
(leaf default-text-scale :ensure t
  :blackout t
  :global-minor-mode default-text-scale-mode
  :bind
  (:default-text-scale-mode-map
   ("C-s-=" . default-text-scale-increase)
   ("C-s--" . default-text-scale-decrease)
   ("C-s-0" . default-text-scale-reset)))

;; UI settings
(leaf solaire-mode :ensure t
  :blackout t
  :global-minor-mode solaire-global-mode)

(leaf modus-themes :ensure t
  :custom
  (modus-themes-italic-constructs . t)
  (modus-themes-bold-constructs . t)
  (modus-themes-mixed-fonts . t)
  (modus-themes-prompts . '(bold background))
  (modus-themes-variable-pitch-ui . nil)
  :commands
  (modus-themes-load-random-dark
   modus-themes-load-random-light
   modus-themes-load-random)
  :config
  (setq modus-themes-headings
        '((0 . (1.50))
          (1 . (1.28))
          (2 . (1.22))
          (3 . (1.17))
          (4 . (1.14))
          (t . (1.1))))
  
  (setq modus-themes-common-palette-overrides
        '((bg-tab-bar bg-main)
          (bg-tab-current bg-hover)
          (bg-tab-other bg-main))))

(leaf doric-themes :ensure t
  :commands doric-themes-load-random)

(leaf ef-themes :ensure t
  :global-minor-mode
  ef-themes-take-over-modus-themes-mode
  :bind
  ("<f5>" . ef-themes-load-random)
  ("C-<f5>" . ef-themes-load-random-light)
  ("M-<f5>" . ef-themes-load-random-dark)
  :config
  (ef-themes-load-theme 'ef-dream))

(leaf auto-dark :ensure t
  :disabled t
  :when (and (eq system-type 'darwin) (display-graphic-p))
  :custom
  (auto-dark-allow-osascript . nil)
  :hook
  (auto-dark-dark-mode-hook
   . (lambda ()
       ;; something to execute when dark mode is detected
       (ef-themes-load-random-dark)
       ))
  (auto-dark-light-mode-hook
   . (lambda ()
       ;; something to execute when light mode is detected
       (ef-themes-load-random-light)
       ))
  :hook after-init-hook)

(leaf hide-mode-line :ensure t
  :leaf-autoload turn-off-hide-mode-line-mode
  :hook ((eat-mode-hook ghostel-mode-hook magit-mode-hook
                        eshell-mode-hook shell-mode-hook
                        term-mode-hook vterm-mode-hook
                        embark-collect-mode-hook lsp-ui-imenu-mode-hook
                        pdf-annot-list-mode-hook) . turn-on-hide-mode-line-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;              Interface              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(leaf centaur-tabs :ensure t
  :disabled t
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-icons t
        centaur-tabs-icon-type 'nerd-icons
        centaur-tabs-set-close-button nil
        centaur-tabs-show-new-tab-button nil
        centaur-tabs-set-modified-marker t))

(leaf spacious-padding :ensure t
  :global-minor-mode spacious-padding-mode
  :config
  (setq spacious-padding-subtle-frame-lines nil)
  (plist-put spacious-padding-widths :mode-line-width 6)
  (plist-put spacious-padding-widths :header-line-width 4))

(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(setq hscroll-step 1
      hscroll-margin 2
      scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount-horizontal 1
      mouse-wheel-progressive-speed nil)

(leaf nerd-icons
  :vc (:url "https://github.com/rainstormstudio/nerd-icons.el")
  :custom
  (nerd-icons-default-adjust . 0.05))

(with-no-warnings
  (when (featurep 'ns)
    ;; Render thinner fonts
    (setq ns-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq ns-pop-up-frames nil))
  (when (featurep 'mac)
    ;; Render thinner fonts
    (setq mac-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq mac-pop-up-frames nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;            Coding related           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(leaf rainbow-delimiters :ensure t
  :blackout t
  :hook ((prog-mode-hook typst-ts-mode-hook python-ts-mode-hook)
         . rainbow-delimiters-mode))

(leaf rainbow-mode :ensure t
  :blackout t
  :hook (text-mode-hook prog-mode-hook))

;; hl current line
(leaf hl-line
  :hook
  package-menu-mode-hook
  dired-mode-hook)

(leaf beacon :ensure t
  :disabled t
  :global-minor-mode beacon-mode)

(leaf pulsar :ensure t
  :bind
  ([remap count-lines-page] . pulsar-pulse-line) ; overrides `count-lines-page'
  ("C-x L" . pulsar-highlight-temporarily) ; or use `pulsar-highlight-temporarily-dwim'
  :global-minor-mode pulsar-global-mode
  :hook
  (next-error-hook . pulsar-pulse-line)
  (minibuffer-setup-hook . pulsar-pulse-line)
  :custom
  (pulsar-delay . 0.05)
  (pulsar-iterations . 5))

;; Eval result overlay
(leaf eros :ensure t
  :hook emacs-lisp-mode-hook lisp-interaction-mode-hook
  :bind (([remap eval-defun] . eros-eval-defun)
         ([remap eval-last-sexp] . eros-eval-last-sexp)))

(leaf goggles :ensure t
  :blackout t
  :hook (prog-mode-hook text-mode-hook conf-mode-hook))

(leaf hl-todo :ensure t
  :global-minor-mode global-hl-todo-mode
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(("FIXME" error bold)
          ("REVIEW" font-lock-keyword-face bold)
          ("HACK" font-lock-constant-face bold)
          ("DEPRECATED" font-lock-doc-face bold)
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(provide 'init-ui)
;;; init-ui.el ends here
