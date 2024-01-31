;; early-init.el -*- lexical-binding: t; -*-

;; Temporarily increase gc threshold and disable filename handlers
(let ((old-file-name-handler-alist file-name-handler-alist))
  (setq gc-cons-threshold (* 384 1024 1024))
  (setq file-name-handler-alist nil)
  (add-hook 'after-init-hook
	    (lambda ()
	      (setq file-name-handler-alist
		    (delete-dups (append file-name-handler-alist
					 old-file-name-handler-alist)))
	      (setq gc-cons-threshold (* 16 1024 1024))
	      (garbage-collect))))

;; Increase maximum pipe size
(setq read-process-output-max (* 1024 1024))

;; Inhibit redisplay while loading
(setq inhibit-redisplay t
      inhibit-message t)
(add-hook 'window-setup-hook
	  (lambda ()
	    (setq inhibit-redisplay nil
		  inhibit-message nil)
	    (redisplay)))

;; Frame resize is expensive, so we inhibit it
(setq frame-inhibit-implied-resize t
      x-gtk-resize-child-frames 'hide)

;; Set early to avoid momentary display
(setq inhibit-startup-screen t)
(tooltip-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

;; We will handle package initialization ourselves
(setq package-enable-at-startup nil)
