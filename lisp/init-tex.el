;; -*- lexical-binding: t; -*-

(leaf latex
  :after tex
  :elpaca (auctex :repo "https://code.200568.top/mirrors/auctex" :branch "master"
                  :pre-build (("./autogen.sh")
                              ("./configure" "--without-texmf-dir" "--with-lispdir=.")
                              ("make")))
  ;; :elpaca (auctex :type git :host nil :repo "https://git.savannah.gnu.org/git/auctex.git")
  :defvar (TeX-auto-save
           TeX-parse-self
           TeX-electric-escape
           TeX-PDF-mode
           TeX-DVI-via-PDFTeX
           TeX-clean-confirm
           TeX-source-correlate-mode
           TeX-source-correlate-method
           TeX-display-help
           TeX-show-compilation
           TeX-command-extra-options
           TeX-view-program-selection)
  :mode (("\\.tex\\'" . LaTeX-mode))
  :hook ((LaTeX-mode-hook . prettify-symbols-mode)
         (LaTeX-mode . visual-line-mode)
         (LaTeX-mode . lsp-deferred)
         (LaTeX-mode . (lambda () (lsp-ui-mode -1)))
         (LaTeX-mode . (lambda () (apheleia-mode -1))))
  :bind (:LaTeX-mode-map
         ("C-S-e" . latex-math-from-calc)
         ("C-c x" . TeX-clean))
  :custom
  (TeX-auto-save . t)
  (TeX-parse-self . t)
  (TeX-PDF-mode . t)
  (TeX-DVI-via-PDFTeX . t)
  (TeX-clean-confirm . nil)
  (TeX-save-query . nil)
  (TeX-source-correlate-mode . t)
  (TeX-source-correlate-method . 'synctex)
  (TeX-display-help . t)
  (TeX-show-compilation . nil)
  (TeX-command-extra-options . "-shell-escape")
  (TeX-view-program-selection . '((output-pdf "displayline")))
  :config
  (add-hook 'LaTeX-mode-hook '(lambda ()
                                (setq TeX-command-default "LaTeXMk")))

  (setq-default LaTeX-indent-environment-list nil)

  (defun latex-math-from-calc ()
    "Evaluate `calc' on the contents of line at point."
    (interactive)
    (cond ((region-active-p)
           (let* ((beg (region-beginning))
                  (end (region-end))
                  (string (buffer-substring-no-properties beg end)))
             (kill-region beg end)
             (insert (calc-eval `(,string calc-language latex
                                          calc-prefer-frac t
                                          calc-angle-mode rad)))))
          (t (let ((l (thing-at-point 'line)))
               (end-of-line 1) (kill-line 0)
               (insert (calc-eval `(,l
                                    calc-language latex
                                    calc-prefer-frac t
                                    calc-angle-mode rad)))))))
  ;; (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  ;; (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

  (leaf texpresso
    :commands texpresso 
    :elpaca (texpresso :host github :repo "let-def/texpresso" :files ("emacs/*.el"))
    :hook (texpresso-mode-hook . texpresso-sync-mode)
    :custom
    (texpresso-follow-cursor . t)
    :bind (:LaTeX-mode-map
           ("C-c C-p" . texpresso)
           ("S-s-<mouse-1>" . texpresso-move-to-cursor))))

(leaf reftex
  :after latex
 
  :commands turn-on-reftex
  :hook ((latex-mode-hook LaTeX-mode-hook) . turn-on-reftex)
  :config
  (setf (alist-get "\\*RefTex" display-buffer-alist nil t #'equal)
        '((display-buffer-in-side-window)
          (window-height . 0.25)
          (side . bottom) (slot . -9)))
  (setq reftex-default-bibliography '("~/Documents/roam/biblio.bib"))
  (setq reftex-insert-label-flags '("sf" "sfte"))
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-ref-style-default-list '("Default" "AMSmath" "Cleveref"))
  (setq reftex-use-multiple-selection-buffers t))

(leaf consult-reftex
  :elpaca (consult-reftex :host github :repo "karthink/consult-reftex")
  ;; :load-path "plugins/consult-reftex/"
  :after (reftex consult embark)
  :bind
  (:reftex-mode-map
   ("C-c )"   . consult-reftex-insert-reference)
   ("C-c M-." . consult-reftex-goto-label))
  (:org-mode-map
   ("C-c (" . consult-reftex-goto-label)
   ("C-c )"   . consult-reftex-insert-reference)))

(leaf cdlatex
  :elpaca t
  :after latex
  :hook ((LaTeX-mode-hook . turn-on-cdlatex)
         (LaTeX-mode . cdlatex-electricindex-mode))
  ;; :bind (:cdlatex-mode-map
  ;;             ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-math-symbol-alist '((?f ("\\varphi" "\\phi"))
                                    (?i ("\\iota"))
                                    (?c ("\\circ"))
                                    ))
  (setq cdlatex-math-modify-alist '((?f "\\mathbb" nil t nil nil)
                                    (?O "\\overset" nil t nil nil)))

  (defun tjh/cdlatex-yas-expand ()
    "Resolve the conflict between cdlatex and yasnippet. When this
function returns true, the default `cdlatex-tab` will not be
executed. The effect of function is to first try yasnippet
expansion, then cdlatex expansion."
    (interactive)
    (if (or (bound-and-true-p yas-minor-mode)
            (bound-and-true-p yas-global-mode))
        (if (yas-expand)
            t
          nil)
      nil))
  (add-hook 'cdlatex-tab-hook 'tjh/cdlatex-yas-expand)
  (cdlatex-reset-mode))

(leaf lazytab
  :elpaca '(lazytab :type git :host github :repo "karthink/lazytab" :files ("*.el"))
  :leaf-defer nil
  :after cdlatex
  :bind (:org-mode-map
         ("C-x |" . my/lazytab-orgtbl-edit))
  :bind (:orgtbl-mode-map
         ("<tab>" . lazytab-org-table-next-field-maybe)
         ("TAB" . lazytab-org-table-next-field-maybe))
  :config
  (defun my/lazytab-orgtbl-edit ()
    (interactive)
    (when (memq major-mode '(LaTeX-mode latex-mode org-mode))
      (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
      (orgtbl-mode 1)
      (open-line 1)
      (insert "\n|")))
  (add-hook 'cdlatex-tab-hook #'lazytab-cdlatex-or-orgtbl-next-field 90))

(leaf lazytab
  :after latex
  :bind (:LaTeX-mode-map
         ("C-x |" . my/lazytab-orgtbl-edit)))

(leaf citar
  :elpaca t
  :after latex
 
  :bind
  (:LaTeX-mode-map
   ("C-c ]" . citar-insert-citation))
  (:org-mode-map
   ("C-c C-x ]" . citar-insert-citation))
  :config
  (delete citar-indicator-cited citar-indicators)
  (setq citar-bibliography ;; '("~/Documents/research/control_systems.bib")
        `(,(expand-file-name "~/Documents/roam/biblio.bib"))
        citar-at-point-function 'embark-act
        citar-file-open-function #'consult-file-externally)
  
  (leaf cdlatex
    :config
    (defun my/cdlatex-bibtex-action ()
      "Call `citar-insert-citation' interactively."
      (call-interactively 'citar-insert-citation))
    (setf (alist-get "cite" cdlatex-command-alist nil nil 'equal)
          '("Make a citation interactively"
            "" my/cdlatex-bibtex-action nil t nil))
    (setf (alist-get "cite{" cdlatex-command-alist nil nil 'equal)
          '("Make a citation interactively"
            "cite{" my/cdlatex-bibtex-action nil t nil))))

(leaf citar-embark
  :elpaca t
  :after (citar embark)
  :config
  (citar-embark--enable))

;; Edit quiver generated tikzcd using the link given.
(defun replace-quiver-diagram ()
  "Extracts the quiver URL from the diagram under cursor and runs it in browser. Selects the diagram."
  (interactive)
  (let ((start 0)
	    (end 0)
	    (url-start 0)
	    (url-end 0)
	    (url ""))
    (save-excursion
	  (save-excursion
	    (re-search-backward "% https://q.uiver.app" nil)
	    (setq url-start (+ 2 (point)))
	    (beginning-of-line)
	    (setq start (point))
	    (save-excursion
	      (re-search-forward "\\\\end{tikzcd}" nil)
	      (setq end (point)))
	    (save-excursion
	      (goto-char url-start)
	      (re-search-forward "\n" nil)
	      (setq url-end (- (point) 1))
	      (skip-chars-forward " ")
	      ;; If the next two symbols after new line, up to whitespace,
	      ;; are "\[", modify the `end` value to be after \].
	      (when (string= "[" (string (char-after (+ 1 (point)))))
	        (setq end (+ 2 end))))
	    (setq url (buffer-substring-no-properties url-start url-end))
	    (start-process "" nil
		               ;; Edit this line to change the browser.
		               "open" "-a" "Firefox" url)))
    (goto-char start)
    (push-mark end t t)))


(provide 'init-tex)
