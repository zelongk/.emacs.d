;; -*- lexical-binding: t; -*-

(use-package latex
  :ensure (auctex :pre-build (("./autogen.sh")
			                        ("./configure" "--without-texmf-dir" "--with-lispdir=.")
                              ("make")))
  :mode (("\\.tex\\'" . LaTeX-mode))
  :hook (LaTeX-mode . prettify-symbols-mode)
  :hook (LaTeX-mode . visual-line-mode)
  :hook (LaTeX-mode . turn-on-reftex)
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc))
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
  :config
  (add-hook 'LaTeX-mode-hook (lambda ()
                               (setq TeX-command-default "LaTeXMk")))
  ;; Format math as a Latex string with Calc
  (add-hook 'LaTeX-mode-hook #'eglot-ensure)
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
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

  (setq reftex-plug-into-AUCTeX t)

  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((LaTeX-mode latex-mode) "texlab"))))


(use-package cdlatex
  :diminish
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  ;; :bind (:map cdlatex-mode-map
  ;;             ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-math-symbol-alist '((?f ("\\varphi" "\\phi"))
                                    (?i ("\\iota"))
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
  (add-hook 'cdlatex-tab-hook 'tjh/cdlatex-yas-expand))

(use-package texpresso
  :defer nil
  :load-path "~/.emacs.d/lisp/packages/")

(provide 'init-tex)
