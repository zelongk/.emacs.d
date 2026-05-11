;; -*- lexical-binding: t -*-

(leaf blackout :ensure t)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      frame-resize-pixelwise t)

(setq frame-title-format "stop looking at me, time to work")

;;; FONTS
(leaf show-font
  :vc (:url "https://github.com/protesilaos/show-font"))

(defvar my/font-size 220)
(set-face-attribute 'default nil
                    :font "Sarasa Term SC"
                    :height my/font-size) ; 20 * 1.5
(set-face-attribute 'variable-pitch nil
                    :font "Bookerly"
                    :height (- my/font-size 20)
                    :weight 'light)
(set-face-attribute 'fixed-pitch nil
                    :font "Sarasa Term SC"
                    :height my/font-size)

;; Use Symbols Nerd Font as fallback for private-use icons
(set-fontset-font t 'unicode (font-spec :family "Symbols Nerd Font Mono" :size (/ my/font-size 10)) nil 'prepend)

(add-to-list 'default-frame-alist '(height . 53))
(add-to-list 'default-frame-alist '(width . 90))

(leaf mixed-pitch
  :ensure t
  :hook org-mode-hook
  :hook LaTeX-mode-hook)

;; Easily adjust the font size in all frames
(leaf default-text-scale
  :ensure t
  :hook (after-init-hook . default-text-scale-mode)
  :bind (:default-text-scale-mode-map
         ("C-s-=" . default-text-scale-increase)
         ("C-s--" . default-text-scale-decrease)
         ("C-s-0" . default-text-scale-reset)))

;; UI settings
(leaf solaire-mode
  :ensure t
  :hook (after-init-hook . solaire-global-mode))

(leaf modus-themes
  :ensure t
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-prompts '(bold background)
        modus-themes-variable-pitch-ui nil)
  :commands (modus-themes-load-random-dark
             modus-themes-load-random-light
             modus-themes-load-random))

