;; -*- lexical-binding: t -*-

(use-package diminish :ensure t)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      frame-resize-pixelwise t)

;; 隐藏 title bar
(add-to-list 'default-frame-alist '(undecorated-round . t))


;;; FONTS
(use-package show-font
  :ensure (:host github :repo "protesilaos/show-font")
  :defer)

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

(use-package mixed-pitch
  :ensure t
  :diminish
  :hook org-mode
  :hook LaTeX-mode)

;; Easily adjust the font size in all frames
(use-package default-text-scale
  :ensure t
  :hook (elpaca-after-init . default-text-scale-mode)
  :bind (:map default-text-scale-mode-map
              ("C-s-=" . default-text-scale-increase)
              ("C-s--" . default-text-scale-decrease)
              ("C-s-0" . default-text-scale-reset)))

;; UI settings
(use-package solaire-mode
  :ensure t
  :hook (elpaca-after-init . solaire-global-mode))

(use-package modus-themes
  :ensure t
  :defer
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-prompts '(bold background)
        modus-themes-variable-pitch-ui nil)
  :commands (modus-themes-load-random-dark
             modus-themes-load-random-light
             modus-themes-load-random))

(use-package doric-themes
  :ensure t
  :disabled t
  ;; :bind ("<f5>" . doric-themes-load-random)
  ;; :bind ("C-<f5>" . (lambda () (interactive) (doric-themes-load-random 'light)))
  ;; :bind ("M-<f5>" . (lambda () (interactive) (doric-themes-load-random 'dark)))
  :commands doric-themes-load-random)

(use-package ef-themes
  :ensure t
  :defer
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

  (setq ef-themes-light-themes '(ef-arbutus ef-cyprus ef-day ef-duo-light ef-eagle ef-elea-light
                                            ef-kassio  ef-melissa-light ef-orange ef-reverie
                                            ef-spring ef-summer ef-trio-light ef-tritanopia-light))

  (setq ef-themes-dark-themes '(ef-autumn ef-bio ef-cherie ef-dark ef-deuteranopia-dark ef-dream
                                          ef-duo-dark ef-elea-dark ef-fig ef-maris-dark
                                          ef-melissa-dark ef-night ef-owl ef-rosa ef-symbiosis
                                          ef-trio-dark ef-tritanopia-dark ef-winter)))

(use-package auto-dark
  :when (and (eq system-type 'darwin) (display-graphic-p))
  :diminish
  :ensure t
  :hook
  (auto-dark-dark-mode
   . (lambda ()
       ;; something to execute when dark mode is detected
       (ef-themes-load-random-dark)
       ))
  (auto-dark-light-mode
   . (lambda ()
       ;; something to execute when light mode is detected
       (ef-themes-load-random-light)
       ))
  :hook elpaca-after-init)


(use-package rainbow-delimiters
  :ensure t
  :diminish
  :hook ((prog-mode . rainbow-delimiters-mode)
         (typst-ts-mode . rainbow-delimiters-mode)
         (python-ts-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :ensure t
  :diminish
  :hook text-mode
  :hook prog-mode)

(use-package mood-line
  :disabled t
  :hook emacs-startup
  :custom (mood-line-glyph-alist mood-line-glyphs-fira-code))

(use-package doom-modeline
  :ensure t
  :hook (elpaca-after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-support-imenu t
        ;; doom-modeline-icons nil
        doom-modeline-height 30
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-enable-word-count t
        ;; doom-modeline-project-name t
        doom-modeline-check 'simple
        doom-modeline-minor-modes t
        doom-modeline-buffer-encoding nil
        doom-modeline-major-mode-icon nil))

(use-package minions
  :ensure t
  :hook elpaca-after-init)

(use-package hide-mode-line
  :ensure t
  :autoload turn-off-hide-mode-line-mode
  :hook (((eat-mode
           eshell-mode shell-mode
           term-mode vterm-mode
           embark-collect-mode lsp-ui-imenu-mode
           pdf-annot-list-mode) . turn-on-hide-mode-line-mode)))

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

(use-package nerd-icons
  :ensure (nerd-icons
           :type git
           :host github
           :repo "rainstormstudio/nerd-icons.el")
  :defer
  :custom
  (nerd-icons-default-adjust 0.05))


(with-no-warnings
  (when (featurep 'ns)
    ;; Render thinner fonts
    (setq ns-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq ns-pop-up-frames nil)))

;; hl current line
;; (use-package hl-line
;;   :hook ((elpaca-after-init . global-hl-line-mode)
;;          ((dashboard-mode eshell-mode shell-mode term-mode vterm-mode eat-mode) .
;;           (lambda () (setq-local global-hl-line-mode nil)))))

(use-package beacon
  :ensure t
  :disabled t
  :diminish
  :hook elpaca-after-init)

(use-package pulsar
  :ensure t
  :bind (([remap count-lines-page] . pulsar-pulse-line) ; overrides `count-lines-page'
         ("C-x L" . pulsar-highlight-permanently-dwim)) ; or use `pulsar-highlight-temporarily-dwim'
  :hook (elpaca-after-init . pulsar-global-mode)
  :custom-face (pulsar-generic ((t :inherit region :extend t)))
  :custom
  (pulsar-delay pulse-delay)
  (pulsar-iterations 5)
  (pulsar-face 'pulsar-green)
  (pulsar-region-face 'pulsar-yellow)
  (pulsar-highlight-face 'pulsar-magenta)
  :config
  (add-hook 'next-error-hook #'pulsar-pulse-line)
  (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line))

(use-package spacious-padding
  :ensure t
  :diminish
  :hook elpaca-after-init)

;; Eval result overlay
(use-package eros
  :ensure t
  :defer
  :hook emacs-lisp-mode lisp-interaction-mode
  :bind (([remap eval-defun] . eros-eval-defun)
         ([remap eval-last-sexp] . eros-eval-last-sexp)))

(use-package goggles
  :ensure t
  :defer
  :diminish
  :hook (prog-mode text-mode conf-mode))

(use-package hl-todo
  :ensure t
  :hook (elpaca-after-init . global-hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(provide 'init-ui)
