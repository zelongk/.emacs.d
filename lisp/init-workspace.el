;; -*- lexical-binding: t; -*-

(use-package project
  :bind-keymap ("s-p" . project-prefix-map)
  ;; :init
  ;; (setq frame-title-format '((:eval
  ;;                             (let* ((proj (project-current nil))
  ;;                                    (pname (and proj (project-name proj))))
  ;;                               (if pname
  ;;                                   (format "[%s] %s" pname (buffer-name))
  ;;                                 (buffer-name)))))) ;; Otherwise buffer name only
  :config
  (setq project-list-file (expand-file-name "projects" user-cache-directory)))

(use-package ibuffer
  :defer t
  :bind ("C-x C-b" . ibuffer)
  :bind (:map ibuffer-mode-map
              ("M-o" . nil))
  :config
  (add-to-list 'ibuffer-help-buffer-modes 'helpful-mode)
  (add-to-list 'ibuffer-help-buffer-modes 'Man-mode)
  :init (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))

(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))

;; Group ibuffer's list by project
(use-package ibuffer-project
  :ensure t
  :after ibuffer project
  :autoload (ibuffer-project-generate-filter-groups ibuffer-do-sort-by-project-file-relative)
  :hook (ibuffer . (lambda ()
                     "Group ibuffer's list by project."
                     (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
                     (unless (eq ibuffer-sorting-mode 'project-file-relative)
                       (ibuffer-do-sort-by-project-file-relative))))
  :init (setq ibuffer-project-use-cache t))

(use-package tab-bar
  :hook (window-setup . tab-bar-mode)
  :bind (:map tab-bar-mode-map
              ("s-t" . tab-new)
              ("s-w" . tab-close)
              ("s-W" . delete-frame))
  :config
  (setq tab-bar-separator " "
        tab-bar-show nil
        tab-bar-new-tab-choice "*scratch*"
        tab-bar-auto-width nil
        tab-bar-tab-name-truncated-max 20
        tab-bar-close-button-show nil
        tab-bar-new-button-show nil
        tab-bar-format '(tab-bar-format-tabs tab-bar-separator)
        tab-bar-tab-hints t
        tab-bar-select-tab-modifiers '(super))
  
  (defun my/tab-bar-name ()
    (if-let* ((p (project-current nil)))
        (project-name p)
      (tab-bar-tab-name-truncated)))
  (setq tab-bar-tab-name-function #'my/tab-bar-name)

  ;; Add surround space to tab name
  (defun my/tab-bar-tab-name-format (tab i)
    (let* ((s (tab-bar-tab-name-format-default tab i))
           (face (get-text-property 0 'face s)))
      (concat (propertize " " 'face face)
              s
              (propertize " " 'face face))))
  (setq tab-bar-tab-name-format-function #'my/tab-bar-tab-name-format))

;; auto tab-bar
(use-package tab-bar
  :after tab-bar
  :disabled t
  :config
  (defun my/with-other-tab (&rest app)
    (project-other-tab-command)
    (apply app))

  (setq +functions-in-new-tab '(project-switch-project))

  (defun my/functions-in-new-tab (&optional disable)
    (dolist (cmd +functions-in-new-tab)
      (if disable
          (advice-remove cmd #'my/with-other-tab)
        (advice-add cmd :around #'my/with-other-tab))))
  ;; Pass an argument to disable e.g. (my/functions-in-new-tab t)
  (my/functions-in-new-tab))

(use-package tabspaces
  :ensure t
  :functions tabspaces-mode
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :hook ((elpaca-after-init . tabspaces-mode)
         (tabspaces-mode . tab-bar-history-mode))
  :bind (:map tabspaces-command-map
              ("l" . tabspaces-restore-session)
              ("s" . tabspaces-save-session)
              ("TAB" . tabspaces-switch-or-create-workspace))
  :custom
  (tab-bar-history-limit 30)
  
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*Messages*"))
  (tabspaces-exclude-buffers '("*eat*" "*vterm*" "*shell*" "*eshell*"))
  
  (tabspaces-session-file (expand-file-name "tabspaces/tabsession.el" user-cache-directory))
  (tabspaces-session-project-session-store (expand-file-name "tabspaces/" user-cache-directory))
  (tabspaces-initialize-project-with-todo t)
  (tabspaces-todo-file-name "project-todo.org")
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  :config
  (with-eval-after-load 'consult
    ;; hide full buffer list (still available with "b" prefix)
    (plist-put consult-source-buffer :hidden t)
    (plist-put consult-source-buffer :default nil)
    ;; set consult-workspace buffer list
    (defvar consult--source-workspace
      (list :name     "Workspace Buffers"
            :narrow   ?w
            :history  'buffer-name-history
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    (lambda () (consult--buffer-query
                                  :predicate #'tabspaces--local-buffer-p
                                  :sort 'visibility
                                  :as #'buffer-name)))

      "Set workspace buffer list for consult-buffer.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

(use-package beframe
  :disabled t
  :hook elpaca-after-init
  :bind-keymap ("C-c b" . beframe-prefix-map)
  :bind ("C-x f" . other-frame-prefix)
  :config
  (setq beframe-functions-in-frames '(project-switch-project)
        beframe-rename-function #'ignore
        beframe-global-buffers '("*scratch*" "*Messages*" "*Backtrace*"))
  (use-package embark
    :defer
    :config
    (define-key embark-buffer-map (kbd "fu")
                (defun my/beframe-unassume-buffer (buf)
                  (interactive "bUnassume: ")
                  (beframe--unassume
                   (list (get-buffer buf)))))
    (define-key embark-buffer-map (kbd "fa")
                (defun my/beframe-assume-buffer (buf)
                  (interactive "bAssume: ")
                  (beframe--assume
                   (list (get-buffer buf))))))

  ;; Beframe integration with other packages
  (with-eval-after-load 'consult
    (defun consult-beframe-buffer-list (&optional frame)
      "Return the list of buffers from `beframe-buffer-names' sorted by visibility.
With optional argument FRAME, return the list of buffers of FRAME."
      (beframe-buffer-list frame :sort #'beframe-buffer-sort-visibility))
    (setq consult-buffer-list-function #'consult-beframe-buffer-list)))

(provide 'init-workspace)
