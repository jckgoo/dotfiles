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

(use-package delight
  :demand t)

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

;; ** Minibuffer
(setq enable-recursive-minibuffers t)

(use-package vertico
  :init
  (vertico-mode 1))

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
	      ("RET" . vertico-directory-enter)
	      ("DEL" . vertico-directory-delete-char)
	      ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package marginalia
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (;; C-c bindings
	 ("C-c M-x" . consult-mode-command)
	 ("C-c h" . consult-history)
	 ("C-c k" . consult-kmacro)
	 ("C-c m" . consult-man)
	 ;; C-x bindings
	 ("C-x M-:" . consult-complex-command)
	 ("C-x b" . consult-buffer)
	 ("C-x 4 b" . consult-buffer-other-window)
	 ("C-x 5 b" . consult-buffer-other-frame)
	 ("C-x r b" . consult-bookmark)
	 ("C-x p b" . consult-project-buffer)
	 ;; Other bindings
	 ("M-y" . consult-yank-pop)
	 ;; M-g bindings (goto-map)
	 ("M-g e" . consult-compile-error)
	 ("M-g f" . consult-flymake)
	 ("M-g g" . consult-goto-line)
	 ("M-g M-g" . consult-goto-line)
	 ("M-g o" . consult-outline)
	 ("M-g m" . consult-mark)
	 ("M-g k" . consult-global-mark)
	 ("M-g i" . consult-imenu)
	 ("M-g I" . consult-imenu-multi)
	 ;; M-s bindings (search-map)
	 ("M-s d" . consult-find)
	 ("M-s D" . consult-locate)
	 ("M-s e" . consult-isearch-history)
	 ("M-s g" . consult-grep)
	 ("M-s G" . consult-git-grep)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 ("M-s k" . consult-keep-lines)
	 ("M-s u" . consult-focus-lines)
	 :map isearch-mode-map
	 ("M-e" . consult-isearch-history)
	 ("M-s e" . consult-isearch-history)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 :map minibuffer-local-map
	 ("M-s" . consult-history)
	 ("M-r" . consult-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
	register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref))

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
  (setq magit-revision-show-gravatars nil))

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
  :delight subword-mode
  :commands subword-mode)

(use-package smartparens
  :delight smartparens-mode
  :init
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)
  (smartparens-global-strict-mode 1)
  (show-smartparens-global-mode 1))

;; ** Completion
(global-set-key [remap dabbrev-expand] #'hippie-expand)

(use-package corfu
  :init
  (setq corfu-auto t)
  (global-corfu-mode 1))

(use-package yasnippet
  :delight yas-minor-mode
  :init
  (push #'yas-hippie-try-expand hippie-expand-try-functions-list))

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

(bind-key "C-/" #'undo-only)
(bind-key "C-?" #'undo-redo)

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
