;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                Denote               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n N" . denote-type)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n i" . denote-add-links)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/Documents/notes/"))

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the docstring of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

(use-package consult-denote :ensure t
  :bind (("C-c n f" . consult-denote-find)
         ([remap denote-grep] . consult-denote-grep))
  :config
  (setq consult-denote-grep-command 'consult-ripgrep))

(use-package denote-org :ensure t)
(use-package denote-markdown :ensure t)
(use-package denote-silo :ensure t)
(use-package denote-journal :ensure t
  :bind
  (("C-c n j" . denote-journal-new-or-existing-entry)
   ("C-c n J" . denote-journal-new-entry)))
(use-package denote-sequence :ensure t)
(use-package denote-merge
  :ensure (:host github :repo "protesilaos/denote-merge")
  :bind
  ("C-c n m f" . denote-merge-file)
  ("C-c n m r" . denote-merge-region))
(use-package denote-explore :ensure t
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
   ("C-c n e j r" . denote-explore-rename-keywords)
   ("C-c n e j y" . denote-explore-sync-metadata)
   ("C-c n e j i" . denote-explore-isolated-files)
   ;; Visualise denote
   ("C-c n e n" . denote-explore-network)
   ("C-c n e r" . denote-explore-network-regenerate)
   ("C-c n e d" . denote-explore-barchart-degree)
   ("C-c n e b" . denote-explore-barchart-backlinks)))

(provide 'init-denote)
