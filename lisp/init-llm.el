;; init-llm --- LLM frontend -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf gptel
  :ensure t
  :commands (gptel gptel-menu gptel-send)
  :bind
  ("C-c l l" . gptel)
  ("C-c l s" . gptel-send)
  ("C-c l m" . gptel-menu)
  ("C-c l C-g" . gptel-abort)
  :hook (gptel-mode-hook . gptel-highlight-mode)
  :defer-config
  (setq gptel-model 'gpt-5.3-codex
        gptel-backend (gptel-make-gh-copilot "Copilot")
        gptel-cache t
        gptel-default-mode #'org-mode
        gptel-display-buffer-action nil)  ; if user changes this, popup manager will bow out
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (lambda () (gptel-api-key-from-auth-source "openrouter.ai" "apikey")) ;; Lazy load
    :models '(~google/gemini-flash-latest
              ~google/gemini-pro-latest
              openai/gpt-5.5)))

(leaf gptel-magit :ensure t
  :disabled t
  :after magit
  :hook (magit-mode-hook . gptel-magit-install))

(leaf gptel-agent :ensure t
  :bind
  ("C-c l a" . gptel-agent)
  :config (gptel-agent-update))

(provide 'init-llm)
;;; init-llm.el ends here
