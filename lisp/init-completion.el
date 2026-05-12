;;; init-completion.el --- Initialize completion configurations.	-*- lexical-binding: t -*-

;; Optionally use the `orderless' completion style.
(leaf orderless
  :ensure t
  :require t
  :config
  (defun orderless-fast-dispatch (word index total)
    (and (= index 0) (= total 1) (length< word 5)
         ;; `(orderless-regexp . ,(concat "^" (regexp-quote word)))
         (cons 'orderless-literal-prefix word)))
  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '(orderless-fast-dispatch
                                   orderless-affix-dispatch))
    (orderless-matching-styles '(orderless-literal orderless-regexp)))
  (setq completion-styles '(orderless partial-completion basic))
  (setf (alist-get ?~ orderless-affix-dispatch-alist nil 'remove) nil
        (alist-get ?` orderless-affix-dispatch-alist) #'orderless-flex))

;; Support Pinyin
(leaf pinyinlib
  :ensure t
  :after orderless
  :require t
  :commands orderless-regexp
  :leaf-autoload pinyinlib-build-regexp-string
  :init
  (defun orderless-regexp-pinyin (str)
    "Match COMPONENT as a pinyin regex."
    (orderless-regexp (pinyinlib-build-regexp-string str)))
  (add-to-list 'orderless-matching-styles 'orderless-regexp-pinyin))

;; VERTical Interactive COmpletion
(leaf vertico
  :ensure t
  :custom (vertico-count . 15)
  :bind
  ((:vertico-map
    ("RET" . vertico-directory-enter)
    ("DEL" . vertico-directory-delete-char)
    ("M-DEL" . vertico-directory-delete-word)))
  :global-minor-mode vertico-mode
  :hook ((rfn-eshadow-update-overlay-hook . vertico-directory-tidy)
         (vertico-mode-hook . vertico-multiform-mode))
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


;; Enrich existing commands with completion annotations
(leaf marginalia :ensure t
  :global-minor-mode marginalia-mode
  :config
  (leaf nerd-icons-completion :ensure t
    :init (nerd-icons-completion-marginalia-setup)))


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

(leaf embark-consult :ensure t
  :bind
  (:minibuffer-local-map
   ("C-c C-o" . embark-export)
   ("C->" . embark-become)
   ("M-*" . embark-act-all))
  :hook (embark-collect-mode-hook . consult-preview-at-point-mode))

(leaf embark :ensure t
  :leaf-defer nil
  :commands embark-prefix-help-command
  :bind
  (("M-SPC"   . embark-act)
   ("M-*"   . embark-act-all)
   ("M-S-SPC"   . embark-select)
   ("S-<return>"   . embark-dwim)        ; overrides `xref-find-definitions'
   ([remap describe-bindings] . embark-bindings))
  (:minibuffer-local-map
   ("M-." . my-embark-preview))
  (:embark-file-map
   ("S"        . sudo-find-file)
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


;; Consulting completing-read
(leaf consult :ensure t
  :commands consult-customize
  :bind
  (([remap Info-search]        . consult-info)
   ;; ([remap isearch-forward]    . consult-line)
   ([remap recentf-open-files] . consult-recent-file)
   ([remap bookmark-jump] . consult-bookmark)
   ("C-." . consult-imenu)
   ("C-c T" . consult-theme)
   
   ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
   
   ;; Custom M-# bindings for fast register access
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)

   
   ;; Other custom bindings
   ("M-y" . consult-yank-pop)                ;; orig. yank-pop
   
   ;; M-g bindings in `goto-map'
   ("M-g e" . consult-compile-error)
   ("M-g r" . consult-grep-match)
   ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
   ("M-g g" . consult-goto-line)             ;; orig. goto-line
   ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
   ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)

   ;; M-g bindings in `search-map'
   ("s-f" . consult-line)
   ("M-g d" . consult-find)                  ;; Alternative: consult-fd
   ("M-g c" . consult-locate)
   ("M-g G" . consult-git-grep)
   ("M-g r" . consult-ripgrep)
   ("M-g l" . consult-line)
   ("M-g L" . consult-line-multi)
   ("M-g k" . consult-keep-lines)
   ("M-g u" . consult-focus-lines)
   ("C-x C-r" . consult-recent-file)
   ("C-x b" . consult-buffer)

   ("M-g e" . consult-isearch-history))
  (:isearch-mode-map
   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
   ("M-g e" . consult-isearch-history)       ;; orig. isearch-edit-string
   ("M-g l" . consult-line)                  ;; needed by consult-line to detect isearch
   ("M-g L" . consult-line-multi))
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :init
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

(provide 'init-completion)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-completion.el ends here
