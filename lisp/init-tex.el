;; -*- lexical-binding: t; -*-

(use-package latex
  :after tex
  :ensure (auctex :repo "https://code.200568.top/mirrors/auctex" :branch "master"
                  :pre-build (("./autogen.sh")
                              ("./configure" "--without-texmf-dir" "--with-lispdir=.")
                              ("make")))
  ;; :ensure (auctex :type git :host nil :repo "https://git.savannah.gnu.org/git/auctex.git")
  :defines (TeX-auto-save
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
  :hook ((LaTeX-mode . prettify-symbols-mode)
         (LaTeX-mode . visual-line-mode)
         (LaTeX-mode . lsp-deferred)
         (LaTeX-mode . (lambda () (lsp-ui-mode -1)))
         (LaTeX-mode . (lambda () (apheleia-mode -1))))
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc)
              ("C-c x" . TeX-clean))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-DVI-via-PDFTeX t)
  (TeX-clean-confirm nil)
  (TeX-save-query nil)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-method 'synctex)
  (TeX-display-help t)
  (TeX-show-compilation nil)
  (TeX-command-extra-options "-shell-escape")
  (TeX-view-program-selection '((output-pdf "displayline")))
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

  (use-package texpresso
    :commands texpresso 
    :ensure (:host github :repo "let-def/texpresso" :files ("emacs/*.el"))
    :hook (texpresso-mode . texpresso-sync-mode)
    :custom
    (texpresso-follow-cursor t)
    :bind (:map LaTeX-mode-map
                ("C-c C-p" . texpresso)
                ("S-s-<mouse-1>" . texpresso-move-to-cursor))))

(use-package reftex
  :after latex
  :defer 2
  :commands turn-on-reftex
  :hook ((latex-mode LaTeX-mode) . turn-on-reftex)
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

(use-package consult-reftex
  :ensure (:host github :repo "karthink/consult-reftex")
  ;; :load-path "plugins/consult-reftex/"
  :after (reftex consult embark)
  :bind (:map reftex-mode-map
              ("C-c )"   . consult-reftex-insert-reference)
              ("C-c M-." . consult-reftex-goto-label)
              :map org-mode-map
              ("C-c (" . consult-reftex-goto-label)
              ("C-c )"   . consult-reftex-insert-reference)))

(use-package cdlatex
  :ensure t
  :after latex
  :diminish
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (LaTeX-mode . cdlatex-electricindex-mode))
  ;; :bind (:map cdlatex-mode-map
  ;;             ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-math-symbol-prefix ?\;)
  (setq cdlatex-math-symbol-alist '((?f ("\\varphi" "\\phi"))
                                    (?i ("\\iota"))
                                    (?c ("\\circ"))
                                    ))
  (setq cdlatex-math-modify-alist '((?f "\\mathbb" nil t nil nil)))

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

(use-package lazytab
  :ensure '(lazytab :type git :host github :repo "karthink/lazytab" :files ("*.el"))
  :demand t
  :after cdlatex
  :bind (:map LaTeX-mode-map
              ("C-x |" . (lambda () (interactive) (lazytab-orgtbl-edit))))
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB" . lazytab-org-table-next-field-maybe))
  :config
  (add-hook 'cdlatex-tab-hook #'lazytab-cdlatex-or-orgtbl-next-field 90))

(use-package citar
  :ensure t
  :after latex
  :defer
  :bind (:map LaTeX-mode-map
              ("C-c ]" . citar-insert-citation)
              :map org-mode-map
              ("C-c C-x ]" . citar-insert-citation))
  :config
  (delete citar-indicator-cited citar-indicators)
  (setq citar-bibliography ;; '("~/Documents/research/control_systems.bib")
        `(,(expand-file-name "~/Documents/roam/biblio.bib"))
        citar-at-point-function 'embark-act
        citar-file-open-function #'consult-file-externally)
  
  (use-package cdlatex
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

(use-package citar-embark
  :ensure t
  :after (citar embark)
  :config
  (citar-embark--enable))

(provide 'init-tex)
