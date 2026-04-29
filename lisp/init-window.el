;; -*- lexical-binding: t; -*-
;; Restore old window configurations

(use-package winner
  :commands (winner-undo winner-redo)
  :hook elpaca-after-init
  :init (setq winner-boring-buffers '("*Completions*"
                                      "*Compile-Log*"
                                      "*inferior-lisp*"
                                      "*Fuzzy Completions*"
                                      "*Apropos*"
                                      "*Help*"
                                      "*cvs*"
                                      "*Buffer List*"
                                      "*Ibuffer*"
                                      "*esh command on file*")))

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

(use-package ace-window
  :ensure t
  :hook (emacs-startup . ace-window-display-mode)
  :bind (([remap other-window] . ace-window)
         
         ;; ("C-c w" . ace-window-hydra/body)
         ("M-o" . ace-window)
         ("C-c 2" . split-window-vertically-instead)
         ("C-c 3" . split-window-horizontally-instead)
         ("C-x m" . maximize-window))
  :custom
  (aw-scope 'frame)
  (aw-background nil)
  (aw-display-mode-overlay nil)
  (aw-dispatch-always t)
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

(use-package ace-window
  :after transient ace-window
  :bind ("C-c w" . ace-window-transient-menu) ; Bind as you prefer
  :config
  (transient-define-prefix ace-window-transient-menu ()
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

     ["Layout"
      ("h" "shrink H" shrink-window-horizontally)
      ("j" "enlarge" enlarge-window)
      ("k" "shrink" shrink-window)
      ("l" "enlarge H" enlarge-window-horizontally)
      ("n" "balance" balance-windows)
      ("r" "split right" split-window-right)
      ("v" "split below" split-window-below)]

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

(use-package popper
  :ensure t
  :custom
  (popper-group-function #'popper-group-by-directory)
  (popper-echo-dispatch-actions t)
  :bind (:map popper-mode-map
              ("C-h z"       . popper-toggle)
              ("C-<tab>"     . popper-cycle)
              ("C-M-<tab>"   . popper-toggle-type))
  :hook (emacs-startup . popper-echo-mode)
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
                                            'term-mode
                                            'vterm-mode))))
            (delete-window window)))))
    (advice-add #'keyboard-quit :before #'popper-close-window-hack)))

(provide 'init-window)
;;; init-window.el ends here
