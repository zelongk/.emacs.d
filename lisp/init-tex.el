;; -*- lexical-binding: t; -*-

(use-package latex
  :after tex
  :ensure (auctex :pre-build (("./autogen.sh")
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
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . lsp-deferred)
         (LaTeX-mode . (lambda () (lsp-ui-mode -1)))
         (LaTeX-mode . (lambda () (apheleia-mode -1))))
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc)
              ("C-c x" . TeX-clean)
              ("S-s-<mouse-1>" . TeX-view))
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


  ;; Format math as a Latex string with Calc
  ;; (add-hook 'LaTeX-mode-hook #'eglot-ensure)

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

  ;; (with-eval-after-load 'eglot
  ;;   (add-to-list 'eglot-server-programs '((LaTeX-mode latex-mode) "texlab")))

  (setq reftex-plug-into-AUCTeX t)
  (use-package texpresso
    :ensure (:host github :repo "let-def/texpresso" :files ("emacs/*.el"))
    :hook (texpresso-mode . texpresso-sync-mode)
    :after auctex
    :bind (:map LaTeX-mode-map
                ("C-c C-p" . texpresso)))
  )

(use-package cdlatex
  :diminish
  :hook (LaTeX-mode . turn-on-cdlatex)
  ;; :bind (:map cdlatex-mode-map
  ;;             ("<tab>" . cdlatex-tab))
  :config
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
  :demand t
  :after cdlatex latex
  :ensure '(lazytab :type git :host github :repo "karthink/lazytab" :files ("*.el"))
  :bind (:map LaTeX-mode-map
              ("C-x |" . (lambda () (interactive) (lazytab-position-cursor-and-edit))))
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB" . lazytab-org-table-next-field-maybe))
  :config
  (add-hook 'cdlatex-tab-hook #'lazytab-cdlatex-or-orgtbl-next-field 90)
  (dolist (cmd '(("smat" "Insert smallmatrix env"
                  "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("bmat" "Insert bmatrix env"
                  "\\begin{bmatrix} ? \\end{bmatrix}"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("pmat" "Insert pmatrix env"
                  "\\begin{pmatrix} ? \\end{pmatrix}"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("ali" "Insert pmatrix env"
                  "\\begin{aligned} ? \\end{aligned}"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("tbl" "Insert table"
                  "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                  lazytab-position-cursor-and-edit
                  nil t nil)))
    (push cmd cdlatex-command-alist))
  (cdlatex-reset-mode)
  )

(provide 'init-tex)
