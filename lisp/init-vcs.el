;; init-vcs --- version control system -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf diff-mode)

(leaf ediff)

(leaf diff-hl :ensure t
  :global-minor-mode
  global-diff-hl-mode
  diff-hl-flydiff-mode
  :custom
  (diff-hl-draw-borders . nil)
  (diff-hl-update-async . 'thread)
  (diff-hl-flydiff-delay . 0.5)
  :hook
  (magit-post-refresh-hook . diff-hl-magit-post-refresh)
  (dired-mode-hook . diff-hl-dired-mode)
  :config
  ;; (setq-default fringes-outside-margins t)
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

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

(provide 'init-vcs)
;;; init-vcs.el ends here
