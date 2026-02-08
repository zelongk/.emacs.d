;; -*- lexical-binding: t; -*-

(use-package latex
  :ensure (auctex :pre-build (("./autogen.sh")
			      ("./configure" "--without-texmf-dir" "--with-lispdir=.")
                              ("make")))
  :mode (("\\.tex\\'" . LaTeX-mode))
  :hook prettify-symbols-mode
  :hook visual-line-mode
  :hook turn-on-reftex
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc))
  :custom
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-DVI-via-PDFTeX t)
  :config
  (setq-default TeX-command-default "LaTeXMk")
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
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((LaTeX-mode latex-mode) "texlab")))
)


(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  :bind (:map cdlatex-mode-map 
              ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-math-symbol-alist '((?f ("\\varphi" "\\phi"))
                                    (?i ("\\iota"))
                                    ))
  (setq cdlatex-math-modify-alist '((?f "\\mathbb" nil t nil nil)))
  (cdlatex-reset-mode))

(use-package texpresso
  :defer nil
  :load-path "~/.emacs.d/lisp/packages/")

(provide 'init-tex)
