;; -*- lexical-binding: t; -*-
(unless (or (daemonp) noninteractive init-file-debug)
;; Temporarily suppress file-handler processing to speed up startup
(let ((default-handlers file-name-handler-alist))
  (setq file-name-handler-alist nil)
  ;; Recover handlers after startup
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq file-name-handler-alist
                    (delete-dups (append file-name-handler-alist default-handlers))))
            101)))

(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

(defun byte-compile-elpa ()
  "Compile packages in elpa directory.  Useful if you switch Emacs versions."
  (interactive)
  (if (fboundp 'async-byte-recompile-directory)
      (async-byte-recompile-directory package-user-dir)
    (byte-recompile-directory package-user-dir 0 t)))

(defun byte-compile-site-lisp ()
  "Compile packages in site-lisp directory."
  (interactive)
  (let ((dir (locate-user-emacs-file "site-lisp")))
    (if (fboundp 'async-byte-recompile-directory)
        (async-byte-recompile-directory dir)
      (byte-recompile-directory dir 0 t))))

(defun native-compile-elpa ()
  "Native-compile packages in elpa directory."
  (interactive)
  (if (fboundp 'native-compile-async)
      (native-compile-async package-user-dir t)))

(defun native-compile-site-lisp ()
  "Native compile packages in site-lisp directory."
  (interactive)
  (let ((dir (locate-user-emacs-file "site-lisp")))
    (if (fboundp 'native-compile-async)
        (native-compile-async dir t))))

(eval-and-compile
  (setq custom-file (make-temp-file "emacs-custom-"))
  (defvar user-cache-directory (expand-file-name ".cache/" user-emacs-directory)))

(eval-and-compile
  (with-no-warnings
    (with-no-warnings
      (setq straight-vc-git-default-clone-depth     1
	    straight-repository-branch              "develop"
	    straight-enable-use-package-integration nil
	    straight-check-for-modifications        nil
	    straight-disable-native-compile         t)))
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name
          "straight/repos/straight.el/bootstrap.el"
          (or (bound-and-true-p straight-base-dir)
              user-emacs-directory)))
        (bootstrap-version 7))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  (straight-use-package 'leaf)
  (straight-use-package 'leaf-keywords)
  (require 'leaf)
  (require 'leaf-keywords)
  (leaf-keywords-init)
  (setq leaf-expand-minimally t
        leaf-enable-imenu-support t
        leaf-alias-keyword-alist '((:ensure . :straight)))

  (leaf blackout :ensure t))

(leaf gcmh :ensure t
  :blackout t
  :global-minor-mode gcmh-mode
  :config
  (defun gcmh-register-idle-gc ()
    "Register a timer to run `gcmh-idle-garbage-collect'.
Cancel the previous one if present."
    (unless (eq this-command 'self-insert-command)
      (let ((idle-t (if (eq gcmh-idle-delay 'auto)
                        (* gcmh-auto-idle-delay-factor gcmh-last-gc-time)
                      gcmh-idle-delay)))
        (if (timerp gcmh-idle-timer)
            (timer-set-time gcmh-idle-timer idle-t)
          (setf gcmh-idle-timer
                (run-with-timer idle-t nil #'gcmh-idle-garbage-collect))))))
  (setq gcmh-idle-delay 'auto       ; default is 15s
        gcmh-high-cons-threshold (* 32 1024 1024)
        gcmh-verbose nil
        gc-cons-percentage 0.2))

(leaf benchmark-init :ensure t
  :disabled t
  :require t
  :hook (after-init-hook . benchmark-init/deactivate))

(leaf org-auto-tangle :ensure t
  :blackout t
  :hook org-mode-hook)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      frame-resize-pixelwise t)

(setq frame-title-format "stop looking at me, time to work")

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

(add-to-list 'default-frame-alist '(width . 110))
(add-to-list 'default-frame-alist '(height . 30))

(setq-default fringes-outside-margins t)

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

(leaf show-font
  :ensure (show-font :host github :repo "protesilaos/show-font"))

(leaf fontaine :ensure t
  :when (display-graphic-p)
  :global-minor-mode fontaine-mode
  :setq
  `(fontaine-latest-state-file . ,(expand-file-name "fontaine-latest.eld" user-cache-directory))
  (fontaine-presets
   . '((small
        :default-height 180)
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
        :default-height 200
        
        :variable-pitch-family "Source Sans 3")))
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

(leaf solaire-mode :ensure t
  :blackout t
  :global-minor-mode solaire-global-mode)

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

(leaf rainbow-delimiters :ensure t
  :blackout t
  :hook ((prog-mode-hook typst-ts-mode-hook python-ts-mode-hook)
         . rainbow-delimiters-mode))

(leaf rainbow-mode :ensure t
  :blackout t
  :hook (text-mode-hook prog-mode-hook))

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

(defvar my-modeline-vc-map
  (let ((map (make-sparse-keymap)))
    ;; Left click shows diff for the current file
    (define-key map [mode-line down-mouse-1] #'vc-diff)
    ;; Right click shows diff for the entire project/repo
    (define-key map [mode-line down-mouse-3] #'vc-root-diff)
    map)
  "Keymap for the VC branch mode-line indicator.")
(defun my-modeline-vc-face (file backend)
  "Return an appropriate face based on the exact VC state of FILE."
  (let ((state (vc-state file backend)))
    (pcase state
      ('up-to-date 'vc-up-to-date-state)
      ('edited     'vc-edited-state)
      ('added      'vc-locally-added-state)
      ('conflict   'vc-conflict-state)
      ('removed    'vc-removed-state)
      ('missing    'vc-missing-state)
      ('locked     'vc-locked-state)
      (_           'shadow))))

(defun my-modeline-vc-branch-name (file backend)
  "Return the VC branch name or short hash for FILE with BACKEND."
  (when-let* ((rev (vc-working-revision file backend)))
    (if (eq backend 'Git)
        ;; For Git, try to get the actual branch name, fallback to short hash
        (or (vc-git--symbolic-ref file)
            (substring rev 0 7))
      ;; For other backends (SVN, Hg, etc.), just use the revision number
      rev)))
(defun my-modeline-vc-string ()
  "Generate the string for the VC mode-line indicator."
  (when-let* (((mode-line-window-selected-p))
              ;; Works for both file buffers and Dired buffers
              (file (or buffer-file-name default-directory))
              (backend (vc-backend file))
              (branch (my-modeline-vc-branch-name file backend))
              (face (my-modeline-vc-face file backend)))
    (propertize (format " ⎇ %s " branch) ; Customize the symbol (e.g., Nerd Font )
                'face face
                'mouse-face 'mode-line-highlight
                'help-echo (format "Revision: %s\nmouse-1: `vc-diff'\nmouse-3: `vc-root-diff'"
                                   (vc-working-revision file backend))
                'local-map my-modeline-vc-map)))

(defvar-local my-modeline-vc-branch
  '(:eval (my-modeline-vc-string)))

(defvar my-modeline-flymake-map
  (let ((map (make-sparse-keymap)))
    ;; Left click shows diagnostics for the current buffer
    (define-key map [mode-line down-mouse-1] #'flymake-show-buffer-diagnostics)
    ;; Right click shows project-wide diagnostics
    (define-key map [mode-line down-mouse-3] #'flymake-show-project-diagnostics)
    map)
  "Keymap for the Flymake mode-line indicator.")
;; 2. Helper function to count diagnostics by severity
(defun my-modeline-flymake-count (type)
  "Count flymake diagnostics of a specific TYPE (:error, :warning, :note)."
  (let ((count 0))
    (dolist (d (flymake-diagnostics))
      (when (= (flymake--severity type)
               (flymake--severity (flymake-diagnostic-type d)))
        (cl-incf count)))
    count))
;; 3. Function to generate the propertized string
(defun my-modeline-flymake-string ()
  "Generate the string for the Flymake mode-line indicator."
  ;; Only render if Flymake is active AND the current window is focused
  (when (and (bound-and-true-p flymake-mode)
             (mode-line-window-selected-p))
    (let ((err (my-modeline-flymake-count :error))
          (warn (my-modeline-flymake-count :warning))
          (note (my-modeline-flymake-count :note))
          (segments nil))
      ;; Build the Note string
      (when (> note 0)
        (push (propertize (format " [I] %d " note)
                          'face 'success
                          'help-echo "Notes\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                          'local-map my-modeline-flymake-map
                          'mouse-face 'mode-line-highlight)
              segments))
      ;; Build the Warning string
      (when (> warn 0)
        (push (propertize (format " [P] %d " warn)
                          'face 'warning
                          'help-echo "Warnings\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                          'local-map my-modeline-flymake-map
                          'mouse-face 'mode-line-highlight)
              segments))
      ;; Build the Error string
      (when (> err 0)
        (push (propertize (format " [C] %d " err)
                          'face 'error
                          'help-echo "Errors\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                          'local-map my-modeline-flymake-map
                          'mouse-face 'mode-line-highlight)
              segments))
      
      ;; Combine them and return. (Using nreverse because `push` prepends items)
      (if segments
          (apply #'concat (nreverse segments))
        ""))))
;; 4. Define the mode-line variable
(defvar-local my-modeline-flymake
  '(:eval (my-modeline-flymake-string))
  "Mode line construct displaying Flymake diagnostic counts.")

(with-eval-after-load 'eglot
  (setq mode-line-misc-info
        (delete '(eglot--managed-mode (" [" eglot--mode-line-format "] ")) mode-line-misc-info)))

(defvar-local prot-modeline-eglot
  `(:eval
    (when (and (featurep 'eglot) (mode-line-window-selected-p))
      '(eglot--managed-mode eglot--mode-line-format)))
  "Mode line construct displaying Eglot information.
Specific to the current window's mode line.")

(dolist (construct '(my-modeline-vc-branch
                     my-modeline-flymake
                     prot-modeline-eglot))
  (put construct 'risky-local-variable t))

(defvar mode-line-cleaner-alist
  `((company-mode . " ⇝")
    (corfu-mode . " ⇝")
    (smartparens-mode . " ()")
    (vundo-mode . " ⎌")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (python-mode . "Py")
    (haskell-mode . "Hs")
    (emacs-lisp-mode . "Eλ")
    (nxhtml-mode . "nx")
    (scheme-mode . " SCM")
    (matlab-mode . "M")
    (tuareg-mode . "Oc")
    (org-mode . "⦿") ;; "⦿"
    (latex-mode . "TeX")
    (outline-minor-mode . " ֍") ;; " [o]"
    (hs-minor-mode . "")
    (matlab-functions-have-end-minor-mode . "")
    (org-roam-ui-mode . " UI")
    (god-mode . ,(propertize "God" 'face 'success)))
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

(setq-default mode-line-format
              '("%e" mode-line-front-space
                (:propertize
                 ("" mode-line-client mode-line-window-dedicated)
                 display (min-width (6.0)))
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                "  "
                mode-line-modes

                mode-line-format-right-align
                
                
                prot-modeline-eglot
                mode-line-misc-info
                my-modeline-flymake
                "   "
                my-modeline-vc-branch
                mode-line-end-spaces))
(blackout 'visual-line-mode)

(leaf hide-mode-line :ensure t
  :commands turn-off-hide-mode-line-mode
  :hook ((eat-mode-hook ghostel-mode-hook magit-mode-hook
                        eshell-mode-hook shell-mode-hook
                        term-mode-hook vterm-mode-hook
                        embark-collect-mode-hook lsp-ui-imenu-mode-hook
                        pdf-annot-list-mode-hook) . turn-on-hide-mode-line-mode))

(leaf spacious-padding :ensure t
  :global-minor-mode spacious-padding-mode
  :config
  (setq spacious-padding-subtle-frame-lines nil)
  (plist-put spacious-padding-widths :mode-line-width 6)
  (plist-put spacious-padding-widths :header-line-width 4))

(leaf saveplace
  :require t
  :global-minor-mode save-place-mode
  :config
  (setq save-place-file (expand-file-name "places" user-cache-directory)))

(leaf display-line-numbers
  :hook
  prog-mode-hook
  :config
  (dolist (mode '(erc-mode-hook
                  circe-mode-hook
                  help-mode-hook
                  gud-mode-hook
		          treemacs-mode-hook
                  ghostel-mode-hook
                  org-mode-hook
                  vterm-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode -1))))
  (setq display-line-numbers-type 'relative)
  (setq display-line-numbers-width-start 4))

(leaf subword
  :blackout t
  :hook (prog-mode-hook minibuffer-setup-hook))

(leaf paren
  :global-minor-mode show-paren-mode)

(leaf recentf
  :global-minor-mode recentf-mode
  :init
  (setq recentf-max-saved-items 500
        recentf-exclude
        '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
          "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
          "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
          "^/tmp/" "^/var/folders/.+$" "^/ssh:" "^/rpc:" "/persp-confs/"
          "^/sshx:" "^/sudo:"
          (lambda (file) (file-in-directory-p file package-user-dir)))
        recentf-auto-cleanup 'never)
  (setq recentf-save-file (expand-file-name "recentf" user-cache-directory))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

(leaf savehist
  :global-minor-mode savehist-mode
  :init
  (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
        history-length 1000
        savehist-file (expand-file-name "history" user-cache-directory)
        savehist-additional-variables '(mark-ring
                                        global-mark-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history)
        savehist-autosave-interval 300))

(leaf emacs
  :custom
  (duplicate-line-final-position . 1)
  :setq-default
  (truncate-lines . t)
  :init
  (setq-default cursor-type 'bar)
  (setq kill-whole-line t
        make-backup-files nil
        use-short-answers t
        confirm-kill-processes nil)

  ;; Unless you need RTL
  (setq-default bidi-display-reordering nil)
  (setq bidi-inhibit-bpa t
        long-line-threshold 1000
        large-hscroll-threshold 1000
        syntax-wholeline-max 1000
        backward-delete-char-untabify-method 'all)

  (if IS-MAC
      (setq mac-command-modifier 'super
            mac-option-modifier 'meta
            mac-pass-control-to-system nil))
  
  (add-to-list 'default-frame-alist '(drag-internal-border . 1))
  (add-to-list 'default-frame-alist '(internal-border-width . 5))

  (pcase system-type ('darwin (setq insert-directory-program "gls")))

  (defvar my/tab-size 4)
  (setq-default tab-width my/tab-size
                standard-indent my/tab-size
                c-basic-offset my/tab-size
                compilation-scroll-output t
	            indent-tabs-mode nil)

  (setq ring-bell-function 'ignore)
  (setq undo-limit 80000000
        password-cache-expiry nil)

  (setq-default delete-by-moving-to-trash t
	            x-stretch-cursor t
	            window-combination-resize t)

  (setq kill-ring-max 200)
  ;; Save clipboard contents into kill-ring before replace them
  (setq save-interprogram-paste-before-kill t)

  ;; Kill & Mark things easily
  (leaf easy-kill
    :ensure t
    :bind (([remap kill-ring-save] . easy-kill)
           ([remap mark-sexp] . easy-mark))))

(leaf ultra-scroll :ensure t
  :init
  (setq scroll-conservatively 3
	    scroll-margin 0)
  :global-minor-mode ultra-scroll-mode)

(leaf helpful :ensure t
  :bind
  (([remap describe-function] . helpful-callable)
   ([remap describe-command]  . helpful-command)
   ([remap describe-variable] . helpful-variable)
   ([remap describe-key]      . helpful-key)
   ([remap describe-symbol]   . helpful-symbol))
  (:emacs-lisp-mode-map
   ("C-c C-d"                 . helpful-at-point))
  (:lisp-interaction-mode-map
   ("C-c C-d"                 . helpful-at-point))
  (:helpful-mode-map
   ("r"                       . remove-hook-at-point)
   ("q"                       . kill-current-buffer))
  :hook (helpful-mode-hook . cursor-sensor-mode) ; for remove-advice button
  :init
  (with-no-warnings
    (with-eval-after-load 'apropos
      ;; patch apropos buttons to call helpful instead of help
      (dolist (fun-bt '(apropos-function apropos-macro apropos-command))
        (button-type-put
         fun-bt 'action
         (lambda (button)
           (helpful-callable (button-get button 'apropos-symbol)))))
      (dolist (var-bt '(apropos-variable apropos-user-option))
        (button-type-put
         var-bt 'action
         (lambda (button)
           (helpful-variable (button-get button 'apropos-symbol))))))))

(leaf bookmark
  :config
  (setq bookmark-default-file (expand-file-name "bookmarks" user-cache-directory)
        bookmark-fringe-mark nil))

;; file related
(leaf emacs
  :init
  (setq auto-save-list-file-prefix (expand-file-name ".saves-" user-cache-directory)
        auto-save-list-file-name (expand-file-name ".saves-mac" user-cache-directory))
  (setq-default auto-save-default nil)
  (setq delete-by-moving-to-trash t
        inhibit-compacting-font-caches t
        make-backup-files nil
        create-lockfiles nil))

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(defun reload-init-file ()
  "Reload Emacs configurations."
  (interactive)
  (load user-init-file))

(define-key input-decode-map (kbd "C-i") (kbd "H-i"))
(leaf emacs :ensure nil
  :bind
  ("H-i" . join-line)
  ("s-r"     . revert-buffer-quick)
  ("C-x K"   . delete-this-file)
  ("C-c C-l" . reload-init-file)
  ("C-c C-w 0" . desktop-clear)
  ("C-<wheel-up>" . nil)
  ("C-<wheel-down>" . nil)
  ("s-a" . mark-whole-buffer)
  ("s-c" . kill-ring-save)
  ("s-v" . yank)
  ("s-n" . make-frame-command)
  ("s-s" . save-buffer)
  ("s-x" . execute-extended-command)
  ("s-z" . undo)
  ("M-p" . duplicate-dwim)
  ("C-c y" . copy-from-above-command)
  ("s-k" . kill-current-buffer)
  ("C-x k" . kill-current-buffer)
  (:prog-mode-map
   ("C-c k" . compile)))

(leaf orderless :ensure t
  :custom
  (completion-styles . '(orderless partial-completion basic))
  (completion-category-overrides . '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard . t))

(leaf pinyinlib :ensure t
  :after orderless
  :commands orderless-regexp
  :commands pinyinlib-build-regexp-string
  :config
  (defun orderless-regexp-pinyin (str)
    "Match COMPONENT as a pinyin regex."
    (orderless-regexp (pinyinlib-build-regexp-string str)))
  (add-to-list 'orderless-matching-styles 'orderless-regexp-pinyin))

(leaf vertico :ensure t
  :custom (vertico-count . 15)
  :bind
  ((:vertico-map
    ("RET" . vertico-directory-enter)
    ("DEL" . vertico-directory-delete-char)
    ("M-DEL" . vertico-directory-delete-word)))
  :global-minor-mode vertico-mode
  :hook
  (rfn-eshadow-update-overlay-hook . vertico-directory-tidy)
  (vertico-mode-hook . vertico-multiform-mode)
  :config
  (leaf vertico-multiform
    :config
    (defvar +vertico-transform-functions nil)

    (cl-defmethod vertico--format-candidate :around
      (cand prefix suffix index start &context ((not +vertico-transform-functions) null))
      (dolist (fun (ensure-list +vertico-transform-functions))
        (setq cand (funcall fun cand)))
      (cl-call-next-method cand prefix suffix index start))

    (defun +vertico-highlight-directory (file)
      "If FILE ends with a slash, highlight it as a directory."
      (when (string-suffix-p "/" file)
        (add-face-text-property 0 (length file) 'marginalia-file-priv-dir 'append file))
      file)

    (defun +vertico-highlight-enabled-mode (cmd)
      "If MODE is enabled, highlight it as font-lock-constant-face."
      (let ((sym (intern cmd)))
        (with-current-buffer (nth 1 (buffer-list))
          (if (or (eq sym major-mode)
                  (and
                   (memq sym minor-mode-list)
                   (boundp sym)
                   (symbol-value sym)))
              (add-face-text-property 0 (length cmd) 'font-lock-constant-face 'append cmd)))
        cmd))

    (add-to-list 'vertico-multiform-categories
                 '(file
                   (+vertico-transform-functions . +vertico-highlight-directory)))
    (add-to-list 'vertico-multiform-commands
                 '(execute-extended-command
                   (+vertico-transform-functions . +vertico-highlight-enabled-mode)))))

(leaf marginalia :ensure t
  :global-minor-mode marginalia-mode)

(defmacro my/embark-ace-action ()
  `(defun ,(intern (concat "my/embark-ace-" (symbol-name fn))) ()
     (interactive)
     (with-demoted-errors "%s"
       (require 'ace-window)
       (let ((aw-dispatch-always t))
         (aw-switch-to-window (aw-select nil))
         (call-interactively (symbol-function ',fn))))))
(defmacro my/embark-split-action (fn split-type)
  `(defun ,(intern (concat "my/embark-"
                           (symbol-name fn)
                           "-"
                           (car (last  (split-string
                                        (symbol-name split-type) "-"))))) ()
     (interactive)
     (funcall #',split-type)
     (call-interactively #',fn)))

(leaf embark :ensure t
  :commands embark-prefix-help-command
  :bind
  ("M-SPC"   . embark-act)
  ("M-*"   . embark-act-all)
  ("M-S-SPC"   . embark-select)
  ("S-<return>"   . embark-dwim)        ; overrides `xref-find-definitions'
  ([remap describe-bindings] . embark-bindings)
  (:embark-file-map
   ("S"        . sudo-find-file)
   ("R"        . rename-file)
   ("2"        . (my/embark-split-action find-file split-window-below))
   ("3"        . (my/embark-split-action find-file split-window-right))
   ("4"        . find-file-other-window)
   ("5"        . find-file-other-frame)
   ("C-="      . diff))
  (:embark-buffer-map
   ("d"        . diff-buffer-with-file)
   ("l"        . eval-buffer)
   ("2"        . (my/embark-split-action switch-to-buffer split-window-below))
   ("3"        . (my/embark-split-action switch-to-buffer split-window-right))
   ("4"        . switch-to-buffer-other-window)
   ("5"        . switch-to-buffer-other-frame)
   ("C-="      . diff-buffers))
  (:embark-bookmark-map
   ("2"        . (my/embark-split-action bookmark-jump split-window-below))
   ("3"        . (my/embark-split-action bookmark-jump split-window-right))
   ("4"        . bookmark-jump-other-window)
   ("5"        . bookmark-jump-other-frame))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(leaf embark-consult :ensure t
  :bind
  ((:minibuffer-local-map
    :package minibuffer
    ("C-c C-o" . embark-export)
    ("C->" . embark-become)
    ("M-*" . embark-act-all)))
  :hook (embark-collect-mode-hook . consult-preview-at-point-mode))

(leaf consult :ensure t
  :commands consult-customize
  :bind
  (([remap Info-search]        . consult-info)
   ;; ([remap isearch-forward]    . consult-line)
   ([remap recentf-open-files] . consult-recent-file)
   ([remap bookmark-jump] . consult-bookmark)
   ("M-s i" . consult-imenu)
   ("C-c T" . consult-theme)
   
   ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
   
   ;; Custom M-# bindings for fast register access
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)
   
   ;; Other custom bindings
   ("M-y" . consult-yank-pop)                ;; orig. yank-pop
   
   ;; M-g bindings in `goto-map'
   ("M-s e" . consult-compile-error)
   ("M-g g" . consult-grep-match)
   ("M-g f" . consult-flymake)
   ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
   ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   
   ;; M-s bindings in `search-map'
   ("s-f" . consult-line)
   ("M-s d" . consult-fd)                  ;; Alternative: consult-fd
   ("M-s c" . consult-locate)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ("C-x C-r" . consult-recent-file)
   ("C-x b" . consult-buffer)

   ("M-s e" . consult-isearch-history))
  (:isearch-mode-map
   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
   ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
   ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi))
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :init
  (setq consult-preview-key '("M-."))
  (consult-customize
   consult-goto-line :preview-key 'any
   consult-line consult-line-multi
   consult-ripgrep consult-git-grep consult-grep
   :preview-key 'any)
  
  (setq read-file-name-function #'consult-find-file-with-preview)

  (defun consult-find-file-with-preview (prompt &optional dir default mustmatch initial pred)
    (interactive)
    (let ((default-directory (or dir default-directory))
          (minibuffer-completing-file-name t))
      (substitute-in-file-name
       (consult--read #'read-file-name-internal
                      :state (consult--file-preview)
                      :prompt prompt
                      :initial (abbreviate-file-name default-directory)
                      :require-match mustmatch
                      :predicate pred))))
  
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(leaf consult-dir
  :ensure t
  :bind
  (("C-x C-d" . consult-dir))
  (:minibuffer-local-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

(leaf corfu :ensure t
  :custom
  (corfu-auto . t)
  (corfu-auto-prefix . 2)
  (corfu-count . 12)
  (corfu-preview-current . nil)
  (corfu-on-exact-match . nil)
  (corfu-auto-delay . 0.2)
  (corfu-popupinfo-delay . '(0.4 . 0.2))
  (global-corfu-modes . '((not erc-mode
                               circe-mode
                               help-mode
                               gud-mode
                               eat-mode
                               ghostel-mode
                               vterm-mode)
                          t))
  
  ;; :custom-face
  ;; (corfu-border . ((t (:inherit region :background unspecified))))
  :bind (("M-/" . completion-at-point))
  :global-minor-mode
  global-corfu-mode
  corfu-history-mode
  corfu-popupinfo-mode
  :config
  ;; Let corfu child frame be empty, ask wm to toggle float for empty frame from emacs.
  (setf (alist-get 'name  corfu--frame-parameters nil nil #'eq)  ""
        (alist-get 'title corfu--frame-parameters nil nil #'eq)  "")
  ;;Quit completion before saving
  (add-hook 'before-save-hook #'corfu-quit)
  (advice-add #'persistent-scratch-save :before #'corfu-quit)
  (add-to-list 'corfu-continue-commands #'corfu-move-to-minibuffer))

;; A few more useful configurations...
(leaf emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent . 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  (text-mode-ispell-word-completion . nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (read-extended-command-predicate . #'command-completion-default-include-p))

(leaf cape :ensure t
  :commands (cape-file cape-elisp-block cape-keyword)
  :commands (cape-wrap-noninterruptible cape-wrap-nonexclusive cape-wrap-buster)
  :commands (cape-wrap-silent)
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; Make these capfs composable.
  (advice-add 'comint-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive))

(defun meow-setup ()
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore)
   '("/" . consult-line))
  (setq meow-selection-command-fallback
        '((meow-change . meow-change-char)
          ;; (meow-kill . meow-C-k)
          (meow-kill . meow-delete)
          (meow-save . kill-ring-save)
          ;; (meow-cancel-selection . keyboard-quit)
          (meow-cancel-selection . ignore)
          (meow-pop-selection . meow-pop-grab)
          (meow-beacon-change . meow-beacon-change-char)
          (meow-expand . meow-digit-argument)))
        
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '(")" . puni-slurp-forward)
   '("(" . puni-barf-forward)
   '("{" . puni-slurp-backward)
   '("}" . puni-barf-backward)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-kill)
   ;; '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("E" . forward-sexp)
   '("f" . meow-find)
   '("g" . meow-join)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . avy-goto-char-timer)
   '("n" . meow-search)
   '("o" . meow-open-below)
   '("O" . meow-open-above)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-grab)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-line-expand)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("Z" . avy-zap-to-char)
   '("'" . repeat)
   '("<escape>" . meow-cancel-selection)
   '("/" . consult-line)
   '("=" . puni-expand-region)))

(leaf meow :ensure t
  :global-minor-mode meow-global-mode
  :custom
  (meow-keypad-leader-dispatch . "C-c")
  :config
  (meow-setup))

(leaf emacs
  :custom
  (duplicate-line-final-position . 1)
  :setq-default
  (truncate-lines . t))

(leaf delsel
  :global-minor-mode delete-selection-mode)

(leaf abbrev
  :blackout t
  :init
  (setq-default abbrev-mode t)
  (setq abbrev-file-name (expand-file-name "abbrev.el" user-emacs-directory)))

(leaf autorevert
  :global-minor-mode global-auto-revert-mode)

(leaf goto-addr
  :hook (((text-mode-hook org-mode-hook) . goto-address-mode)
         (prog-mode . goto-address-prog-mode)))

(leaf elec-pair
  :hook
  (prog-mode-hook . electric-pair-local-mode))

(leaf puni :ensure t
  :hook prog-mode-hook
  :custom
  (puni-confirm-when-delete-unbalanced-active-region . nil)
  :bind
  ("M-r" . puni-raise)
  ("C-M-s" . puni-splice)
  ("C-=" . puni-expand-region)
  ("M-[" . puni-slurp-backward)
  ("M-]" . puni-slurp-forward)
  ("s-[" . puni-barf-backward)
  ("s-]" . puni-barf-forward)
  ("C-(" . puni-wrap-round)
  ("C-{" . puni-wrap-curly)
  ([remap backward-kill-word] . puni-backward-kill-word)
  :init
  (defun my/backspace ()
    (interactive)
    (if (looking-back (rx line-start (+ blank)))
        (delete-region (line-beginning-position) (point))
      (puni-backward-delete-char))))

(leaf combobulate
  :disabled t
  :ensure (combobulate :host github :repo "mickeynp/combobulate")
  :config
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-c o"))

(define-prefix-command 'macrursors-mark-map)
(leaf macrursors
  :blackout t
  :ensure (macrursors :host github :repo "corytertel/macrursors")
  :global-minor-mode macrursors-mode
  :bind-keymap ("C-;" . macrursors-mark-map)
  :bind
  ("M-P" . macrursors-mark-previous-instance-of)
  ("M-N" . macrursors-mark-next-instance-of)
  ("C-M-;" . macrursors-mark-all-instances-of)
  ("C-c SPC" . macrursors-select)
  (:isearch-mode-map
   ("C-;" . macrursors-mark-from-isearch)
   ("M-s n" . macrursors-mark-next-from-isearch)
   ("M-s p" . macrursors-mark-previous-from-isearch))
  (:macrursors-mode-map
   ("C-;" . nil)
   ("C-; C-;" . macrursors-end)
   ("C-; C-j" . macrursors-end))
  (:macrursors-mark-map
   ("C-n" . macrursors-mark-next-line)
   ("C-p" . macrursors-mark-previous-line)
   ("." . macrursors-mark-all-instances-of)
   ("o" . macrursors-mark-all-instances-of)
   ("SPC" . macrursors-select)
   ("l" . macrursors-mark-all-lists)
   ("s" . macrursors-mark-all-symbols)
   ("w" . macrursors-mark-all-words)
   ("C-M-e" . macrursors-mark-all-sexps)
   ("d" . macrursors-mark-all-defuns)
   ("n" . macrursors-mark-all-numbers)
   (")" . macrursors-mark-all-sentences)
   ("M-e" . macrursors-mark-all-sentences)
   ("e" . macrursors-mark-all-lines))
  :init
  (leaf macrursors-select
    :bind (:macrursors-mark-map
           ("C-g" . macrursors-select-clear))))

;; Treat undo history as a tree
(leaf vundo :ensure t
  :bind ("C-x u" . vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols))

;; Remember undo history
(leaf undo-fu-session :ensure t
  :hook
  (emacs-startup-hook . undo-fu-session-global-mode)
  :custom
  `(undo-fu-session-directory . ,(expand-file-name "undo-fu-session" user-cache-directory)))

(leaf mwim :ensure t
  :bind
  ([remap move-beginning-of-line] . mwim-beginning)
  ([remap move-end-of-line] . mwim-end))

(leaf avy :ensure t
  :bind
  ("C-'" . avy-goto-char-timer)
  (:isearch-mode-map
   ("C-'" . avy-isearch))
  :config
  (setq avy-all-windows nil
        avy-all-windows-alt t
        avy-background nil
        avy-style 'at-full))

;; Kill text between cursor and char
(leaf avy-zap :ensure t
  :bind
  ("M-z" . avy-zap-to-char-dwim)
  ("M-Z" . avy-zap-up-to-char-dwim))

(leaf ace-pinyin :ensure t
  :blackout t
  :global-minor-mode ace-pinyin-global-mode)

;; show number of matches
(leaf anzu :ensure t
  :blackout t
  :bind
  ([remap query-replace] . anzu-query-replace)
  ([remap query-replace-regexp] . anzu-query-replace-regexp)
  (:isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :global-minor-mode global-anzu-mode)

;; Goto last change
(leaf goto-chg :ensure t
  :bind ("C-," . goto-last-change))

(leaf yasnippet :ensure t
  :blackout yas-minor-mode
  :hook
  ((prog-mode-hook LaTeX-mode-hook org-mode-hook)
   . yas-minor-mode)
  (yas-minor-mode-hook . my/yas-auto-setup)
  :init
  (defvar yas-verbosity 2)
  :config
  (yas-reload-all)

  ;; Snippets trigger inside a word
  ;; (setq yas-key-syntaxes (list #'yas-longest-key-from-whitespace "w_.()" "w_." "w_" "w"))
  (defun my/yas-try-2-suffix (pt)
    (skip-syntax-backward "w" (- (point) 2)))
  (defun my/yas-try-3-suffix (pt)
    (skip-syntax-backward "w" (- (point) 3)))
  (add-to-list 'yas-key-syntaxes #'my/yas-try-2-suffix)
  (add-to-list 'yas-key-syntaxes #'my/yas-try-3-suffix)

  (setq yas-triggers-in-field t
        yas-wrap-around-region t)

  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (defun my/yas-auto-setup ()
    (add-hook 'post-self-insert-hook #'my/yas-try-expanding-auto-snippets nil t))

  (with-eval-after-load 'corfu
    (defun my/yas-corfu-cancel ()
      "company-abort or yas-abort-snippet."
      (interactive)
      (if corfu--candidates
          (corfu-quit)
        (yas-abort-snippet)))
    (define-key yas-keymap (kbd "C-g") #'my/yas-corfu-cancel)))

(leaf consult-yasnippet
  :ensure t
  :after yasnippet
  :bind ("M-g y" . consult-yasnippet))

(leaf doom-snippets
  :ensure (doom-snippets :host github :repo "doomemacs/snippets")
  :config
  ;; Disable snippets for certain modes
  (defun my/yas-write-skip-file (dir)
    "Create DIR/.yas-skip if DIR exists."
    (let ((f (expand-file-name ".yas-skip" dir)))
      (when (file-directory-p dir)
        (unless (file-exists-p f)
          (with-temp-file f)))))

  (dolist (mode '(latex-mode emacs-lisp-mode))
    (let ((dir (expand-file-name (symbol-name mode) doom-snippets-dir)))
      (my/yas-write-skip-file dir)))
  :after yasnippet)

(leaf which-key :ensure t
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

(leaf transient :require t
  :config
  (setq transient-history-file (expand-file-name "transient/history.el" user-cache-directory)
        transient-levels-file (expand-file-name "transient/levels.el" user-cache-directory)
        transient-values-file (expand-file-name "transient/values.el" user-cache-directory)
        transient-show-popup t))

(leaf tramp :require t
  :setq (tramp-default-method . "ssh")
  (tramp-verbose . 1)
  `(tramp-persistency-file-name . ,(expand-file-name "tramp" user-cache-directory))
  (tramp-allow-unsafe-temporary-files . t)
  (remote-file-name-inhibit-locks . t)
  (remote-file-name-inhibit-auto-save-visited . t)
  `(tramp-copy-size-limit . ,(* 1024 1024)))

(leaf epa :require t
  :custom
  (epa-pinentry-mode . 'loopback)
  (epa-keys-select-method . 'minibuffer)
  :config
  (epa-file-enable))

(leaf auth-source-pass
  :config
  (auth-source-pass-enable))

(leaf pass :ensure t)

(setq message-send-mail-function 'smtpmail-send-it)
(setq user-mail-address "zelongkuang@mailbox.org")
(setq user-full-name "Zelong Kuang")

(setq smtpmail-smtp-user "zelongkuang@mailbox.org"
      smtpmail-smtp-server "smtp.mailbox.org"
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl)
(setq smtpmail-debug-info t)
(setq smtpmail-debug-verb t)

(leaf notmuch :ensure t
  :bind
  ("C-c m" . notmuch)
  ([remap compose-mail] . notmuch-mua-new-mail)
  (:notmuch-show-mode-map
   ("S" . (lambda ()
            "mark message as spam"
            (interactive)
            (notmuch-show-tag (list "+spam" "-inbox"))))
   ("D" . (lambda ()
            "toggle deleted tag for message"
            (interactive)
            (if (member "deleted" (notmuch-show-get-tags))
                (notmuch-show-tag (list "-deleted"))
              (notmuch-show-tag (list "+deleted"))))))
  (:notmuch-search-mode-map
   ("A" . notmuch-search-archive-thread)
   ("D" . (lambda (&optional beg end)
            "toggle deleted tag for message"
            (interactive)
            (if (member "deleted" (notmuch-search-get-tags))
                (notmuch-search-tag (list "-deleted") beg end)
              (notmuch-search-tag (list "+deleted") beg end))))
   ("S" . (lambda (&optional beg end)
            (interactive (notmuch-interactive-region))
            (notmuch-search-tag (list "+spam" "-inbox") beg end))))
  :custom
  (notmuch-search-oldest-first . nil)
  (notmuch-show-logo . nil)
  (notmuch-hello-auto-refresh . t)
  (notmuch-hello-recent-searches-max . 20)
  (notmuch-hello-thousands-separator . "")
  (notmuch-hello-sections . '(notmuch-hello-insert-saved-searches))
  (notmuch-show-all-tags-list . t)
  (notmuch-search-result-format
   . '(("date" . "%12s  ")
       ("count" . "%-7s  ")
       ("authors" . "%-20s  ")
       ("subject" . "%-80s  ")
       ("tags" . "(%s)")))
  (notmuch-tree-result-format
   . '(("date" . "%12s  ")
       ("authors" . "%-20s  ")
       ((("tree" . "%s")
         ("subject" . "%s"))
        . " %-80s  ")
       ("tags" . "(%s)")))
  (notmuch-show-empty-saved-searches . t)
  :config
  (setq send-mail-function 'sendmail-send-it
        mail-specify-envelope-from t
        message-sendmail-envelope-from 'header
        mail-envelope-from 'header))

(leaf consult-notmuch :ensure t
  :bind
  ("M-s m" . consult-notmuch))

(leaf elcord :ensure t)

(defun split-window-horizontally-instead ()
  "Kill other windows and split the current window horizontally."
  (interactive)
  (let* ((next-window (next-window))
         (other-buffer (and next-window (window-buffer next-window))))
    (delete-other-windows)
    (split-window-horizontally)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(defun split-window-vertically-instead ()
  "Kill other windows and split the current window vertically."
  (interactive)
  (let* ((next-window (next-window))
         (other-buffer (and next-window (window-buffer next-window))))
    (delete-other-windows)
    (split-window-vertically)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(leaf ace-window :ensure t
  :bind (([remap other-window] . ace-window)
         ("M-o" . ace-window)
         ("C-c 2" . split-window-vertically-instead)
         ("C-c 3" . split-window-horizontally-instead))
  :custom
  (aw-scope . 'frame)
  (aw-background . nil)
  (aw-display-mode-overlay . nil)
  (aw-dispatch-always . t)
  :config
  (defun my/aw-take-over-window (window)
    "Move from current window to WINDOW.

Delete current window in the process."
    (let ((buf (current-buffer)))
      (if (one-window-p)
          (delete-frame)
        (delete-window))
      (aw-switch-to-window window)
      (switch-to-buffer buf)))
  (setq aw-dispatch-alist
        '((?k aw-delete-window "Delete Window")
          (?x aw-swap-window "Swap Windows")
          (?m my/aw-take-over-window "Move Window")
          (?c aw-copy-window "Copy Window")
          (?j aw-switch-buffer-in-window "Select Buffer")
          (?o aw-flip-window)
          (?b aw-switch-buffer-other-window "Switch Buffer Other Window")
          (?c aw-split-window-fair "Split Fair Window")
          (?s aw-split-window-vert "Split Vert Window")
          (?v aw-split-window-horz "Split Horz Window")
          (?O delete-other-windows "Delete Other Windows")
          (?? aw-show-dispatch-help)))
  )

(leaf ace-window
  :after transient
  :bind ("C-c w" . ace-window-transient-menu) ; Bind as you prefer
  :transient
  (ace-window-transient-menu
   ()
   "Ace Window Menu"
   :transient-suffix 'transient--do-stay
   
   [["Actions"
     ("TAB" "switch" other-window)
     ("x" "delete" ace-delete-window)
     ("X" "del other" ace-delete-other-windows :transient transient--do-exit)
     ("s" "swap" ace-swap-window)
     ("a" "select" ace-select-window :transient transient--do-exit)
     ("m" "maximize" maximize-window :transient transient--do-exit)
     ("u" "fullscreen" toggle-frame-fullscreen :transient transient--do-exit)]

    ["Resize"
     ("h" "shrink H" shrink-window-horizontally)
     ("j" "enlarge" enlarge-window)
     ("k" "shrink" shrink-window)
     ("l" "enlarge H" enlarge-window-horizontally)
     ("n" "balance" balance-windows)]

    ["Split"
     ("r" "horizontally" split-window-right)
     ("R" "split-window-horizontally-instead" split-window-horizontally-instead)
     ("v" "vertically" split-window-below)
     ("V" "split-window-vertically-instead" split-window-vertically-instead)]

    ["Zoom"
     ("+" "text in" text-scale-increase)
     ("=" "text in" text-scale-increase)
     ("-" "text out" text-scale-decrease)
     ("0" "reset" (lambda () (interactive) (text-scale-increase 0)))]

    ["Misc"
     ("o" "frame font" set-frame-font)
     ("f" "new frame" make-frame-command)
     ("d" "del frame" delete-frame)
     ("<left>" "undo" winner-undo)
     ("<right>" "redo" winner-redo)]]))

(leaf popper :ensure t
  :custom
  (popper-group-function . #'popper-group-by-directory)
  (popper-echo-dispatch-actions . t)
  :bind (:popper-mode-map
         ("C-h z"       . popper-toggle)
         ("C-<tab>"     . popper-cycle)
         ("C-M-<tab>"   . popper-toggle-type))
  :hook (emacs-startup-hook . popper-echo-mode)
  :init
  (setq popper-mode-line ""
        popper-reference-buffers
        '("\\*Messages\\*$"
          "Output\\*$" "\\*Pp Eval Output\\*$"
          "^\\*eldoc.*\\*$"
          "\\*Compile-Log\\*$"
          "\\*Completions\\*$"
          "\\*Warnings\\*$"
          "\\*Async Shell Command\\*$"
          "\\*Apropos\\*$"
          "\\*Backtrace\\*$"
          "\\*Calendar\\*$"
          "\\*Fd\\*$" "\\*Find\\*$" "\\*Finder\\*$"
          "\\*Kill Ring\\*$"
          "\\*Embark \\(Collect\\|Live\\):.*\\*$"

          bookmark-bmenu-mode
          comint-mode
          compilation-mode
          help-mode helpful-mode
          tabulated-list-mode
          Buffer-menu-mode

          flymake-diagnostics-buffer-mode

          gnus-article-mode devdocs-mode
          grep-mode occur-mode rg-mode
          osx-dictionary-mode fanyi-mode
          "^\\*gt-result\\*$" "^\\*gt-log\\*$"

          "^\\*Process List\\*$" process-menu-mode
          list-environment-mode cargo-process-mode

          "^\\*.*eat.*\\*.*$"
          "^\\*ghostel\\*$" ghostel-mode
          "^\\*.*eshell.*\\*.*$"
          "^\\*.*shell.*\\*.*$"
          "^\\*.*terminal.*\\*.*$"
          "^\\*.*vterm[inal]*.*\\*.*$"

          "\\*DAP Templates\\*$" dap-server-log-mode
          "\\*ELP Profiling Restuls\\*" profiler-report-mode
          "\\*package update results\\*$" "\\*Package-Lint\\*$"
          "\\*[Wo]*Man.*\\*$"
          "\\*ert\\*$" overseer-buffer-mode
          "\\*gud-debug\\*$"
          "\\*lsp-help\\*$" "\\*lsp session\\*$"
          "\\*quickrun\\*$"
          "\\*tldr\\*$"
          "\\*vc-.*\\**"
          "\\*diff-hl\\**"
          "^\\*macro expansion\\**"

          "\\*Agenda Commands\\*" "\\*Org Select\\*" "\\*Capture\\*" "^CAPTURE-.*\\.org*"
          "\\*Gofmt Errors\\*$" "\\*Go Test\\*$" godoc-mode
          "\\*docker-.+\\*"
          "\\*prolog\\*" inferior-python-mode inf-ruby-mode swift-repl-mode
          "\\*rustfmt\\*$" rustic-compilation-mode rustic-cargo-clippy-mode
          rustic-cargo-outdated-mode rustic-cargo-run-mode rustic-cargo-test-mode
          "\\*haskell\\*"))
  (add-to-list 'display-buffer-alist
               '("\\*OCaml\\*"
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.5)))

  :config
  (with-no-warnings
    (defun my-popper-fit-window-height (win)
      "Adjust the height of popup window WIN to fit the buffer's content."
      (let ((desired-height (floor (/ (frame-height) 3))))
        (fit-window-to-buffer win desired-height desired-height)))
    (setq popper-window-height #'my-popper-fit-window-height)

    (defun popper-close-window-hack (&rest _args)
      "Close popper window via `C-g'."
      (when (and ; (called-interactively-p 'interactive)
             (not (region-active-p))
             popper-open-popup-alist)
        (let ((window (caar popper-open-popup-alist))
              (buffer (cdar popper-open-popup-alist)))
          (when (and (window-live-p window)
                     (buffer-live-p buffer)
                     (not (with-current-buffer buffer
                            (derived-mode-p 'eshell-mode
                                            'shell-mode
                                            'ghostel-mode
                                            'term-mode
                                            'vterm-mode))))
            (delete-window window)))))
    (advice-add #'keyboard-quit :before #'popper-close-window-hack)))

(leaf project
  :bind-keymap ("s-p" . project-prefix-map)
  ;; :init
  ;; (setq frame-title-format '((:eval
  ;;                             (let* ((proj (project-current nil))
  ;;                                    (pname (and proj (project-name proj))))
  ;;                               (if pname
  ;;                                   (format "[%s] %s" pname (buffer-name))
  ;;                                 (buffer-name)))))) ;; Otherwise buffer name only
  :config
  (setq project-list-file (expand-file-name "projects" user-cache-directory)))

(leaf ibuffer
  
  :bind ("C-x C-b" . ibuffer)
  :bind (:ibuffer-mode-map
         ("M-o" . nil))
  :config
  (add-to-list 'ibuffer-help-buffer-modes 'helpful-mode)
  (add-to-list 'ibuffer-help-buffer-modes 'Man-mode)
  :init (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))

;; Group ibuffer's list by project
(leaf ibuffer-project
  :ensure t
  :after ibuffer project
  :commands (ibuffer-project-generate-filter-groups ibuffer-do-sort-by-project-file-relative)
  :hook (ibuffer-hook . (lambda ()
                          "Group ibuffer's list by project."
                          (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
                          (unless (eq ibuffer-sorting-mode 'project-file-relative)
                            (ibuffer-do-sort-by-project-file-relative))))
  :init (setq ibuffer-project-use-cache t))

(leaf tab-bar
  :hook (window-setup-hook . tab-bar-mode)
  :bind (:tab-bar-mode-map
         ("s-t" . tab-new)
         ("s-w" . tab-close)
         ("s-W" . delete-frame))
  :config
  (setq tab-bar-separator " "
        tab-bar-show t
        tab-bar-new-tab-choice "*scratch*"
        tab-bar-auto-width nil
        tab-bar-tab-name-truncated-max 20
        tab-bar-close-button-show nil
        tab-bar-new-button-show nil
        tab-bar-format '(tab-bar-format-tabs tab-bar-separator)
        tab-bar-tab-hints t
        tab-bar-select-tab-modifiers '(super))

  (when (featurep 'mac)
    (setq mac-frame-tabbing t))
  
  (defun my/tab-bar-name ()
    (if-let* ((p (project-current nil)))
        (project-name p)
      (tab-bar-tab-name-truncated)))
  (setq tab-bar-tab-name-function #'my/tab-bar-name)

  ;; Add surround space to tab name
  (defun my/tab-bar-tab-name-format (tab i)
    (let* ((s (tab-bar-tab-name-format-default tab i))
           (face (get-text-property 0 'face s)))
      (concat (propertize " " 'face face)
              s
              (propertize " " 'face face))))
  (setq tab-bar-tab-name-format-function #'my/tab-bar-tab-name-format))

(leaf tabspaces :ensure t
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :global-minor-mode tabspaces-mode
  :hook (tabspaces-mode-hook . tab-bar-history-mode)
  :bind (:tabspaces-command-map
         ("l" . tabspaces-restore-session)
         ("s" . tabspaces-save-session)
         ("TAB" . tabspaces-switch-or-create-workspace))
  :custom
  (tab-bar-history-limit . 30)
  
  (tabspaces-use-filtered-buffers-as-default . t)
  (tabspaces-default-tab . "Default")
  (tabspaces-remove-to-default . t)
  (tabspaces-include-buffers . '("*scratch*" "*Messages*"))
  (tabspaces-exclude-buffers . '("*eat*" "*ghostel*" "*vterm*" "*shell*" "*eshell*"))
  
  `(tabspaces-session-file . ,(expand-file-name "tabspaces/tabsession.el" user-cache-directory))
  `(tabspaces-session-project-session-store . ,(expand-file-name "tabspaces/" user-cache-directory))
  (tabspaces-initialize-project-with-todo . t)
  (tabspaces-todo-file-name . "project-todo.org")
  ;; sessions
  (tabspaces-session . t)
  (tabspaces-session-auto-restore . nil)
  :config
  (with-eval-after-load 'consult
    ;; hide full buffer list (still available with "b" prefix)
    (plist-put consult-source-buffer :hidden t)
    (plist-put consult-source-buffer :default nil)
    ;; set consult-workspace buffer list
    (defvar consult--source-workspace
      (list :name     "Workspace Buffers"
            :narrow   ?w
            :history  'buffer-name-history
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    (lambda () (consult--buffer-query
                                  :predicate #'tabspaces--local-buffer-p
                                  :sort 'visibility
                                  :as #'buffer-name)))

      "Set workspace buffer list for consult-buffer.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

(leaf beframe
  :disabled t
  :global-minor-mode beframe-mode
  :bind-keymap ("C-c b" . beframe-prefix-map)
  :bind ("C-x f" . other-frame-prefix)
  :config
  (setq beframe-functions-in-frames '(project-switch-project)
        beframe-rename-function #'ignore
        beframe-global-buffers '("*scratch*" "*Messages*" "*Backtrace*"))
  (leaf embark
    
    :config
    (define-key embark-buffer-map (kbd "fu")
                (defun my/beframe-unassume-buffer (buf)
                  (interactive "bUnassume: ")
                  (beframe--unassume
                   (list (get-buffer buf)))))
    (define-key embark-buffer-map (kbd "fa")
                (defun my/beframe-assume-buffer (buf)
                  (interactive "bAssume: ")
                  (beframe--assume
                   (list (get-buffer buf))))))

  ;; Beframe integration with other packages
  (with-eval-after-load 'consult
    (defun consult-beframe-buffer-list (&optional frame)
      "Return the list of buffers from `beframe-buffer-names' sorted by visibility.
With optional argument FRAME, return the list of buffers of FRAME."
      (beframe-buffer-list frame :sort #'beframe-buffer-sort-visibility))
    (setq consult-buffer-list-function #'consult-beframe-buffer-list)))

(leaf dired
  :bind
  (:dired-mode-map
   ("C-c C-p" . wdired-change-to-wdired-mode)
   ("b" . dired-up-directory))
  :hook
  (dired-mode-hook . toggle-truncate-lines)
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t)

  ;; Show directory first
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-use-ls-dired t)
  (leaf dired-aux)
  (leaf dired-filter :ensure t
    :blackout t))

(leaf wgrep :ensure t
  :init
  (setq wgrep-auto-save-buffer t
        wgrep-change-readonly-file t))

(leaf comint
  :init
  (setq ansi-color-for-comint-mode t
        ansi-color-for-compilation-mode t))

(leaf ansi-color
  :hook (compilation-filter-hook . ansi-color-compilation-filter))

(leaf xterm-color
  :ensure t
  :defvar (compilation-environment)
  :init
  (setenv "TERM" "xterm-256color")
  (setq comint-output-filter-functions
        (remove 'ansi-color-process-output comint-output-filter-functions))
  (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)

  (setq compilation-environment '("TERM=xterm-256color"))
  (defun my/advice-compilation-filter (fn proc string)
    (funcall fn proc
             (if (eq major-mode 'rg-mode) ; compatible with `rg'
                 string
               (xterm-color-filter string))))
  (advice-add 'compilation-filter :around #'my/advice-compilation-filter)
  (advice-add 'gud-filter :around #'my/advice-compilation-filter))

(leaf ghostel :ensure t
  :bind (("C-`" . ghostel-toggle))
  :hook (eshell-load-hook . ghostel-eshell-visual-command-mode)
  :custom
  (ghostel-tramp-default-method . 'tramp-default-method)
  (ghostel-tramp-shell-integration . t)
  (ghostel-module-auto-install . 'download)
  :config
  (defun ghostel-toggle () (interactive)
         (if (string-match-p "ghostel" (buffer-name))
             (delete-window)
           (ghostel))))

(leaf eshell
  :defvar eshell-prompt-function
  :config
  (setq eshell-banner-message ""))

(leaf eshell-prompt-extras :ensure t
  :defvar eshell-highlight-prompt
  :commands (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
  :custom
  (eshell-highlight-prompt . t)
  (eshell-prompt-function . #'epe-theme-lambda))

(leaf eshell-syntax-highlighting :ensure t
  :after eshell
  :global-minor-mode eshell-syntax-highlighting-global-mode)

(leaf vc
  :custom
  (vc-follow-symlinks . t))

(leaf diff-mode)

(leaf ediff)

(leaf smerge-mode
  :hook ((find-file-hook . (lambda ()
                             (save-excursion
                               (goto-char (point-min))
                               (when (re-search-forward "^<<<<<<< " nil t)
                                 (smerge-mode 1)))))))

(leaf smerge-mode
  :hook ((magit-diff-visit-file-hook . (lambda ()
                                         (when smerge-mode
                                           (smerge-dispatch-menu)))))
  :bind (:smerge-mode-map
         ("C-c m" . smerge-dispatch-menu))
  :after transient
  :transient
  (smerge-dispatch-menu
   ()
   "Smerge Conflict Resolution"
   :transient-suffix 'transient--do-stay
   [["Move"
     ("n" "next" smerge-next)
     ("p" "previous" smerge-prev)]
    
    ["Keep"
     ("b" "base" smerge-keep-base)
     ("u" "upper" smerge-keep-upper)
     ("l" "lower" smerge-keep-lower)
     ("a" "all"  smerge-keep-all)
     ("RET" "current" smerge-keep-current)]
    
    ["Diff"
     ("<" "upper/base" smerge-diff-base-upper)
     ("=" "upper/lower" smerge-diff-upper-lower)
     (">" "base/lower" smerge-diff-base-lower)
     ("R" "refine" smerge-refine)
     ("E" "ediff" smerge-ediff)]
    
    ["Other"
     ("C" "combine" smerge-combine-with-next)
     ("r" "resolve" smerge-resolve)
     ("k" "kill" smerge-kill-current)
     ("ZZ" "Save & bury" (lambda () (interactive) (save-buffer) (bury-buffer)) :transient nil)]]))

(leaf diff-hl :ensure t
  :blackout
  diff-hl-mode
  diff-hl-amend-mode
  diff-hl-show-hunk-mouse-mode
  :global-minor-mode
  global-diff-hl-mode
  global-diff-hl-amend-mode
  global-diff-hl-show-hunk-mouse-mode
  :custom-face
  (diff-hl-change . '((t (:inherit custom-changed :foreground unspecified :background unspecified))))
  (diff-hl-insert . '((t (:inherit diff-added :background unspecified))))
  (diff-hl-delete . '((t (:inherit diff-removed :background unspecified))))
  :custom
  (diff-hl-draw-borders . nil)
  (diff-hl-update-async . 'thread)
  (diff-hl-flydiff-delay . 0.5)
  (diff-hl-global-modes . '(not olivetti-mode image-mode))
  :hook
  (diff-hl-mode-hook . diff-hl-flydiff-mode)
  (magit-post-refresh-hook . diff-hl-magit-post-refresh)
  (dired-mode-hook . diff-hl-dired-mode)
  (olivetti-mode-hook . (lambda () (diff-hl-mode -1)))
  :config
  ;; (setq-default fringes-outside-margins t)
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))
  
  (defun my/diff-hl-fringe-bmp-function (_type _pos)
    "Fringe bitmap function for use as `diff-hl-fringe-bmp-function'."
    (define-fringe-bitmap 'my/diff-hl-bmp
      (vector (if IS-MAC #b11111100 #b11100000))
      1 8
      '(center t)))
  (setq diff-hl-fringe-bmp-function 'my/diff-hl-fringe-bmp-function))

(leaf magit
  :ensure t
  :bind (("C-c g" . magit-dispatch))
  :custom
  (magit-diff-refine-hunk . t)
  (git-commit-major-mode . 'git-commit-elisp-text-mode)
  (magit-tramp-pipe-stty-settings . 'pty)
  :config
  (leaf magit-section
    :bind (:magit-section-mode-map
           ("," . magit-section-up))
    :config
    (setq magit-section-initial-visibility-alist
          '((stashes . hide)
            ([file unstaged status] . hide))))
  (setq magit-show-long-lines-warning nil))

;; Show TODOs in Magit
;; (leaf magit-todos :ensure t
;;   :after magit-status
;;   :hook magit-mode-hook
;;   :commands magit-todos-mode
;;   :init
;;   (setq magit-todos-nice (if (executable-find "nice") t nil)))

;; Walk through git revisions of a file
(leaf git-timemachine :ensure t
  :custom-face
  (git-timemachine-minibuffer-author-face . '((t (:inherit success :foreground unspecified))))
  (git-timemachine-minibuffer-detail-face . '((t (:inherit warning :foreground unspecified))))
  :bind
  (:vc-prefix-map
   :package vc
   ("t" . git-timemachine-toggle))
  :hook ((git-timemachine-mode-hook . (lambda ()
                                        "Improve `git-timemachine' buffers."
                                        ;; Highlight symbols in elisp
                                        (when (derived-mode-p 'emacs-lisp-mode)
                                          (and (fboundp 'highlight-defined-mode)
                                               (highlight-defined-mode t)))

                                        ;; Display line numbers
                                        (when (derived-mode-p 'prog-mode 'yaml-mode 'yaml-ts-mode)
                                          (and (fboundp 'display-line-numbers-mode)
                                               (display-line-numbers-mode t)))))
         (before-revert . (lambda ()
                            (when (bound-and-true-p git-timemachine-mode)
                              (user-error "Cannot revert the timemachine buffer"))))))

(leaf olivetti :ensure t
  :blackout t
  :hook org-mode-hook
  :bind (("<f7>" . olivetti-mode))
  :custom
  (olivetti-style . 'fancy)
  (olivetti-margin-width . 5)
  (olivetti-body-width . 90)
  (olivetti-minimum-body-width . 40))

(leaf denote :ensure t
  :hook
  (dired-mode-hook . denote-dired-mode)
  (text-mode . denote-fontify-links-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n f" . denote-open-or-create)
   ("C-c n N" . denote-type)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n i" . denote-add-links)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/Documents/notes/")
        denote-org-store-link-to-heading 'id)

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the docstring of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

(leaf consult-denote :ensure t
  :global-minor-mode consult-denote-mode
  :bind (("C-c n s" . consult-denote-find)
         ([remap denote-grep] . consult-denote-grep))
  :config
  (setq consult-denote-grep-command 'consult-ripgrep))

(leaf denote-org :ensure t)
(leaf denote-markdown :ensure t)
(leaf denote-silo :ensure t)
(leaf denote-journal :ensure t
  :bind
  (("C-c n j" . denote-journal-new-or-existing-entry)
   ("C-c n J" . denote-journal-new-entry)))
(leaf denote-sequence :ensure t)
(leaf denote-merge
  :disabled t
  :ensure (denote-merge :host github :repo "protesilaos/denote-merge")
  :bind
  ("C-c n m f" . denote-merge-file)
  ("C-c n m r" . denote-merge-region))

(leaf denote-explore :ensure t
  :bind
  (;; Statistics
   ("C-c n e s n" . denote-explore-count-notes)
   ("C-c n e s k" . denote-explore-count-keywords)
   ("C-c n e s e" . denote-explore-barchart-filetypes)
   ("C-c n e s w" . denote-explore-barchart-keywords)
   ("C-c n e s t" . denote-explore-barchart-timeline)
   ;; Random walks
   ("C-c n e w n" . denote-explore-random-note)
   ("C-c n e w r" . denote-explore-random-regex)
   ("C-c n e w l" . denote-explore-random-link)
   ("C-c n e w k" . denote-explore-random-keyword)
   ;; Denote Janitor
   ("C-c n e j d" . denote-explore-duplicate-notes)
   ("C-c n e j D" . denote-explore-duplicate-notes-dired)
   ("C-c n e j l" . denote-explore-missing-links)
   ("C-c n e j z" . denote-explore-zero-keywords)
   ("C-c n e j s" . denote-explore-single-keywords)
   ("C-c n e j r" . denote-explore-rename-keyword)
   ("C-c n e j y" . denote-explore-sync-metadata)
   ("C-c n e j i" . denote-explore-isolated-files)
   ;; Visualise denote
   ("C-c n e n" . denote-explore-network)
   ("C-c n e r" . denote-explore-network-regenerate)
   ("C-c n e d" . denote-explore-barchart-degree)
   ("C-c n e b" . denote-explore-barchart-backlinks)))

;; (leaf rime
;;   :ensure t
;;   :custom
;;   (default-input-method . "rime")
;;   (rime-librime-root . "/opt/homebrew")
;;   ;; (rime-emacs-module-header-root "~/build-emacs-for-macos/builds/Emacs.app/Contents/Resources/include/")
;;   (rime-show-candidate . 'popup)
;;   (rime-popup-properties . nil))

(leaf liberime :ensure t
  :if IS-MAC
  :custom
  ;; Point to liberime module built by oneself
  (liberime-module-file . "~/.local/lib/liberime-core.dylib")
  (liberime-user-data-dir . "~/Library/Rime/"))

(leaf rimel :ensure t
  :custom
  (default-input-method . "rimel")
  ;; horizontal or vertical
  (rimel-posframe-style . 'horizontal)
  :setq
  (rimel-disable-predicates
   . '(rimel-predicate-prog-in-code-p
       rimel-predicate-after-alphabet-char-p
       rimel-predicate-current-uppercase-letter-p
       rimel-predicate-org-latex-mode-p
       rimel-predicate-org-in-src-block-p)))

(leaf flyspell
  :bind (:flyspell-mode-map
         ("C-M-i" . nil)
         ("C-;" . nil)
         ("C-," . nil)
         ("C-; C-4" . 'flyspell-auto-correct-previous-word)))

(leaf jinx :ensure t
  :commands jinx-mode
  :bind ([remap ispell-word] . jinx-correct))

(leaf xref
  :init
  ;; Use faster search tool
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))

  ;; Select from xref candidates in minibuffer
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-completing-read))

(setq blink-matching-paren-highlight-offscreen t
      show-paren-context-when-offscreen 'child-frame)

(leaf eldoc
  :blackout t
  :custom
  (eldoc-documentation-strategy . 'eldoc-documentation-compose-eagerly))

(leaf eldoc-box :ensure t
  :blackout eldoc-box-hover-mode
  :hook
  ((eglot-managed-mode-hook prog-mode-hook)
   . eldoc-box-hover-mode))

;; (leaf eldoc-mouse :ensure t
;;   :hook
;;   eglot-managed-mode-hook
;;   prog-mode-hook)

(leaf citre :ensure t)
(leaf apheleia :ensure t
  :blackout t
  :hook prog-mode-hook LaTeX-mode-hook)
(leaf editorconfig :ensure t)

(leaf treesit-auto :ensure t
  :global-minor-mode global-treesit-auto-mode
  :custom
  (treesit-auto-install . t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))

(leaf elvish-mode :ensure t)

(leaf fish-mode :ensure t)

(leaf docker-compose-mode :ensure t)

(leaf ansible :ensure t)
(leaf ansible-doc :ensure t
  :after ansible)

(leaf systemd :ensure t)

(leaf caddyfile-mode :ensure t)

(leaf dot-env :ensure t)

(leaf envrc :ensure t
  :blackout t
  :global-minor-mode
  envrc-global-mode)

(leaf inputrc-mode :ensure t)

(leaf flymake
  :blackout t
  :bind ("C-c f" . flymake-show-buffer-diagnostics)
  :defun my/elisp-flymake-byte-compile
  :hook prog-mode-hook
  :custom
  (flymake-no-changes-timeout . nil)
  (flymake-fringe-indicator-position . 'right-fringe)
  (flymake-margin-indicator-position . 'right-margin)
  :init
  ;; Check elisp with `load-path'
  (defun my/elisp-flymake-byte-compile (fn &rest args)
    "Wrapper for `elisp-flymake-byte-compile'."
    (let ((elisp-flymake-byte-compile-load-path
           (append elisp-flymake-byte-compile-load-path load-path)))
      (apply fn args)))
  (advice-add 'elisp-flymake-byte-compile :around #'my/elisp-flymake-byte-compile))

(leaf flyover :ensure t
  :blackout t
  :hook flymake-mode-hook
  :config
  (setq flyover-checkers '(flymake)
        flyover-display-mode 'hide-on-same-line
        flyover-background-lightness 60
        flyover-icon-background-tint-percent 50))

(leaf gptel
  :ensure t
  :commands (gptel gptel-menu gptel-send)
  :bind
  ("C-c l l" . gptel)
  ("C-c <return>" . gptel-send)
  ("C-c C-<return>" . gptel-menu)
  ("C-c C-g" . gptel-abort)
  (:gptel-mode-map
   ("C-c C-x t" . gptel-org-set-topic)
   ("+" . gptel-add))
  :hook (gptel-mode-hook . gptel-highlight-mode)
  :defer-config
  (setq gptel-model 'gpt-5.3-codex
        gptel-backend (gptel-make-gh-copilot "Copilot")
        gptel-cache t
        gptel-default-mode #'org-mode
        gptel-highlight-methods '(face)
        gptel-org-branching-context t)
  
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (lambda () (gptel-api-key-from-auth-source "openrouter.ai" "apikey")) ;; Lazy load
    :models '(~google/gemini-flash-latest
              ~google/gemini-pro-latest
              openai/gpt-5.5))
  
  (defun my/gptel-latex-preview (beg end)
    (when (and (display-graphic-p)
               (derived-mode-p 'org-mode))
      (org-latex-preview--preview-region 'dvisvgm beg end)))
  (add-hook 'gptel-post-response-functions #'my/gptel-latex-preview))

(leaf gptel-magit :ensure t
  :after magit
  :hook (magit-mode-hook . gptel-magit-install))

(leaf gptel-agent :ensure t
  :bind
  ("C-c l a" . gptel-agent)
  :config (gptel-agent-update))

(leaf org
  :straight `(org
              :fork (:host nil
                     :repo "https://code.200568.top/zelongk/org-mode.git"
                     :branch "dev")
              :files (:defaults "etc")
              :build (:not native-compile)
              :pre-build
              (with-temp-file "org-version.el"
               (require 'lisp-mnt)
               (let ((version
                      (with-temp-buffer
                        (insert-file-contents "lisp/org.el")
                        (lm-header "version")))
                     (git-version
                      (string-trim
                       (with-temp-buffer
                         (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
                         (buffer-string)))))
                (insert
                 (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
                 (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
                 "(provide 'org-version)\n")))
              :pin nil))

(defvar org-directory "~/org")

(leaf org
  :blackout org-indent-mode org-cdlatex-mode
  :hook
  (org-mode-hook . org-cdlatex-mode)
  (org-mode-hook . prettify-symbols-mode)
  (org-mode-hook . turn-on-reftex)
  :custom-face
  (org-block . '((t (:background unspecified))))
  (org-block-begin-line . '((t (:background unspecified))))
  (org-block-end-line . '((t (:background unspecified))))
  :bind
  ("C-c n t" . org-todo-list)
  ("C-c n a" . org-agenda)
  ("C-c n c" . org-capture)
  (:org-mode-map
   ("M-<return>" . org-insert-subheading)
   ("C-'" . nil)
   ("C-c C-M-l" . org-toggle-link-display)
   ("C-c C-M-s" . org-store-link))
  :config
  ;; Share snippets with LaTeX-mode
  (setq org-id-method 'ts

        ;; org-modules '(org-bibtex)
        org-modules nil
        
        org-highlight-latex-and-related '(native latex entities)
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-pretty-entities-include-sub-superscripts nil
        
        org-tags-column 5
        
        org-startup-indented t
        org-indent-indentation-per-level 1

        org-imenu-depth 5))

(leaf org-contrib :ensure t)

(leaf org
  :defer-config
  (setq org-modules '(org-habit)
        org-agenda-files '("~/org/todo.org"))
  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          (todo . " %i")
          (tags . " %i %-12:c")
          (search . " %i %-12:c"))
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-compact-blocks t
        org-agenda-start-day "+0d"
        org-agenda-span 3
        org-agenda-remove-tags t))

(leaf org-super-agenda :ensure t
  :hook org-agenda-mode-hook
  :defer-config
  (setq org-super-agenda-groups
        '(;; Each group has an implicit boolean OR operator between its selectors.
          (:name " Pin"
                 ;; Single arguments given alone
                 :tag ("pin"))
          (:name " Today"  ; Optionally specify section name
                 :time-grid t  ; Items that appear on the time grid
                 :todo "TODAY")  ; Items that have this TODO keyword
          (:name "Important"
                 ;; Single arguments given alone
                 :tag ("bills" "important")
                 :priority "A")
          (:name "󰷉 Assignments"
                 ;; Single arguments given alone
                 :tag "Assignment")
          ;; Set order of multiple groups at once
          (:order-multi (2 (:name " Shopping"
                                  ;; Boolean AND group matches items that match all subgroups
                                  :and (:tag "shopping" :tag "@town"))
                           (:name "󰟪 Food-related"
                                  ;; Multiple args given in list with implicit OR
                                  :tag ("food" "dinner"))
                           (:name " Personal"
                                  :habit t
                                  :tag "personal")
                           ))
          ;; Groups supply their own section names when none are given
          (:tag "questions" :order 7)
          (:todo "WAIT" :order 8)  ; Set order of this section
          (:todo "HOLD" :order 8)  ; Set order of this section
          (:name "󰣳 NAS-related" :tag "NAS" :order 9)
          (:todo ("IDEA")
                 ;; Show this group at the end of the agenda (since it has the
                 ;; highest number). If you specified this group last, items
                 ;; with these todo keywords that e.g. have priority A would be
                 ;; displayed in that group instead, because items are grouped
                 ;; out in the order the groups are listed.
                 :order 9)
          (:name "󰤄 Less Important" :priority<= "B"
                 ;; Show this section after "Today" and "Important", because
                 ;; their order is unspecified, defaulting to 0. Sections
                 ;; are displayed lowest-number-first.
                 :order 1)
          ;; After the last group, the agenda will display items that didn't
          ;; match any of these groups, with the default order position of 99
          )))

(leaf org-caldav :ensure t
  :custom
  (org-caldav-url . "https://radicale.200568.top/zelongk/")
  (org-caldav-calendar-id . "c435d207-e889-72f5-2dcc-821653766a08")
  `(org-caldav-inbox . ,(expand-file-name "radicale.org" org-directory))
  (org-caldav-files . `(,(expand-file-name "todo.org" org-directory)))
  `(org-caldav-save-directory . user-cache-directory)
  (org-icalendar-timezone . "Australia/Melbourne")
  (org-caldav-show-sync-results . nil)
  (org-caldav-sync-todo . t)
  (org-icalendar-include-todo . 'all)
  (org-caldav-todo-percent-states
   . '((0 "TODO")
       (0 "IDEA")
       (0 "TODAY")
       (0 "WAIT")
       (100 "DONE"))))

(leaf org
    :config
    (setq org-default-note-file (expand-file-name "notes.org" org-directory)
          org-capture-templates
          '(("t" "Personal todo" entry
             (file+headline "todo.org" "Inbox")
             "* TODO %?\n%i\n%a" :prepend t)
            ("n" "Personal notes" entry
             (file+headline "notes.org" "Inbox")
             "* %u %?\n%i\n%a" :prepend t)
            ("j" "Journal" entry
             (file+olp+datetree "diary.org")
             "* %U %?\n%i\n%a" :prepend t)))
    (with-no-warnings
      (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
      (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
      (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
      (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) ""))
    (setq org-todo-keywords
          '((sequence
             "TODO(t)"  ; A task that needs doing & is ready to do
             "TODAY(a)" ; A task that needs to be done today
             "PROJ(p)"  ; A project, which usually contains other tasks
             "LOOP(r)"  ; A recurring task
             "STRT(s)"  ; A task that is in progress
             "WAIT(w)"  ; Something external is holding up this task
             "HOLD(h)"  ; This task is paused/on hold because of me
             "IDEA(i)"  ; An unconfirmed and unapproved task or notion
             "|"
             "DONE(d)"  ; Task successfully completed
             "KILL(k)") ; Task was cancelled, aborted, or is no longer applicable
            (sequence
             "|"
             "OKAY(o)"
             "YES(y)"
             "NO(n)"))
          org-todo-keyword-faces
          '(("[-]"  . +org-todo-active)
            ("STRT" . +org-todo-active)
            ("[?]"  . +org-todo-onhold)
            ("WAIT" . +org-todo-onhold)
            ("HOLD" . +org-todo-onhold)
            ("PROJ" . +org-todo-project)
            ("NO"   . +org-todo-cancel)
            ("KILL" . +org-todo-cancel))))

(leaf org-modern :ensure t
    :after org
    :require t
    :hook
    (org-mode-hook . org-modern-mode)
    (org-agenda-finalize . org-modern-agenda)
    :config
    (setq org-modern-block-name t
          org-modern-block-fringe nil
          org-modern-table nil
          org-modern-hide-stars t
	      org-modern-todo-faces
          '(("TODO" :inverse-video t :inherit org-todo)
            ("PROJ" :inverse-video t :inherit +org-todo-project)
            ("STRT" :inverse-video t :inherit +org-todo-active)
            ("[-]"  :inverse-video t :inherit +org-todo-active)
            ("HOLD" :inverse-video t :inherit +org-todo-onhold)
            ("WAIT" :inverse-video t :inherit +org-todo-onhold)
            ("[?]"  :inverse-video t :inherit +org-todo-onhold)
            ("KILL" :inverse-video t :inherit +org-todo-cancel)
            ("NO"   :inverse-video t :inherit +org-todo-cancel))
	      org-modern-list '((43 . "➤")
                            (45 . "–")
                            (42 . "•"))
          org-modern-fold-stars
          '(("" . ""))))

  (leaf org-modern-indent
    :ensure (org-modern-indent :host github :repo "jdtsmith/org-modern-indent")
    :require t
    :after org-modern org
    :hook org-indent-mode-hook)

(leaf org-appear :ensure t
  :hook org-mode-hook
  :commands org-appear--set-elements
  :defer-config
  (setq org-appear-autoemphasis t
	    org-appear-autosubmarkers t
	    org-appear-autolinks nil)
  (run-at-time nil nil #'org-appear--set-elements))

(leaf valign :ensure t
  :blackout t
  :hook org-mode-hook)

(leaf org-latex-preview
  :hook org-mode-hook
  :bind
  (:org-mode-map
   ("C-c C-x SPC" . org-latex-preview-clear-cache))
  :custom
  (org-latex-preview-numbered . nil)
  :defer-config
  (plist-put org-latex-preview-appearance-options :page-width 0.4)
  ;; Add margin and rescale display math
  (defvar my/org-latex-display-math-scale 1)
  (defvar my/org-latex-display-math-margin 5)
  (defun my/org-latex-preview-add-margin-advice (ov _path-info)
    (save-excursion
      (goto-char (overlay-start ov))
      (when-let* ((elem (org-element-context))
                  ((or (eq (org-element-type elem) 'latex-environment)
                       (string-match-p "^\\\\\\[" (org-element-property :value elem))))
                  (img (overlay-get ov 'preview-image))
                  ((and (consp img) (eq (car img) 'image))))
        (let* ((plist (copy-sequence (cdr img)))
               (height (plist-get plist :height)))
          (when (and (consp height) (numberp (car height)))
            (setq plist
                  (plist-put plist :height
                             (cons (* my/org-latex-display-math-scale (car height))
                                   (cdr height)))))
          (setq plist (plist-put plist :margin my/org-latex-display-math-margin))
          (let ((new-img (cons 'image plist)))
            (overlay-put ov 'preview-image new-img)
            (when (overlay-get ov 'display)
              (overlay-put ov 'display new-img)))))))
  (advice-add 'org-latex-preview--update-overlay :after
              #'my/org-latex-preview-add-margin-advice)
  
  ;; (setq org-latex-preview-numbered t)
  (setq org-latex-preview-mode-display-live t)
  (setq org-latex-preview-process-default 'dvisvgm)
  (setq org-latex-preview-mode-update-delay 0.25))

(leaf org-latex-preview
  :hook
  (text-scale-mode-hook . my/text-scale-adjust-latex-previews)
  (org-latex-preview-mode-hook . org-latex-preview-center-mode)
  :defer-config
  ;; Centre display maths
  (defun my/org-latex-preview-uncenter (ov)
    (overlay-put ov 'before-string nil))
  (defun my/org-latex-preview-recenter (ov)
    (overlay-put ov 'before-string (overlay-get ov 'justify)))
  (defun my/org-latex-preview-center (ov)
    (save-excursion
      (goto-char (overlay-start ov))
      (when-let* ((elem (org-element-context))
                  ((or (eq (org-element-type elem) 'latex-environment)
                       (string-match-p "^\\\\\\[" (org-element-property :value elem))))
                  (img (overlay-get ov 'display))
                  (prop `(space :align-to (- center (0.55 . ,img))))
                  (justify (propertize " " 'display prop 'face 'default)))
        (overlay-put ov 'justify justify)
        (overlay-put ov 'before-string (overlay-get ov 'justify)))))
  (define-minor-mode org-latex-preview-center-mode
    "Center equations previewed with `org-latex-preview'."
    :global nil
    (if org-latex-preview-center-mode
        (progn
          (add-hook 'org-latex-preview-overlay-open-functions
                    #'my/org-latex-preview-uncenter nil :local)
          (add-hook 'org-latex-preview-overlay-close-functions
                    #'my/org-latex-preview-recenter nil :local)
          (add-hook 'org-latex-preview-overlay-update-functions
                    #'my/org-latex-preview-center nil :local))
      (remove-hook 'org-latex-preview-overlay-close-functions
                   #'my/org-latex-preview-recenter)
      (remove-hook 'org-latex-preview-overlay-update-functions
                   #'my/org-latex-preview-center)
      (remove-hook 'org-latex-preview-overlay-open-functions
                   #'my/org-latex-preview-uncenter)))
  (defun my/text-scale-adjust-latex-previews ()
    "Adjust the size of latex preview fragments when changing the buffer's text scale."
    (pcase major-mode
      ('latex-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'category)
                 'preview-overlay)
             (my/text-scale--resize-fragment ov))))
      ('org-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'org-overlay-type)
                 'org-latex-overlay)
             (my/text-scale--resize-fragment ov))))))
  
  (defun my/text-scale--resize-fragment (ov)
    (overlay-put
     ov 'display
     (cons 'image
           (plist-put
            (cdr (overlay-get ov 'display))
            :scale (+ 1.0 (* 0.25 text-scale-mode-amount)))))))

(leaf org-download :ensure t
  :commands org-download-clipboard
  :hook ((org-mode-hook dired-mode-hook) . org-download-enable)
  :bind (:org-mode-map
         ("C-M-y" . org-download-clipboard))
  :config
  (setq-default org-download-heading-lvl 1)
  (defconst org-download-image-dir "./attachments/")
  (setq-default org-download-method 'directory))

(leaf org-drawio :ensure t
  :commands (org-drawio-add
             org-drawio-open))

(leaf grip-mode
  :ensure t
  
  :config (setq grip-command 'auto)) ;; auto, grip, go-grip or mdopen

(add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))

(leaf latex :ensure auctex
  :mode (("\\.tex\\'" . LaTeX-mode))
  :hook
  (LaTeX-mode-hook . prettify-symbols-mode)
  :bind
  (:LaTeX-mode-map
   ("C-S-e" . latex-math-from-calc)
   ("C-c x" . TeX-clean))
  :custom
  (TeX-auto-save . t)
  (TeX-parse-self . t)
  (TeX-PDF-mode . t)
  (TeX-DVI-via-PDFTeX . t)
  (TeX-clean-confirm . nil)
  (TeX-save-query . nil)
  (TeX-source-correlate-mode . t)
  (TeX-source-correlate-method . 'synctex)
  (TeX-display-help . t)
  (TeX-show-compilation . nil)
  (TeX-command-extra-options . "-shell-escape")
  (TeX-view-program-selection . '((output-pdf "displayline")))
  ;; :setq-default
  ;; (LaTeX-indent-environment-list . nil)
  ;; (LaTeX-indent-environment-check . nil)
  ;; (LaTeX-indent-level . 0)
  ;; (LaTeX-item-indent . 0)
  ;; (tex-indent-item . 0)
  ;; (tex-indent-basic . 0)
  ;; (LaTeX-indent-environment-list . '())
  ;; (LaTeX-left-right-indent-level . 0)
  ;; (TeX-brace-indent-level . 0)
  :config
  (add-hook 'LaTeX-mode-hook '(lambda ()
                                (setq TeX-command-default "LaTeXMk")))

  (defun latex-math-from-calc ()
    "Evaluate `calc' on the contents of line at point."
    (interactive)
    (cond ((region-active-p)
           (let* ((beg (region-beginning))
                  (end (region-end))
                  (string (buffer-substring-no-properties beg end)))
             (kill-region beg end)
             (insert (calc-eval `(,string calc-language latex
                                          calc-prefer-frac t
                                          calc-angle-mode rad)))))
          (t (let ((l (thing-at-point 'line)))
               (end-of-line 1) (kill-line 0)
               (insert (calc-eval `(,l
                                    calc-language latex
                                    calc-prefer-frac t
                                    calc-angle-mode rad)))))))
  ;; (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  ;; (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  )

(leaf reftex
  :commands turn-on-reftex
  :blackout t
  :hook ((latex-mode-hook LaTeX-mode-hook) . turn-on-reftex)
  :config
  (setf (alist-get "\\*RefTex" display-buffer-alist nil t #'equal)
        '((display-buffer-in-side-window)
          (window-height . 0.25)
          (side . bottom) (slot . -9)))
  (setq reftex-default-bibliography '("~/Documents/roam/biblio.bib"))
  (setq reftex-insert-label-flags '("sf" "sfte"))
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-ref-style-default-list '("Default" "AMSmath" "Cleveref"))
  (setq reftex-use-multiple-selection-buffers t))

(leaf citar
  :ensure t
  :after latex
  :bind
  (:LaTeX-mode-map
   ("C-c ]" . citar-insert-citation))
  (:org-mode-map
   ("C-c C-x ]" . citar-insert-citation))
  :config
  (delete citar-indicator-cited citar-indicators)
  (setq citar-bibliography ;; '("~/Documents/research/control_systems.bib")
        `(,(expand-file-name "~/Documents/roam/biblio.bib"))
        citar-at-point-function 'embark-act
        citar-file-open-function #'consult-file-externally)
  
  (leaf cdlatex
    :config
    (defun my/cdlatex-bibtex-action ()
      "Call `citar-insert-citation' interactively."
      (call-interactively 'citar-insert-citation))
    (setf (alist-get "cite" cdlatex-command-alist nil nil 'equal)
          '("Make a citation interactively"
            "" my/cdlatex-bibtex-action nil t nil))
    (setf (alist-get "cite{" cdlatex-command-alist nil nil 'equal)
          '("Make a citation interactively"
            "cite{" my/cdlatex-bibtex-action nil t nil))))

(leaf citar-embark :ensure t
  :after embark citar
  :require t
  :config
  (citar-embark--enable))

(leaf texpresso :require t
  :after latex
  :blackout texpresso-mode texpresso-sync-mode
  :ensure (texpresso :host github :repo "let-def/texpresso"
                     :files ("emacs/*.el"))
  :hook (texpresso-mode-hook . texpresso-sync-mode)
  :custom
  (texpresso-follow-cursor . t)
  :bind
  (:LaTeX-mode-map
   :package auctex
   ("C-c C-x C-p" . texpresso)
   ("S-s-<mouse-1>" . texpresso-move-to-cursor)))

(leaf cdlatex :ensure t
  :hook ((LaTeX-mode-hook . turn-on-cdlatex)
         (LaTeX-mode . cdlatex-electricindex-mode))
  ;; :bind (:cdlatex-mode-map
  ;;             ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-math-symbol-alist '((?f ("\\varphi" "\\phi"))
                                    (?i ("\\iota"))
                                    (?c ("\\circ"))
                                    ))
  (setq cdlatex-math-modify-alist '((?f "\\mathbb" nil t nil nil)
                                    (?O "\\overset" nil t nil nil)))

  (defun tjh/cdlatex-yas-expand ()
    "Resolve the conflict between cdlatex and yasnippet. When this
function returns true, the default `cdlatex-tab` will not be
executed. The effect of function is to first try yasnippet
expansion, then cdlatex expansion."
    (interactive)
    (if (or (bound-and-true-p yas-minor-mode)
            (bound-and-true-p yas-global-mode))
        (if (yas-expand)
            t
          nil)
      nil))
  (add-hook 'cdlatex-tab-hook 'tjh/cdlatex-yas-expand)
  (cdlatex-reset-mode))

(leaf lazytab :require t
  :ensure (lazytab :host github :repo "karthink/lazytab")
  :after latex
  :bind
  (:LaTeX-mode-map
   ("C-x |" . my/lazytab-orgtbl-edit))
  (:orgtbl-mode-map
   ("<tab>" . lazytab-org-table-next-field-maybe)
   ("TAB" . lazytab-org-table-next-field-maybe))
  :config
  (defun my/lazytab-orgtbl-edit ()
    (interactive)
    (when (memq major-mode '(LaTeX-mode latex-mode org-mode))
      (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
      (orgtbl-mode 1)
      (open-line 1)
      (insert "\n|")))
  (add-hook 'cdlatex-tab-hook #'lazytab-cdlatex-or-orgtbl-next-field 90))

;; Edit quiver generated tikzcd using the link given.
(defun replace-quiver-diagram ()
  "Extracts the quiver URL from the diagram under cursor and runs it in browser.  Selects the diagram."
  (interactive)
  (let ((start 0)
	    (end 0)
	    (url-start 0)
	    (url-end 0)
	    (url ""))
    (save-excursion
	  (save-excursion
	    (re-search-backward "% https://q.uiver.app" nil)
	    (setq url-start (+ 2 (point)))
	    (beginning-of-line)
	    (setq start (point))
	    (save-excursion
	      (re-search-forward "\\\\end{tikzcd}" nil)
	      (setq end (point)))
	    (save-excursion
	      (goto-char url-start)
	      (re-search-forward "\n" nil)
	      (setq url-end (- (point) 1))
	      (skip-chars-forward " ")
	      ;; If the next two symbols after new line, up to whitespace,
	      ;; are "\[", modify the `end` value to be after \].
	      (when (string= "[" (string (char-after (+ 1 (point)))))
	        (setq end (+ 2 end))))
	    (setq url (buffer-substring-no-properties url-start url-end))
	    (start-process "" nil
		               ;; Edit this line to change the browser.
		               "open" "-a" "Firefox" url)))
    (goto-char start)
    (push-mark end t t)))

(leaf typst-ts-mode :ensure t
  :bind
  (:typst-ts-mode-map
   ("C-c C-c" . typst-ts-tmenu))
  :config
  (setq typst-ts-mode-enable-raw-blocks-highlight t
        typst-ts-preview-function 'find-file-other-window))

(leaf typst-preview :ensure t
  :bind
  (:typst-ts-mode-map
   ("C-c C-j" . typst-preview-send-position)
   ("C-c C-l" . typst-preview-mode))
  :custom
  (typst-preview-browser . "xwidget")
  (typst-preview-invert-colors . "auto")
  (typst-preview-executable . "tinymist")
  (typst-preview-partial-rendering . t)

  :config
  (setq typst-preview-autostart t)
  (setq typst-preview-open-browser-automatically t))

(leaf c-ts-mode
  :hook
  ((c-ts-mode-hook c++-ts-mode-hook) . eglot-ensure)
  :init
  (setq c-ts-mode-indent-offset 2)
  (setq-default c-basic-offset 2)
  (when (boundp 'major-mode-remap-alist)
    (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
    (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
    (add-to-list 'major-mode-remap-alist
                 '(c-or-c++-mode . c-or-c++-ts-mode))))

(leaf python
  :hook
  (inferior-python-mode-hook . (lambda ()
                                 (process-query-on-exit-flag
                                  (get-process "Python"))))
  :init
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)
  :config
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  ;; Default to Python 3. Prefer the versioned Python binaries since some
  ;; systems stupidly make the unversioned one point at Python 2.
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3")))

(leaf haskell-mode
  :ensure t
  
  :hook (haskell-mode-hook . (lambda ()
                               (haskell-collapse-mode)
                               (interactive-haskell-mode)
                               (turn-on-haskell-doc)))
  :mode (("\\.hs\\'" . haskell-mode))
  :bind ("C-c C-z" . run-haskell)
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t)
  (add-to-list 'completion-ignored-extensions ".hi"))

;; (leaf haskell-ts-mode
;;   :ensure t
;;   :leaf-defer t
;;   :custom
;;   (haskell-ts-font-lock-level . 4)
;;   (haskell-ts-use-indent t)
;;   (haskell-ts-ghci "ghci")
;;   (haskell-ts-use-indent t)
;;   :config
;;   (add-to-list 'major-mode-remap-alist '(haskell-mode . haskell-ts-mode)))

(leaf rust-mode :ensure t
  :config
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

(leaf ron-mode :ensure t
  :mode ("\\.ron" . ron-mode))

(leaf tuareg :ensure t
  :config
  (setq tuareg-prettify-symbols-full t))

(leaf opam-switch-mode :ensure t
  :blackout t
  :hook (tuareg-mode-hook . opam-switch-mode)
  :config
  (setq tuareg-opam-insinuate t))

(leaf ocp-indent :ensure t
  :blackout t
  :hook (tuareg-mode-hook . ocp-setup-indent))

(leaf utop
  :ensure t)

(leaf racket-mode :ensure t)

(leaf zig-ts-mode :ensure t)

(leaf eglot
  :commands (eglot eglot-ensure)
  :hook
  (prog-mode-hook
   . (lambda ()
       (unless (derived-mode-p
                'dotenv-mode 'fish-mode
                'caddyfile-mode 'elvish-mode
                'emacs-lisp-mode 'lisp-mode
                'makefile-mode 'snippet-mode
                'lisp-data-mode 'ron-mode)
         (eglot-ensure))))
  ((markdown-mode-hook yaml-mode-hook yaml-ts-mode-hook
                       LaTeX-mode-hook typst-ts-mode-hook)
   . eglot-ensure)
  :defvar eglot-server-programs
  :bind (:eglot-mode-map
	     ("C-c c a" . eglot-code-actions))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format 'short)
        eglot-send-changes-idle-time 0.5
        eglot-code-action-indications '(eldoc-hint))

  (dolist (mode '(((typst-ts-mode) "tinymist")
                  ((LaTeX-mode) "texlab")))
    (add-to-list 'eglot-server-programs mode)))

(leaf consult-eglot :ensure t
  :after eglot consult
  :bind
  (:eglot-mode-map
   :package eglot
   ([remap xref-find-apropos] . consult-eglot-symbols))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (leaf consult-eglot-embark :ensure t
    :after eglot consult
    :global-minor-mode consult-eglot-embark-mode))

(leaf ocaml-eglot :ensure t
  :blackout t
  :hook
  (tuareg-mode-hook . ocaml-eglot)
  (ocaml-eglot-mode-hook . eglot-ensure))

(leaf nerd-icons
  :ensure (nerd-icons :host github :repo "rainstormstudio/nerd-icons.el"))

(leaf nerd-icons-dired :ensure t
  :blackout t
  :hook (dired-mode-hook . nerd-icons-dired-mode))

(leaf nerd-icons-completion :ensure t
  :config (nerd-icons-completion-marginalia-setup))

(leaf nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))

(leaf nerd-icons-corfu :ensure t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
