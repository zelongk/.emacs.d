;; -*- lexical-binding: t; -*-

(use-package vc
  :defer t)

(use-package diff-mode
  :defer t)

(use-package ediff
  :defer t)

(use-package diff-hl
  :ensure t
  :defer t
  :diminish
  :custom
  (diff-hl-draw-borders nil)
  (diff-hl-update-async 'thread)
  (diff-hl-flydiff-delay 0.5)
  :hook ((vc-responsible-backend diff-hl-mode)
         (dlff-hl-mode diff-hl-flydiff-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode))
  :config
  ;; (setq-default fringes-outside-margins t)
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

(use-package magit
  :ensure (magit :repo "magit/magit" :tag "v4.5.0")
  :defer t
  :bind (("C-c g" . magit-dispatch))
  :custom
  (magit-diff-refine-hunk t)
  (git-commit-major-mode 'git-commit-elisp-text-mode)
  (magit-tramp-pipe-stty-settings 'pty)
  :config
  (use-package magit-section
    :bind (:map magit-section-mode-map
                ("," . magit-section-up))
    :config
    (setq magit-section-initial-visibility-alist
          '((stashes . hide)
            ([file unstaged status] . hide))))
  (setq magit-show-long-lines-warning nil))

;; Show TODOs in Magit
(use-package magit-todos
  :after magit-status
  :hook magit
  :commands magit-todos-mode
  :init
  (setq magit-todos-nice (if (executable-find "nice") t nil)))

;; Walk through git revisions of a file
(use-package git-timemachine
  :after vc
  :custom-face
  (git-timemachine-minibuffer-author-face ((t (:inherit success :foreground unspecified))))
  (git-timemachine-minibuffer-detail-face ((t (:inherit warning :foreground unspecified))))
  :bind (:map vc-prefix-map
              ("t" . git-timemachine))
  :hook ((git-timemachine-mode . (lambda ()
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

(use-package smerge-mode
  :defer t
  :diminish
  :hook ((find-file . (lambda ()
                        (save-excursion
                          (goto-char (point-min))
                          (when (re-search-forward "^<<<<<<< " nil t)
                            (smerge-mode 1)))))))

(use-package smerge-mode
  :hook ((magit-diff-visit-file . (lambda ()
                                    (when smerge-mode
                                      (smerge-dispatch-menu)))))
  :bind (:map smerge-mode-map
              ("C-c m" . smerge-dispatch-menu))
  
  :config
  (transient-define-prefix smerge-dispatch-menu ()
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
