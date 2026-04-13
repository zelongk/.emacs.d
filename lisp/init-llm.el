;;; -*- lexical-binding: t; -*-

(use-package gptel
  :defer t
  :bind (("C-c l s" . gptel-send)
	     ("C-c l m" . gptel-menu))
  :config
  (setq gptel-model 'gpt-5.2)
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))
  (setq gptel-default-mode #'org-mode)
  (setq gptel-display-buffer-action nil)  ; if user changes this, popup manager will bow out
  )

(use-package gptel-magit
  :hook (magit-mode . gptel-magit-install))

(use-package gptel-agent
  :config (gptel-agent-update))  

(provide 'init-llm)
