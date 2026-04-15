;; -*- lexical-binding: t -*-

(use-package diminish)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      frame-resize-pixelwise t)

;; 隐藏 title bar
(add-to-list 'default-frame-alist '(undecorated-round . t))

(use-package solaire-mode
  :hook (elpaca-after-init . solaire-global-mode))

(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t)
  :commands (modus-themes-load-random-dark
             modus-themes-load-random-light
             modus-themes-load-random))

(use-package doric-themes
  :disabled t
  ;; :bind ("<f5>" . doric-themes-load-random)
  ;; :bind ("C-<f5>" . (lambda () (interactive) (doric-themes-load-random 'light)))
  ;; :bind ("M-<f5>" . (lambda () (interactive) (doric-themes-load-random 'dark)))
  :commands doric-themes-load-random)

(use-package ef-themes
  :bind ("<f5>" . modus-themes-load-random)
  :bind ("C-<f5>" . modus-themes-load-random-light)
  :bind ("M-<f5>" . modus-themes-load-random-dark)
  :init
  (setq ef-themes-light-themes '(ef-arbutus ef-cyprus ef-day ef-duo-light ef-eagle ef-elea-light
                                            ef-kassio  ef-melissa-light ef-orange ef-reverie
                                            ef-spring ef-summer ef-trio-light ef-tritanopia-light))

  (setq ef-themes-dark-themes '(ef-autumn ef-bio ef-cherie ef-dark ef-deuteranopia-dark ef-dream
                                          ef-duo-dark ef-elea-dark ef-fig ef-maris-dark
                                          ef-melissa-dark ef-night ef-owl ef-rosa ef-symbiosis
                                          ef-trio-dark ef-tritanopia-dark ef-winter))
  (ef-themes-take-over-modus-themes-mode 1))

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
  :diminish
  :hook ((prog-mode . rainbow-delimiters-mode)
         (typst-ts-mode . rainbow-delimiters-mode)
         (python-ts-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook text-mode
  :hook prog-mode)

(use-package mood-line
  :disabled t
  :hook emacs-startup
  :custom (mood-line-glyph-alist mood-line-glyphs-fira-code))

(use-package doom-modeline
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
  :hook elpaca-after-init)

(use-package hide-mode-line
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
  :diminish
  :hook org-mode
  :hook LaTeX-mode)

;; Easily adjust the font size in all frames
(use-package default-text-scale
  :hook (elpaca-after-init . default-text-scale-mode)
  :bind (:map default-text-scale-mode-map
              ("C-s-=" . default-text-scale-increase)
              ("C-s--" . default-text-scale-decrease)
              ("C-s-0" . default-text-scale-reset)))

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
  :custom
  (nerd-icons-default-adjust 0.05))


(with-no-warnings
  (when (featurep 'ns)
    ;; Render thinner fonts
    (setq ns-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq ns-pop-up-frames nil)))

;; hl current line
(use-package hl-line
  :ensure nil
  :hook ((elpaca-after-init . global-hl-line-mode)
         ((dashboard-mode eshell-mode shell-mode term-mode vterm-mode eat-mode) .
          (lambda () (setq-local global-hl-line-mode nil)))))

(use-package beacon
  :disabled t
  :diminish
  :hook elpaca-after-init)

(use-package spacious-padding
  :diminish
  :hook elpaca-after-init)

;; Eval result overlay
(use-package eros
  :hook elpaca-after-init
  :bind (([remap eval-defun] . eros-eval-defun)
         ([remap eval-last-sexp] . eros-eval-last-sexp)))

(use-package goggles
  :diminish
  :hook (prog-mode text-mode conf-mode))

(provide 'init-ui)
