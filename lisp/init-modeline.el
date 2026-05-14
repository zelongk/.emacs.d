;; init-modeline --- Setup emacs modeline -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; Modeline


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;       Copied from prots emacs       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Flymake errors, warnings, notes
(declare-function flymake--severity "flymake" (type))
(declare-function flymake-diagnostic-type "flymake" (diag))

;; Based on `flymake--mode-line-counter'.
(defun prot-modeline-flymake-counter (type)
  "Compute number of diagnostics in buffer with TYPE's severity.
TYPE is usually keyword `:error', `:warning' or `:note'."
  (let ((count 0))
    (dolist (d (flymake-diagnostics))
      (when (= (flymake--severity type)
               (flymake--severity (flymake-diagnostic-type d)))
        (cl-incf count)))
    (when (cl-plusp count)
      (number-to-string count))))

(defvar prot-modeline-flymake-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] 'flymake-show-buffer-diagnostics)
    (define-key map [mode-line down-mouse-3] 'flymake-show-project-diagnostics)
    map)
  "Keymap to display on Flymake indicator.")

(defmacro prot-modeline-flymake-type (type indicator &optional face)
  "Return function that handles Flymake TYPE with stylistic INDICATOR and FACE."
  `(defun ,(intern (format "prot-modeline-flymake-%s" type)) ()
     (when-let* ((count (prot-modeline-flymake-counter
                         ,(intern (format ":%s" type)))))
       (concat
        (propertize ,indicator 'face 'prot-modeline-indicator-gray)
        (propertize count
                    'face ',(or face type)
                    'mouse-face 'mode-line-highlight
                    ;; FIXME 2023-07-03: Clicking on the text with
                    ;; this buffer and a single warning present, the
                    ;; diagnostics take up the entire frame.  Why?
                    'local-map prot-modeline-flymake-map
                    'help-echo "mouse-1: buffer diagnostics\nmouse-3: project diagnostics")))))

(prot-modeline-flymake-type error "☣")
(prot-modeline-flymake-type warning "!")
(prot-modeline-flymake-type note "·" success)

(defvar-local prot-modeline-flymake
  '(:eval
    (when (and (bound-and-true-p flymake-mode)
               (mode-line-window-selected-p))
      (list
       '(:eval (prot-modeline-flymake-error))
       '(:eval (prot-modeline-flymake-warning))
       '(:eval (prot-modeline-flymake-note))))))


;; Why is this not working?
(setq-default mode-line-format
              '("%e" mode-line-front-space
                (:propertize
                 ("" mode-line-client mode-line-window-dedicated)
                 display (min-width (6.0)))
                mode-line-frame-identification mode-line-buffer-identification "   "
                mode-line-position (project-mode-line project-mode-line-format)
                "  " mode-line-modes mode-line-misc-info

                mode-line-format-right-align
                
                (vc-mode vc-mode)
                prot-modeline-flymake
                
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


(provide 'init-modeline)
;;; init-modeline.el ends here
