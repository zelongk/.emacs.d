;; init-modeline --- Setup emacs modeline -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; Modeline


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;       Copied from prots emacs       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
      (push (propertize (format "[I] %d" note)
                        'face 'success
                        'help-echo "Notes\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                        'local-map my-modeline-flymake-map
                        'mouse-face 'mode-line-highlight)
            segments)
      (push " " segments)

      ;; Build the Warning string
      (push (propertize (format "[P] %d" warn)
                        'face 'warning
                        'help-echo "Warnings\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                        'local-map my-modeline-flymake-map
                        'mouse-face 'mode-line-highlight)
            segments)
      (push " " segments)
      ;; Build the Error string
      (push (propertize (format "[C] %d" err)
                        'face 'error
                        'help-echo "Errors\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                        'local-map my-modeline-flymake-map
                        'mouse-face 'mode-line-highlight)
            segments)
      
      ;; Combine them and return. (Using nreverse because `push` prepends items)
      (if segments
          (apply #'concat (nreverse segments))
        ""))))
;; 4. Define the mode-line variable
(defvar-local my-modeline-flymake
  '(:eval (my-modeline-flymake-string))
  "Mode line construct displaying Flymake diagnostic counts.")
;; IMPORTANT: Emacs requires custom mode-line variables that contain
;; properties (like colors or clickable areas) to be marked as risky!


(with-eval-after-load 'eglot
  (setq mode-line-misc-info
        (delete '(eglot--managed-mode (" [" eglot--mode-line-format "] ")) mode-line-misc-info)))

(defvar-local prot-modeline-eglot
  `(:eval
    (when (and (featurep 'eglot) (mode-line-window-selected-p))
      '(eglot--managed-mode eglot--mode-line-format)))
  "Mode line construct displaying Eglot information.
Specific to the current window's mode line.")

(dolist (construct '(my-modeline-flymake
                     prot-modeline-eglot))
  (put construct 'risky-local-variable t))

;; Why is this not working?
(setq-default mode-line-format
              '("%e" mode-line-front-space
                (:propertize
                 ("" mode-line-client mode-line-window-dedicated)
                 display (min-width (6.0)))
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                "  " mode-line-modes

                mode-line-format-right-align
                
                (vc-mode vc-mode)
                "   "
                my-modeline-flymake
                prot-modeline-eglot
                ;; mode-line-misc-info
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
    (org-mode . " ⦿") ;; "⦿"
    (valign-mode . "")
    (eldoc-mode . "")
    (org-cdlatex-mode . "")
    (cdlatex-mode . "")
    (org-indent-mode . "")
    (org-roam-mode . "")
    (visual-line-mode . "")
    (latex-mode . "TeX")
    (outline-minor-mode . " ֍") ;; " [o]"
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


(provide 'init-modeline)
;;; init-modeline.el ends here
