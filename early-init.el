;; -*- lexical-binding: t -*-


(setq gc-cons-threshold 33554432)


(setq package-enable-at-startup nil)

(setq use-package-enable-imenu-support t)

(setq load-prefer-newer noninteractive)

(prefer-coding-system 'utf-8)
;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist)
  (push '(ns-appearance . dark) default-frame-alist))

;; Prevent flash of unstyled mode line
(setq mode-line-format nil)

