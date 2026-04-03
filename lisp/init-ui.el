;; -*- lexical-binding: t -*-

;; (setq idle-update-delay 1.0)

;; (setq-default line-height 0.16)
;; (setq-local default-text-properties '(line-spacing 0.1 line-height 1.1))

(use-package diminish)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

(setq frame-resize-pixelwise t)

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
  ;; :bind ("<f5>" . doric-themes-load-random)
  ;; :bind ("C-<f5>" . (lambda () (interactive) (doric-themes-load-random 'light)))
  ;; :bind ("M-<f5>" . (lambda () (interactive) (doric-themes-load-random 'dark)))
  :commands doric-themes-load-random)

(use-package ef-themes
  :bind ("<f5>" . modus-themes-load-random)
  :bind ("C-<f5>" . modus-themes-load-random-light)
  :bind ("M-<f5>" . modus-themes-load-random-dark)

  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1))

(use-package auto-dark
  :ensure t
  ;; :custom
  ;; (auto-dark-themes '((doric-beach) (leuven)))
  ;; (auto-dark-allow-osascript t)
  ;; (auto-dark-detection-method nil) ;; dangerous to be set manually
  :hook
  (auto-dark-dark-mode
   . (lambda ()
       ;; something to execute when dark mode is detected
       ;; (doric-themes-load-random 'dark))
       (modus-themes-load-random-dark)
       ))
  (auto-dark-light-mode
   . (lambda ()
       ;; something to execute when light mode is detected
       ;; (doric-themes-load-random 'light)
       (modus-themes-load-random-light)
       ))
  :hook elpaca-after-init)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (typst-ts-mode . rainbow-delimiters-mode)
         (python-ts-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :hook text-mode
  :hook prog-mode)

(use-package mood-line
  :hook emacs-startup)

;; (use-package doom-modeline
;;   :hook (elpaca-after-init . doom-modeline-mode)
;;   :config
;;   (setq doom-modeline-support-imenu t
;;         doom-modeline-height 30
;;         doom-modeline-buffer-file-name-style 'relative-from-project
;;         doom-modeline-enable-word-count t
;;         ;; doom-modeline-project-name t
;;         doom-modeline-check 'simple
;;         doom-modeline-buffer-encoding nil
;;         doom-modeline-major-mode-icon nil))

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

(pcase system-type
  ('darwin  ; macOS
   (set-face-attribute 'default nil :font "Sarasa Term SC-22")  ; 20 * 1.5
   (set-face-attribute 'variable-pitch nil :font "Bookerly-22" :weight 'light)
   (set-face-attribute 'fixed-pitch nil :font "Sarasa Term SC-22")

   (add-to-list 'default-frame-alist '(height . 53))
   (add-to-list 'default-frame-alist '(width . 90)))

  ('gnu/linux  ; Linux (including Debian)
   (set-face-attribute 'variable-pitch nil :font "Sarasa Mono TC Nerd Font-14")  ; 20 * 1.5
   (add-to-list 'default-frame-alist '(height . 40))
   (add-to-list 'default-frame-alist '(width . 90))))

(use-package mixed-pitch
  :diminish
  :hook org-mode
  :hook LaTeX-mode)

(use-package diff-hl
  :diminish
  :hook (elpaca-after-init global-diff-hl-mode)
  :hook (elpaca-after-init diff-hl-dired-mode)
  :hook (elpaca-after-init diff-hl-flydiff-mode))

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
  ;; :files (:defaults "data"))
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; Display transient in child frame
;; (use-package transient-posframe
;;   :diminish
;;   :commands transient-posframe-mode
;;   :custom-face
;;   (transient-posframe-border ((t (:inherit posframe-border :background unspecified))))
;;   :hook elpaca-after-init
;;   :init (setq transient-mode-line-format nil
;;               transient-posframe-parameters '((left-fringe . 8)
;;                                               (right-fringe . 8))))

(with-no-warnings
  (when (featurep 'ns)
    ;; Render thinner fonts
    (setq ns-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq ns-pop-up-frames nil)))

;; (use-package beacon
;;   :diminish
;;   :hook elpaca-after-init)

;; hl current line
(use-package hl-line
  :ensure nil
  :hook ((after-init . global-hl-line-mode)
         ((dashboard-mode eshell-mode shell-mode term-mode vterm-mode) .
          (lambda () (setq-local global-hl-line-mode nil)))))

;; Pulse highlight on selection
(use-package pulsar
  :custom-face
  (pulsar-generic ((t :inherit region :extend t)))
  :custom (pulsar-delay pulse-delay)
  :hook (emacs-startup . pulsar-global-mode))

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
