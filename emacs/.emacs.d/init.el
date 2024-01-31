;; init.el -*- lexical-binding: t outline-regexp: "^;; \\*+ "; eval: (outline-minor-mode 1); -*-
; * Initialization
(unless (featurep 'early-init)
  (load (expand-file-name "early-init" user-emacs-directory) t))

(setq user-full-name "Justin Goo"
      user-mail-address "jckgoo@gmail.com")

(setq custom-file (concat user-emacs-directory "/custom.el"))
(load custom-file 'noerror)

(setq ad-redefinition-action 'accept)


;; * Package Management
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'bind-key)
  (require 'use-package)
  (setq use-package-always-ensure t))
(require 'diminish)

;; * OS-specific configuration
(when (eq system-type 'darwin)
  (add-to-list 'exec-path "/usr/local/bin")
  (add-to-list 'exec-path "~/.local/bin")
  (setq ns-pop-up-frames nil)
  (setq locate-command "mdfind"))

;; * Themes/UI
(fset 'yes-or-no-p 'y-or-n-p)

(when (member "Fira Code" (font-family-list))
  (set-frame-font "Fira Code-11" nil t))

(use-package ligature
  :init
  (ligature-set-ligatures 't '("www" "Fl" "Tl" "ff" "ffi" "fi" "fj" "fl" "ft"))
  (ligature-set-ligatures 'prog-mode
                          '("{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            (";" (rx (+ ";")))
                            ("&" (rx (+ "&")))
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ("%" (rx (+ "%")))
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]" "-" "=" ))))
                            ("\\" (rx (or "/" (+ "\\"))))
                            ("+" (rx (or ">" (+ "+"))))
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!" "="))))
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ("w" (rx (+ "w")))
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!" "-"  "/" "|" "="))))
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_" (+ "#"))))
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ("_" (rx (+ (or "_" "|"))))
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))))
  (global-ligature-mode t))

(use-package solarized-theme
  :config
  (progn
    (setq x-underline-at-descent-line t)
    (setq solarized-distinct-fringe-background t)
    (load-theme 'solarized-light t)))

(use-package counsel
  :demand t
  :diminish 'ivy-mode
  :bind (("C-r" . ivy-resume)
	 ("C-s" . swiper)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-h f" . counsel-describe-function)
	 ("C-h v" . counsel-describe-variable)
	 ("C-h o" . counsel-info-lookup-symbol)
	 ("C-x 8 RET" . counsel-unicode-char))
  :config
  (progn
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (setq ivy-count-format "(%d/%d)")
    (ivy-mode 1)))

;; * Files/Buffers
(setq make-backup-files nil)
(setq auto-save-default nil)

(global-auto-revert-mode 1)

(setq tramp-default-method "ssh")

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward
	uniquify-separator "/"
	uniquify-after-kill-buffer-p t
	uniquify-ignore-buffers-re "^\\*"))

;; * Project Management
(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-completing-read-function #'ivy-completing-read
	magit-revision-show-gravatars nil))

;; * Editing/Navigation
(setq-default truncate-lines t)
(setq-default fill-column 72)
(add-hook 'text-mode-hook #'turn-on-auto-fill)

(setq backward-delete-char-untabify-method nil)
(setq-default show-trailing-whitespace t)

(delete-selection-mode 1)

(setq search-default-mode #'char-fold-to-regexp)
(setq replace-char-fold t)

(use-package subword
  :ensure nil
  :diminish 'subword-mode
  :commands subword-mode)

(use-package undo-tree
  :diminish 'undo-tree-mode
  :config
  (global-undo-tree-mode 1))

(use-package smartparens
  :diminish 'smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (sp-use-smartparens-bindings)
    (smartparens-global-strict-mode 1)
    (show-smartparens-global-mode 1)))

(use-package company
  :demand t
  :diminish 'company-mode
  :bind (("M-/" . company-yasnippet))
  :config
  (progn
    (setq-default tab-always-indent 'complete)
    (global-company-mode 1)))

(use-package yasnippet
  :diminish 'yas-minor-mode
  :config
  (yas-global-mode 1))

;; * Filetypes
;; ** C/C++
(add-hook 'c-mode-common-hook #'subword-mode)
(setq c-default-style
      '((java-mode . "java")
	(awk-mode . "awk")
	(other . "linux")))

(add-to-list 'auto-mode-alist '("\\.nss\\'" . c-mode))

;; ** CSV
(use-package csv-mode
  :mode ("\\.csv\\'" "\\.2da\\'")
  :config
  (progn
    (add-hook 'csv-mode-hook #'turn-off-auto-fill)
    (setq csv-separators (list "," ";" "\t"))))

;; ** Haskell
(use-package haskell-mode
  :mode (("\\.hs\\(c\\|-boot\\)?\\'" . haskell-mode)
	 ("\\.lhs\\'" . literate-haskell-mode)
	 ("\\.cabal\\'" . haskell-cabal-mode))
  :config
  (progn
    (add-hook 'haskell-mode-hook #'subword-mode)
    (add-hook 'haskell-mode-hook #'interactive-haskell-mode)
    (setq haskell-process-suggest-remove-import-lines t
	  haskell-process-auto-import-loaded-modules t
	  haskell-process-log t)))

;; ** Text/Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode)
	 ("\\.txt\\'" . markdown-mode)
	 ("\\.text\\'" . markdown-mode))
  :config
  (add-hook 'gfm-mode-hook #'turn-off-auto-fill))

;; * Keybindings
(use-package misc
  :ensure nil
  :bind (("M-z" . zap-up-to-char)))

(bind-key "C-M-s" #'isearch-forward)
(bind-key "C-M-r" #'isearch-backward)

(bind-key "C-w" #'kill-lines-or-region)
(bind-key "M-w" #'copy-lines-or-region)

(bind-key "C-;" #'comment-line)

(setq outline-minor-mode-prefix (kbd "C-c C-o"))

;; * Functions
(defun kill-lines-or-region (arg)
  "Delete region if active, otherwise delete ARG lines"
  (interactive "p")
  (if (use-region-p) (kill-region (region-beginning) (region-end) t)
    (kill-region (line-beginning-position 1)
		 (line-beginning-position (1+ arg)))))

(defun copy-lines-or-region (arg)
  "Copy region if active, otherwise copy ARG lines"
  (interactive "p")
  (if (use-region-p) (kill-ring-save (region-beginning) (region-end) t)
    (progn
      (kill-ring-save (line-beginning-position 1)
		      (line-beginning-position (1+ arg)))
      (message "Copied %d lines" arg))))
