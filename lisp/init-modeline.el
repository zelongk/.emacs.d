;; init-modeline --- Setup emacs modeline -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; Modeline


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;       Copied from prots emacs       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-modeline-vc-map
  (let ((map (make-sparse-keymap)))
    ;; Left click shows diff for the current file
    (define-key map [mode-line down-mouse-1] #'vc-diff)
    ;; Right click shows diff for the entire project/repo
    (define-key map [mode-line down-mouse-3] #'vc-root-diff)
    map)
  "Keymap for the VC branch mode-line indicator.")
;; 2. Helper to map VC states to built-in Emacs VC faces
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
;; 3. Helper to reliably get just the branch name
(defun my-modeline-vc-branch-name (file backend)
  "Return the VC branch name or short hash for FILE with BACKEND."
  (when-let ((rev (vc-working-revision file backend)))
    (if (eq backend 'Git)
        ;; For Git, try to get the actual branch name, fallback to short hash
        (or (vc-git--symbolic-ref file)
            (substring rev 0 7))
      ;; For other backends (SVN, Hg, etc.), just use the revision number
      rev)))
;; 4. Core function to generate the propertized string
(defun my-modeline-vc-string ()
  "Generate the string for the VC mode-line indicator."
  ;; Only render if the current window is focused
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
;; 5. Define the mode-line variable
(defvar-local my-modeline-vc-branch
  '(:eval (my-modeline-vc-string))
  "Mode line construct to display propertized VC branch.")

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
      (push " " segments)

      ;; Build the Warning string
      (when (> warn 0)
        (push (propertize (format " [P] %d " warn)
                          'face 'warning
                          'help-echo "Warnings\nmouse-1: buffer diagnostics\nmouse-3: project diagnostics"
                          'local-map my-modeline-flymake-map
                          'mouse-face 'mode-line-highlight)
              segments))
      (push " " segments)
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
    ;; (undo-tree-mode . " ⎌")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (python-mode . "Py")
    (haskell-mode . "Hs")
    (emacs-lisp-mode . "Eλ")
    (nxhtml-mode . "nx")
    (scheme-mode . " SCM")
    (matlab-mode . "M")
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

(provide 'init-modeline)
;;; init-modeline.el ends here
