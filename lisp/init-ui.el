;; -*- lexical-binding: t -*-

;; (setq idle-update-delay 1.0)

;; (setq-default line-height 0.16)
;; (setq-local default-text-properties '(line-spacing 0.1 line-height 1.1))
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; 隐藏 title bar
(setq default-frame-alist '((undecorated-round . t)))

(use-package solaire-mode
  :hook (elpaca-after-init . solaire-global-mode))

;; (use-package standard-themes :demand t)
(use-package ef-themes :demand t)
(use-package doric-themes
  :demand t
  :bind ("<f5>" . doric-load-random)
  :init
  (mapc #'disable-theme custom-enabled-themes)
  (defun doric-load-random ()
    (interactive)
    (let* ((themes '(doric-plum
                     doric-fire
                     doric-oak
                     doric-jade
                     doric-wind
                     doric-beach
                     doric-earth
                     doric-water
                     doric-valley))
           (loaded (seq-random-elt themes)))
      (load-theme loaded :no-confirm)))
  (doric-load-random)
  )

;; (use-package doom-themes
;;   :demand t
;;   :init
;;   (setq doom-themes-enable-bold t)
;;   (setq doom-themes-enable-italic t))


;; (require 'modus-summer-time)
(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t)
  (setq modus-themes-headings ; read the manual's entry or the doc string
        '((0 . (regular 1))
          (1 . (regular 1))
          (2 . (regular 1))
          (3 . (regular 1))
          (4 . (regular 1))
          (5 . (regular 1)) ; absence of weight means `bold'
          (6 . (regular 1))
          (7 . (regular 1))
          (t . (regular 1)))))

(use-package rainbow-delimiters
    :hook ((prog-mode . rainbow-delimiters-mode)
           (typst-ts-mode . rainbow-delimiters-mode)
           (foo-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :hook elpaca-after-init)

;; (use-package doom-modeline
;;   :hook (elpaca-after-ninit . doom-modeline-mode)
;;   :config
;;   (setq doom-modeline-support-imenu t
;;         doom-modeline-height 30
;;         doom-modeline-bar-width 8))
;; (use-package minions
;;   :hook elpaca-after-init)

(use-package hide-mode-line
  :autoload turn-off-hide-mode-line-mode
  :hook (((eat-mode
           eshell-mode shell-mode
           term-mode vterm-mode
           embark-collect-mode lsp-ui-imenu-mode
           pdf-annot-list-mode) . turn-on-hide-mode-line-mode)))

;; Suppress GUI features
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-scratch-message nil)

(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(pcase system-type
  ('darwin  ; macOS
   (set-face-attribute 'default nil :font "Sarasa Term SC-20")  ; 20 * 1.5
   (set-face-attribute 'variable-pitch nil :font "Bookerly-20" :weight 'light)
   (set-face-attribute 'fixed-pitch nil :font "Sarasa Term SC-20")
   
   (add-to-list 'default-frame-alist '(height . 53))
   (add-to-list 'default-frame-alist '(width . 120)))
  
  ('gnu/linux  ; Linux (including Debian)
   (set-face-attribute 'variable-pitch nil :font "Sarasa Term SC-14")  ; 20 * 1.5
   (add-to-list 'default-frame-alist '(height . 40))
   (add-to-list 'default-frame-alist '(width . 90))))

;; (use-package mixed-pitch
;;   :hook org-mode)

(use-package diff-hl
  :init (global-diff-hl-mode))

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
           :repo "rainstormstudio/nerd-icons.el"
           :files (:defaults "data"))
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))

(use-package beacon
  :diminish
  :hook elpaca-after-init)

(use-package spacious-padding)

(provide 'init-ui)
