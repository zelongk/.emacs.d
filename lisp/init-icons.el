;; init-icons --- Icons -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf nerd-icons
  :vc (:url "https://github.com/rainstormstudio/nerd-icons.el"))

(leaf nerd-icons-dired :ensure t
  :blackout t
  :hook (dired-mode-hook . nerd-icons-dired-mode))

(leaf nerd-icons-completion :ensure t
  :after marginalia
  :init (nerd-icons-completion-marginalia-setup))

(leaf nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook-hook . nerd-icons-ibuffer-mode))

(leaf nerd-icons-corfu :ensure t
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'init-icons)
;;; init-icons.el ends here
