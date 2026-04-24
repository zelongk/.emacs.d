;;; -*- lexical-binding: t; -*-

(use-package gptel
  :ensure t
  :commands (gptel gptel-menu gptel-send)
  :bind (("C-c l l" . gptell)
         ("C-c l s" . gptel-send)
	     ("C-c l m" . gptel-menu))
  :hook (gptel-mode . gptel-highlight-mode)
  :config
  (setq gptel-model 'gpt-5.2
        gptel-backend (gptel-make-gh-copilot "Copilot")
        gptel-cache t
        gptel-default-mode #'org-mode
        gptel-display-buffer-action nil)  ; if user changes this, popup manager will bow out
  )

(use-package gptel-magit
  :ensure t
  :after magit
  :hook (magit-mode . gptel-magit-install))

(use-package gptel-agent
  :ensure t
  :after gptel
  :config (gptel-agent-update))  

(provide 'init-llm)
