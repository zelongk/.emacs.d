;; -*- lexical-binding: t; -*-

(use-package svg-lib
  :ensure t)

(use-package tab-bar
  :after tab-bar
  :config
  (defface tab-bar-svg-active
    '((t (:foreground "#a1aeb5")))
    "Tab bar face for selected tab.")

  (defface tab-bar-svg-inactive
    '((t (:foreground "#cad7de")))
    "Tab bar face for inactive tabs.")

  (defun eli/tab-bar-svg-padding (width string)
    (let* ((style svg-lib-style-default)
           (margin      (plist-get style :margin))
           (txt-char-width  (window-font-width nil 'fixed-pitch))
           (tag-width (- width (* margin txt-char-width)))
           (padding (- (/ tag-width txt-char-width) (length string))))
      padding))

  (defun eli/tab-bar-tab-name-with-svg (tab i)
    (let* ((current-p (eq (car tab) 'current-tab))
           (name (concat (if tab-bar-tab-hints (format "%d " i) "")
                         (alist-get 'name tab)
                         (or (and tab-bar-close-button-show
                                  (not (eq tab-bar-close-button-show
                                           (if current-p 'non-selected 'selected)))
                                  tab-bar-close-button)
                             "")))
           (padding (plist-get svg-lib-style-default :padding))
           (width))
      (when tab-bar-auto-width
        (setq width (/ (frame-inner-width)
                       (length (funcall tab-bar-tabs-function))))
        (when tab-bar-auto-width-min
          (setq width (max width (if (window-system)
                                     (nth 0 tab-bar-auto-width-min)
                                   (nth 1 tab-bar-auto-width-min)))))
        (when tab-bar-auto-width-max
          (setq width (min width (if (window-system)
                                     (nth 0 tab-bar-auto-width-max)
                                   (nth 1 tab-bar-auto-width-max)))))
        (setq padding (eli/tab-bar-svg-padding width name)))
      (propertize
       name
       'display
       (svg-tag-make
        name
        :face (if (eq (car tab) 'current-tab) 'tab-bar-svg-active 'tab-bar-svg-inactive)
        :inverse t :margin 0 :radius 6 :padding padding))))

  (setq tab-bar-tab-name-format-function #'eli/tab-bar-tab-name-with-svg))

(use-package svg-tag-mode
  :ensure t
  :hook (emacs-startup . global-svg-tag-mode))

(provide 'init-svgtag)