(leaf doric-themes
  :ensure t
  :disabled t
  ;; :bind ("<f5>" . doric-themes-load-random)
  ;; :bind ("C-<f5>" . (lambda () (interactive) (doric-themes-load-random 'light)))
  ;; :bind ("M-<f5>" . (lambda () (interactive) (doric-themes-load-random 'dark)))
  :commands doric-themes-load-random)

(leaf ef-themes
  :ensure t
  
  :bind ("<f5>" . modus-themes-load-random)
  :bind ("C-<f5>" . modus-themes-load-random-light)
  :bind ("M-<f5>" . modus-themes-load-random-dark)
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  (setq ef-themes-headings
        '((0 . (1.50))
          (1 . (1.28))
          (2 . (1.22))
          (3 . (1.17))
          (4 . (1.14))
          (t . (1.1))))

  (defun my-set-faces (faces color)
    (dolist (face (if (listp faces) faces (list faces)))
      (custom-set-faces `(,face ((t :background ,color))))))
  (defun my-ef-themes-custom-faces ()
    (ef-themes-with-colors
      (my-set-faces '(org-block
                      org-block-begin-line
                      org-block-end-line)
                    bg-main)
      (my-set-faces 'olivetti-fringe bg-dim)))
  (add-hook 'ef-themes-after-load-theme-hook #'my-ef-themes-custom-faces)
  
  (setq ef-themes-common-palette-overrides
        '((bg-tab-bar bg-main)
          (bg-tab-current bg-hover)
          (bg-tab-other bg-main)
          (org-block bg-main)
          (date-common cyan)           ; default value (for timestamps and more)
          (date-deadline red-warmer)
          (date-event magenta-warmer)
          (date-holiday blue)           ; for M-x calendar
          (date-now yellow-warmer)
          (date-scheduled magenta-cooler)
          (date-weekday cyan-cooler)
          (date-weekend blue-faint)
          (mail-recipient fg-main)
          ;; (fg-heading-1 blue-warmer)
          ;; (fg-heading-2 yellow-cooler)
          ;; (fg-heading-3 cyan-cooler)
          ;; (fg-line-number-inactive "gray50")
          (fg-line-number-active fg-main)
          (bg-line-number-inactive unspecified)
          (bg-line-number-active unspecified)
          (bg-region bg-sage)
          (fg-region unspecified)
          ;; (comment yellow-cooler)
          ;; (string green-cooler)
          (fringe unspecified) ;; bg-blue-nuanced
          (border-mode-line-active unspecified)
          (border-mode-line-inactive unspecified)))
  (setq ef-themes-light-themes '(ef-arbutus ef-cyprus ef-day ef-duo-light ef-eagle ef-elea-light
                                            ef-kassio  ef-melissa-light ef-orange ef-reverie
                                            ef-spring ef-summer ef-trio-light ef-tritanopia-light))

  (setq ef-themes-dark-themes '(ef-autumn ef-bio ef-cherie ef-dark ef-deuteranopia-dark ef-dream
                                          ef-duo-dark ef-elea-dark ef-fig ef-maris-dark
                                          ef-melissa-dark ef-night ef-owl ef-rosa ef-symbiosis
                                          ef-trio-dark ef-tritanopia-dark ef-winter)))

(leaf auto-dark
  :when (and (eq system-type 'darwin) (display-graphic-p))
  :ensure t
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ; Modeline                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(leaf mood-line
  :disabled t
  :hook emacs-startup-hook
  :custom (mood-line-glyph-alist . mood-line-glyphs-fira-code))

(leaf doom-modeline
  :disabled t
  :ensure t
  :hook (after-init-hook . doom-modeline-mode)
  :config
  (setq doom-modeline-support-imenu t
        ;; doom-modeline-icons nil
        doom-modeline-height 30
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-enable-word-count t
        doom-modeline-project-name nil
        doom-modeline-check 'simple
        doom-modeline-minor-modes t
        doom-modeline-workspace-name nil
        doom-modeline-buffer-encoding nil
        doom-modeline-major-mode-icon nil))

;; Modeline

;; Why is this not working?
(setq-default mode-line-format
              '("%e" mode-line-front-space
                (:propertize
                 ("" mode-line-client mode-line-window-dedicated)
                 display (min-width (6.0)))
                mode-line-frame-identification mode-line-buffer-identification "   "
                mode-line-position (project-mode-line project-mode-line-format)
                " " (vc-mode vc-mode) "  " mode-line-modes mode-line-misc-info
                mode-line-end-spaces))
(defvar mode-line-cleaner-alist
  `((company-mode . " ⇝")
    (corfu-mode . " ⇝")
    (yas-minor-mode .  " ")
    (smartparens-mode . " ()")
    (evil-smartparens-mode . "")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (evil-snipe-local-mode . "")
    (evil-owl-mode . "")
    (evil-rsi-mode . "")
    (evil-commentary-mode . "")
    (ivy-mode . "")
    (counsel-mode . "")
    (wrap-region-mode . "")
    (rainbow-mode . "")
    (which-key-mode . "")
    (undo-tree-mode . "")
    ;; (undo-tree-mode . " ⎌")
    (auto-revert-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (hi-lock-mode . "")
    (python-mode . "Py")
    (haskell-mode . "Hs")
    (interactive-haskell-mode . "")
    (haskell-doc-mode . "")
    (haskell-collapse-mode . "")
    (emacs-lisp-mode . "Eλ")
    (nxhtml-mode . "nx")
    (dot-mode . "")
    (scheme-mode . " SCM")
    (matlab-mode . "M")
    (org-mode . " ORG" ;; "⦿"
              )
    (valign-mode . "")
    (eldoc-mode . "")
    (org-cdlatex-mode . "")
    (cdlatex-mode . "")
    (org-indent-mode . "")
    (org-roam-mode . "")
    (visual-line-mode . "")
    (latex-mode . "TeX")
    (outline-minor-mode . " ֍" ;; " [o]"
                        )
    (hs-minor-mode . "")
    (matlab-functions-have-end-minor-mode . "")
    (org-roam-ui-mode . " UI")
    (abridge-diff-mode . "")
    ;; Evil modes
    (evil-traces-mode . "")
    (latex-extra-mode . "")
    (anzu-mode . "")
    (goggles-mode . "")
    (subword-mode . "")
    (auto-dark-mode . "")
    (ace-pinyin-mode . "")
    (strokes-mode . "")
    (flymake-mode . " fly")
    (flycheck-mode . " Fly")
    (flyover-mode . "")
    (sideline-mode . "")
    (god-mode . ,(propertize "God" 'face 'success))
    (gcmh-mode . ""))
  "Alist for `clean-mode-line'.

  ; ;; When you add a new element to the alist, keep in mind that you
  ; ;; must pass the correct minor/major mode symbol and a string you
  ; ;; want to use in the modeline *in lieu of* the original.")

(defun clean-mode-line ()
  (cl-loop for cleaner in mode-line-cleaner-alist
           do (let* ((mode (car cleaner))
                     (mode-str (cdr cleaner))
                     (old-mode-str (cdr (assq mode minor-mode-alist))))
                (when old-mode-str
                  (setcar old-mode-str mode-str))
                ;; major mode
                (when (eq mode major-mode)
                  (setq mode-name mode-str)))))
(add-hook 'after-change-major-mode-hook #'clean-mode-line)
(add-hook 'emacs-startup-hook #'clean-mode-line)

(leaf hide-mode-line
  :ensure t
  :leaf-autoload turn-off-hide-mode-line-mode
  :hook ((eat-mode-hook ghostel-mode-hook
                        eshell-mode-hook shell-mode-hook
                        term-mode-hook vterm-mode-hook
                        embark-collect-mode-hook lsp-ui-imenu-mode-hook
                        pdf-annot-list-mode-hook) . turn-on-hide-mode-line-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;              Interface              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(leaf centaur-tabs
  :disabled t
  :ensure t
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-icons t
        centaur-tabs-icon-type 'nerd-icons
        centaur-tabs-set-close-button nil
        centaur-tabs-show-new-tab-button nil
        centaur-tabs-set-modified-marker t))

(leaf spacious-padding
  :ensure t
  :hook after-init-hook
  :config
  (setq spacious-padding-subtle-frame-lines nil)
  (plist-put spacious-padding-widths :mode-line-width 4)
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
    (setq mac-pop-up-frames nil))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;            Coding related           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(leaf rainbow-delimiters
  :ensure t
  :hook ((prog-mode-hook typst-ts-mode-hook python-ts-mode-hook)
         . rainbow-delimiters-mode))

(leaf rainbow-mode
  :ensure t
  :hook text-mode-hook
  :hook prog-mode-hook)

;; hl current line
(leaf hl-line
  :disabled t
  :hook ((after-init-hook . global-hl-line-mode)
         ((dashboard-mode-hook eshell-mode-hook shell-mode-hook term-mode-hook vterm-mode-hook eat-mode-hook) .
          (lambda () (setq-local global-hl-line-mode nil)))))

(leaf beacon
  :ensure t
  :disabled t
  :hook after-init-hook)

(leaf pulsar
  :ensure t
  :bind (([remap count-lines-page] . pulsar-pulse-line) ; overrides `count-lines-page'
         ("C-x L" . pulsar-highlight-permanently-dwim)) ; or use `pulsar-highlight-temporarily-dwim'
  :hook (after-init-hook . pulsar-global-mode)
  :custom-face (pulsar-generic . '((t :inherit region :extend t)))
  :custom
  (pulsar-delay . 0.05)
  (pulsar-iterations . 5)
  (pulsar-face . 'pulsar-green)
  (pulsar-region-face . 'pulsar-yellow)
  (pulsar-highlight-face . 'pulsar-magenta)
  :config
  (add-hook 'next-error-hook #'pulsar-pulse-line)
  (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line))

;; Eval result overlay
(leaf eros
  :ensure t
  :hook emacs-lisp-mode-hook lisp-interaction-mode-hook
  :bind (([remap eval-defun] . eros-eval-defun)
         ([remap eval-last-sexp] . eros-eval-last-sexp)))

(leaf goggles
  :ensure t
  :hook (prog-mode-hook text-mode-hook conf-mode-hook))

(leaf hl-todo
  :ensure t
  :hook (after-init-hook . global-hl-todo-mode)
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
