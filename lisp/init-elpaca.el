;; init-elpaca --- A modern package manager -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;;;;;;;;;;;; elpaca initialise ;;;;;;;;;;;;;;;;;;
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(when (eq system-type 'windows-nt)
  (elpaca-no-symlink-mode))

;; Install leaf support
;; (elpaca elpaca-use-package
;;   ;; Enable leaf :ensure support for Elpaca.
;;   (elpaca-use-package-mode))

;; (setq leaf-verbose nil
;;       leaf-compute-statistics nil
;;       ;; leaf-ignore-unknown-keywords t
;;       leaf-minimum-reported-time 0.01
;;       leaf-expand-minimally t
;;       leaf-enable-imenu-support t)

(defmacro elpaca-leaf (order &rest body)
  "Execute BODY in `leaf' declaration after ORDER is finished.
If the :disabled keyword is present in body, the package is completely ignored.
This happens regardless of the value associated with :disabled.
The expansion is a string indicating the package has been disabled."
  (declare (indent 1))
  (if (memq :disabled body)
      (format "%S :disabled by elpaca-leaf" order)
    (let ((o order))
      (when-let ((ensure (seq-position body :ensure)))
	    (setq o (if (null (nth (1+ ensure) body)) nil order)
	          body (append (seq-subseq body 0 ensure)
			               (seq-subseq body (+ ensure 2)))))
      `(elpaca ,o (leaf
		            ,(if-let (((memq (car-safe order) '(quote \`)))
			                  (feature (flatten-tree order)))
			             (cadr feature)
		               (elpaca--first order))
		            ,@body)))))

(elpaca-leaf leaf
             :init
             (require 'leaf))
(elpaca-leaf leaf-keywords
             :init
             (require 'leaf-keywords)
             (leaf-keywords-init))

(setq leaf-expand-minimally t
      leaf-enable-imenu-support t)
(elpaca-wait)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;When installing a package used in the init file itself,
;;e.g. a package which adds a leaf key word,
;;use the :wait recipe keyword to block until that package is installed/configured.
;;For example:
;;(leaf general :ensure (:wait t) :leaf-defer nil)

(leaf elpaca-ui
  :bind
  (:elpaca-ui-mode-map
   ("p" . previous-line)
   ("F" . elpaca-ui-mark-pull))
  :hook (elpaca-log-mode-hook . elpaca-log-update-mode)
  :after popper
  :init
  (add-to-list 'popper-reference-buffers
               'elpaca-log-mode)
  (setf (alist-get '(major-mode . elpaca-log-mode)
                   display-buffer-alist
                   nil nil #'equal)
        '((display-buffer-at-bottom
           display-buffer-in-side-window)
          (side . below)
          (slot . 49)
          (window-height . 0.4)
          (body-function . select-window))
        (alist-get "\\*elpaca-diff\\*" display-buffer-alist
                   nil nil #'equal)
        '((display-buffer-reuse-window
           display-buffer-in-atom-window)
          (side . right))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'init-elpaca)
;;; init-elpaca.el ends here
