;; -*- lexical-binding: t; -*-

(use-package magit
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
  (elemacs-load-packages-incrementally '(dash f s with-editor eieio transient git-commit llama))
  (setq magit-show-long-lines-warning nil))

;; Prime cache before Magit refresh
(use-package magit-prime
  :diminish
  :config
  (magit-prime-mode))

;; Show TODOs in Magit
(use-package magit-todos
  :after magit-status
  :hook magit
  :commands magit-todos-mode
  :init
  (setq magit-todos-nice (if (executable-find "nice") t nil)))

;; Walk through git revisions of a file
(use-package git-timemachine
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
  :ensure nil
  :diminish
  :pretty-hydra
  ((:title (pretty-hydra-title "Smerge" 'octicon "nf-oct-diff")
           :color pink :quit-key ("q" "C-g"))
   ("Move"
    (("n" smerge-next "next")
     ("p" smerge-prev "previous"))
    "Keep"
    (("b" smerge-keep-base "base")
     ("u" smerge-keep-upper "upper")
     ("l" smerge-keep-lower "lower")
     ("a" smerge-keep-all "all")
     ("RET" smerge-keep-current "current")
     ("C-m" smerge-keep-current "current"))
    "Diff"
    (("<" smerge-diff-base-upper "upper/base")
     ("=" smerge-diff-upper-lower "upper/lower")
     (">" smerge-diff-base-lower "upper/lower")
     ("R" smerge-refine "refine")
     ("E" smerge-ediff "ediff"))
    "Other"
    (("C" smerge-combine-with-next "combine")
     ("r" smerge-resolve "resolve")
     ("k" smerge-kill-current "kill")
     ("ZZ" (lambda ()
             (interactive)
             (save-buffer)
             (bury-buffer))
      "Save and bury buffer" :exit t))))
  :bind (:map smerge-mode-map
              ("C-c m" . smerge-mode-hydra/body))
  :hook ((find-file . (lambda ()
                        (save-excursion
                          (goto-char (point-min))
                          (when (re-search-forward "^<<<<<<< " nil t)
                            (smerge-mode 1)))))
         (magit-diff-visit-file . (lambda ()
                                    (when smerge-mode
                                      (smerge-mode-hydra/body))))))


(provide 'init-vcs)
