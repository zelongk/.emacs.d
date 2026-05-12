;; init-python --- Python -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

;; Python Mode
;; Install: pip install pyflakes autopep8
(leaf python
  :hook
  (inferior-python-mode-hook . (lambda ()
                                 (process-query-on-exit-flag
                                  (get-process "Python"))))
  :init
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)
  :config
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  ;; Default to Python 3. Prefer the versioned Python binaries since some
  ;; systems stupidly make the unversioned one point at Python 2.
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3")))

(provide 'init-python)
;;; init-python.el ends here
