;; -*- lexical-binding: t; -*-

(leaf svg-lib
  :elpaca t)

(leaf svg-tag-mode
  :elpaca t
  :hook (emacs-startup-hook . global-svg-tag-mode)
  :config
  (setq svg-tag-tags
        '(
          ;; Your example
          (":TODO:" (lambda (_) (svg-tag-make "TODO")) nil nil)

          ;; One SVG per Org tag inside a :foo:bar: tag block.
          ;; Uses lookahead so tags in :foo:bar: can be matched one-by-one.
          (":[[:alnum:]_@#%]+\\(?=:\\)"
           (lambda (tag)
             (svg-tag-make (substring tag 1) :inverse t :padding 1 :margin 0))
           nil nil)

          ;; Hide the final trailing ":" that remains after the lookahead rule.
          ("\\(?<=\\w\\):\\(?=\\s-*$\\)"
           (lambda (_) (svg-tag-make "" :padding 0 :margin 0))
           nil nil))))


(provide 'init-svg)
