;; init-gc --- Automatic smart gc -*- lexical-binding: t; -*-

;;; Commentary:
;;  Blablabla

;;; Code:

(leaf gcmh :ensure t
  :global-minor-mode gcmh-mode
  :config
  (defun gcmh-register-idle-gc ()
    "Register a timer to run `gcmh-idle-garbage-collect'.
Cancel the previous one if present."
    (unless (eq this-command 'self-insert-command)
      (let ((idle-t (if (eq gcmh-idle-delay 'auto)
                        (* gcmh-auto-idle-delay-factor gcmh-last-gc-time)
                      gcmh-idle-delay)))
        (if (timerp gcmh-idle-timer)
            (timer-set-time gcmh-idle-timer idle-t)
          (setf gcmh-idle-timer
                (run-with-timer idle-t nil #'gcmh-idle-garbage-collect))))))
  (setq gcmh-idle-delay 'auto       ; default is 15s
        gcmh-high-cons-threshold (* 32 1024 1024)
        gcmh-verbose nil
        gc-cons-percentage 0.2))

(setq gc-cons-threshold (* 16 1024 1024)
      gc-cons-percentage 0.2)

(provide 'init-gc)
;;; init-gc.el ends here
