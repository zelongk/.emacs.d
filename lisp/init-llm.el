;; init-llm --- LLM frontend -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf gptel
  :ensure t
  :commands (gptel gptel-menu gptel-send)
  :bind
  ("C-c l l" . gptel)
  ("C-c <return>" . gptel-send)
  ("C-c C-<return>" . gptel-menu)
  ("C-c C-g" . gptel-abort)
  (:gptel-mode-map
   ("C-c C-x t" . gptel-org-set-topic)
   ("+" . gptel-add))
  :hook (gptel-mode-hook . gptel-highlight-mode)
  :defer-config
  (setq gptel-model 'gpt-5.3-codex
        gptel-backend (gptel-make-gh-copilot "Copilot")
        gptel-cache t
        gptel-default-mode #'org-mode
        gptel-highlight-methods '(face)
        gptel-org-branching-context t)
  
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (lambda () (gptel-api-key-from-auth-source "openrouter.ai" "apikey")) ;; Lazy load
    :models '(~google/gemini-flash-latest
              ~google/gemini-pro-latest
              openai/gpt-5.5))
  
  (defun my/gptel-latex-preview (beg end)
    (when (and (display-graphic-p)
               (derived-mode-p 'org-mode))
      (org-latex-preview--preview-region 'dvisvgm beg end)))
  (add-hook 'gptel-post-response-functions #'my/gptel-latex-preview))

(leaf gptel-magit :ensure t
  :after magit
  :hook (magit-mode-hook . gptel-magit-install))

(leaf gptel-agent :ensure t
  :bind
  ("C-c l a" . gptel-agent)
  :config (gptel-agent-update))

(provide 'init-llm)
;;; init-llm.el ends here
