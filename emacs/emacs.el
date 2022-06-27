(setq gnutls-algorithm-priority "normal:-vers-tls1.3")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(use-package gcmh
  :ensure t
  :diminish
  :config
  (gcmh-mode 1))

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-hide-results t))

(when (window-system)
  (fringe-mode 0)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (scroll-bar-mode -1))

(use-package savehist)

;; put all the auto-saves in a common folder.
(let ((chris-auto-save-dir "~/.emacs-autosaves/"))
  (setq auto-save-file-name-transforms `((".*" ,(expand-file-name "\\2" chris-auto-save-dir) t))
	auto-save-no-message t)
  (unless (file-exists-p chris-auto-save-dir)
    (make-directory chris-auto-save-dir)))

(setq inhibit-startup-screen t
      enable-recursive-minibuffers t
      ring-bell-function 'ignore
      savehist-file "~/.emacs.d/savehist"
      custom-file "~/.emacs.d/custom"
      confirm-kill-processes nil

      ;; macos doesn't support --dired and I don't care enough to install gnu utils
      dired-use-ls-dired nil

      ;; disable backups (that's what git is for)
      backup-inhibited t
      ;; and disable lockfiles (I'm not likely to have multiple emacs instances open)
      create-lockfiles nil

      use-package-always-ensure t
      eldoc-echo-area-use-multiline-p t)

(setq-default
 fill-column 80
 cursor-type 'bar
 line-spacing 5
 )

(pixel-scroll-precision-mode 1)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(bind-key "C-c C-p" 'pp-eval-last-sexp emacs-lisp-mode-map)

(bind-key "M-u" 'upcase-dwim)
(bind-key "M-l" 'downcase-dwim)

(load custom-file 'noerror)

(defalias 'yes-or-no-p 'y-or-n-p)

;; TRAMP configuration
;; ======================================================

(use-package tramp
  :config

  (push
   (cons
    "docker"
    '((tramp-login-program "docker")
      (tramp-login-args (("exec" "-it") ("%h") ("/bin/bash")))
      (tramp-remote-shell "/bin/sh")
      (tramp-remote-shell-args ("-i") ("-c"))))
   tramp-methods)

  (defadvice tramp-completion-handle-file-name-all-completions
      (around dotemacs-completion-docker activate)
    "(tramp-completion-handle-file-name-all-completions \"\" \"/docker:\" returns
    a list of active Docker container names, followed by colons."
    (if (equal (ad-get-arg 1) "/docker:")
	(let* ((dockernames-raw (shell-command-to-string "docker ps | awk '$NF != \"NAMES\" { print $NF \":\" }'"))
               (dockernames (cl-remove-if-not
                             #'(lambda (dockerline) (string-match ":$" dockerline))
                             (split-string dockernames-raw "\n"))))
          (setq ad-return-value dockernames))
      ad-do-it)))

;; ======================================================

(use-package string-inflection
  :ensure t
  :bind (("s-8" . string-inflection-all-cycle)))

'(windmove-default-keybindings 'meta)
'(setq windmove-wrap-around t)

(global-display-line-numbers-mode -1)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("JAVA_HOME")))

(setq
 display-buffer-alist
 `(("\\^*\\(cider-doc\\|helpful .*\\|Help\\)\\*"
    (display-buffer-in-side-window)
    (side . right)
    (window-width . 74))
   ("\\^*cider-\\(repl \\|result\\)"
    (display-buffer-in-side-window)
    (side . right)
    (window-width . 74)
    (slot . 2))
   ("\\^*inf-clojure "
    (display-buffer-in-side-window)
    (side . right)
    (window-width . 80)
    (slot . 2))
   ("magit:"
    (display-buffer-in-side-window)
    (side . right)
    (slot . 2)
    (window-width . 74))
   ("*ripgrep-search*"
    (display-buffer-in-side-window)
    (side . bottom)
    (slot . 0)
    (window-height . 20))))

(bind-key "s-b" 'window-toggle-side-windows)

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

'(use-package all-the-icons
   :ensure t)

(use-package chris-font-scaling
  :load-path "~/.emacs.d/chris")

(use-package chris-windows
  :load-path "~/.emacs.d/chris/")

(use-package winner
  :ensure t
  :config
  (winner-mode)
  (bind-key "s-<left>" 'winner-undo)
  (bind-key "s-<right>" 'winner-redo))

(use-package ace-window
  :ensure t
  :config
  (setq aw-scope 'frame)
  (bind-key "s-t" 'ace-window))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
'(add-to-list 'default-frame-alist '(height . maximized))
'(add-to-list 'default-frame-alist '(width . 120))
;; (add-to-list 'default-frame-alist '(width . 120))
;; (add-to-list 'default-frame-alist '(height . 60))

(savehist-mode t)
(server-start)

(defun open-init-file ()
  "Open this very file."
  (interactive)
  (let ((vc-follow-symlinks t))
    ;; the above disables that annoying symlink warning.
    ;; (happens because my .emacs is a symlink to a git repo)
    (find-file user-init-file)))

(use-package bind-key
  :ensure t)

(bind-key "s-," 'open-init-file)

(use-package diminish
  :ensure t
  :config
  (diminish 'auto-revert-mode)
  '(diminish 'eldoc-mode))

(use-package olivetti
  :ensure t
  :config
  (setq-default olivetti-body-width 90)
  :hook
  (Info-mode . olivetti-mode)
  (markdown-mode . olivetti-mode)
  (org-mode . olivetti-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package magit
  :ensure t
  :config
  (setq magit-save-repository-buffers 'dontask)

  :bind (("C-x g" . magit-status)
	 ("C-S-g" . magit-status)
	 ("C-c g" . magit-file-dispatch)))

'(use-package flx
   :ensure t)

(use-package ivy
  :ensure t
  :diminish
  :config
  (ivy-mode +1)
  (setq ivy-use-virtual-buffers t
	ivy-re-builders-alist '((swiper . ivy--regex-plus)
				(t . ivy--regex-fuzzy))
	ivy-height 20)
  (bind-keys ("C-s" . swiper)
	     ("C-c C-r" .  ivy-resume))
  (bind-key "s-d" 'ivy-next-line ivy-minibuffer-map)
  (bind-key "s-d" 'swiper-thing-at-point))

(use-package counsel
  :ensure t
  :diminish
  :config
  (counsel-mode +1))

(use-package prescient
  :ensure t)

(use-package ivy-prescient
  :ensure t
  :config
  (ivy-prescient-mode +1))

(use-package ripgrep
  :ensure t)

;; projectile
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)

  (setq projectile-enable-caching nil
	projectile-indexing-method 'alien
	projectile-completion-system 'ivy
	projectile-sort-order 'recently-active
	projectile-project-search-path '("~/Projects/Atomic" "~/Projects"))

  (projectile-mode +1)
  :diminish)

;; from emacs redux: https://emacsredux.com/blog/2013/05/04/rename-file-and-buffer/
(defun er-rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))
(global-set-key (kbd "C-c r")  #'er-rename-file-and-buffer)

(defun er-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))
(global-set-key (kbd "C-c D")  #'er-delete-file-and-buffer)

(use-package dired-sidebar
  :ensure t
  :config
  (setq dired-sidebar-use-custom-font t
	dired-sidebar-face "Helvetica"

	dired-sidebar-width 40
	dired-sidebar-display-alist '((side . left)
				      (slot . 1)))
  (defun chris-sidebar-toggle ()
    "Jump to the sidebar if it's not the active window. Otherwise,
close it."
    (interactive)
    (if (eq (current-buffer) (dired-sidebar-buffer))
	(dired-sidebar-hide-sidebar)
      (dired-sidebar-jump-to-sidebar)))
  (bind-key "s-E" #'chris-sidebar-toggle))

(use-package avy
  :ensure t
  :config
  (bind-key "s-r" 'avy-goto-char)
  (bind-key "s-R" 'avy-resume)
  (setq avy-keys '(?h ?t ?n ?s ?u ?e ?o ?a)))

(use-package helpful
  :ensure t
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)

  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (bind-key "M-<tab>" 'company-complete company-mode-map)
  (setq company-tooltip-align-annotations t))

(use-package ispell
  :ensure t
  :config
  (setq-default ispell-program-name "aspell"))

(use-package clojure-mode
  :ensure t
  :config)

(use-package flyspell
  :ensure t)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  (setq flycheck-check-syntax-automatically
	'(save idle-change idle-buffer-switch mode-enabled)))

(use-package flycheck-pos-tip
  :ensure t
  :config
  (setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages
	flycheck-pos-tip-timeout 5))

(use-package yaml-mode
  :ensure t)

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package racket-mode
  :ensure t)

'(use-package geiser
   :ensure t)

'(use-package geiser-mit
   :ensure t)

(use-package cider
  :ensure t
  :config
  '(require 'flycheck-clj-kondo)
  '(flycheck-add-next-checker 'clojure-cider-kibit 'flycheck-clj-kondo)
  '(flycheck-clojure-setup))

(use-package lsp-mode
  :ensure t
  :config
  (setq read-process-output-max (* 1024 1024)
	lsp-headerline-breadcrumb-enable nil)
  :hook
  (clojure-mode . lsp-deferred)
  (ruby-mode . lsp-deferred)
  (web-mode . lsp-deferred)
  (typescript-mode . lsp-deferred)
  (ruby-mode . lsp-deferred)
  (rustic-mode . lsp-deferred)
  ;; (prog-mode . lsp-deferred)
  )

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-sideline-show-code-actions nil))

(use-package lsp-ivy
  :ensure t
  :config
  )

(use-package terraform-mode
  :ensure t)

(use-package company-terraform
  :ensure t
  :config
  (company-terraform-init))

(use-package lsp-java
  :ensure t
  :hook
  (java-mode . lsp-deferred))

'(use-package inf-clojure
   :ensure t
   :config
   (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode))

(use-package flycheck-clojure
  :ensure t
  :commands (flycheck-clojure-setup)
  :config
  (eval-after-load 'flycheck
    '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

(use-package flycheck-clj-kondo
  :ensure t
  :config)

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
	    (lambda ()
	      (clj-refactor-mode)
	      (cljr-add-keybindings-with-prefix "C-c C-m"))))

(use-package smartparens
  :ensure t
  :init
  (require 'smartparens-config)
  (require 'smartparens-clojure)
  :config
  (load "~/.emacs.d/chris/sp-config")
  (smartparens-global-mode +1))

(use-package rustic
  :ensure t)

'(use-package sql-indent
   :ensure t
   :init
   (require 'sql-indent)
   :config
   (setq
    chris-sqlind-indentation-offsets-alist
    `((select-clause 0)
      (insert-clause 0)
      (delete-clause 0)
      (update-clause 0)
      (select-column-continuation +)
      (select-table-continuation +)
      (nested-statement-open 0)
      (nested-statement-continuation +)
      (nested-statement-close 0)
      ,@sqlind-default-indentation-offsets-alist))

   (add-hook #'sqlind-minor-mode-hook
	     (lambda ()
	       (setq sqlind-indentation-offsets-alist
		     chris-sqlind-indentation-offsets-alist)))

   (add-hook #'sql-mode-hook
	     (lambda ()
	       (sqlind-minor-mode))))

(use-package haskell-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :hook
  (markdown-mode . flyspell-mode)
  (markdown-mode . auto-fill-mode))

(use-package org
  :config
  :bind (("s-." . org-ctrl-c-ctrl-c))
  :hook
  (org-mode . flyspell-mode)
  (org-mode . auto-fill-mode))

;; web / typescript

(use-package web-mode
  :ensure t
  :config
  (setq web-mode-code-indent-offset 2
	web-mode-markup-indent-offset 2
	web-mode-enable-auto-quoting nil))

(use-package css-mode
  :config
  (setq css-indent-offset 2))

(use-package js2-mode
  :ensure t
  :config
  (setq js2-basic-offset 2))

(defun setup-typescript ()
  (setq typescript-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  )

(setup-typescript)

'(use-package tide
   :ensure t
   :config
   (setq typescript-indent-level 2)
   (defun setup-tide-mode ()
     (interactive)
     (tide-setup)
     (eldoc-mode +1)
     (tide-hl-identifier-mode +1))
   (bind-key "<f2>" #'tide-rename-symbol tide-mode-map)
   (bind-key "<f12>" #'tide-references tide-mode-map)
   (bind-key "<f5>" #'tide-organize-imports tide-mode-map)
   (bind-key "s-." #'tide-fix tide-mode-map)
   (setq typescript-indent-level 2)
   (add-hook 'typescript-mode-hook #'setup-tide-mode)
   (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
   (add-hook 'web-mode-hook
	     (lambda ()
	       (when (string-equal "tsx" (file-name-extension buffer-file-name))
		 (setup-tide-mode))))
   (flycheck-add-next-checker 'typescript-tide 'javascript-eslint)
   (flycheck-add-next-checker 'javascript-tide 'javascript-eslint)
   (pop (flycheck-checker-get 'tsx-tide 'next-checkers))
   (flycheck-add-next-checker 'tsx-tide 'javascript-eslint)

   (setq tide-server-max-response-length 1024000
	 tide-sync-request-timeout 360))

(use-package add-node-modules-path
  :ensure t
  :config
  (add-hook #'tide-mode-hook 'add-node-modules-path)
  (add-hook #'web-mode-hook 'add-node-modules-path))

(use-package prettier-js
  :ensure t
  :config
  (add-hook #'tide-mode-hook 'prettier-js-mode)
  (add-hook #'web-mode-hook 'prettier-js-mode))

'(use-package graphql-mode
   :ensure t)

(use-package json-mode
  :ensure t
  :config
  (setq js-indent-level 2))

;; python
;; ======================================================

(use-package pyenv-mode
  :ensure t
  :hook (python-mode . pyenv-mode))

(use-package lsp-python-ms
  :ensure t
  :init
  (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp-deferred))))

;; ======================================================


;; ruby
;; ======================================================

'(use-package rbenv
   :ensure t
   :config
   (global-rbenv-mode -1)
   (add-hook 'ruby-mode-hook 'rbenv-mode)
   (rbenv-use-corresponding))

(use-package inf-ruby
  :ensure t
  :bind (("C-c M-j" . inf-ruby-console-auto))
  :config
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter))

'(use-package robe
   :ensure t
   :config
   (add-hook 'ruby-mode-hook 'robe-mode)
   (eval-after-load 'company '(push 'company-robe company-backends)))

;; ======================================================


;; gnu octave
;; ======================================================

(use-package octave
  :ensure t
  :config
  (add-to-list 'auto-mode-alist
	       '("\\.m\\'" . octave-mode)))

;; ======================================================

;; moving lines up and down

(defun move-line-up ()
  "Move the current line up by one."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  "Move the current line down by one."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(bind-key "C-S-<up>" 'move-line-up)
(bind-key "C-S-<down>" 'move-line-down)

(bind-key "s-/" #'comment-line)

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-gruvbox-dark-medium t t)
  (load-theme 'base16-gruvbox-dark-hard t t)
  (load-theme 'base16-default-light t t)
  (load-theme 'base16-tomorrow-night-eighties t t)
  (load-theme 'base16-gruvbox-dark-pale t t)
  (load-theme 'base16-tomorrow t t)
  (load-theme 'base16-tomorrow t t))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one-light t t)
  (load-theme 'doom-tomorrow-day t t)
  (load-theme 'doom-gruvbox t t)
  (load-theme 'doom-opera-light t t))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t t))

(defvar dark-theme 'gruvbox
  "The dark theme used by `toggle-dark-mode'.")

(defvar light-theme 'doom-tomorrow-day
  "The light theme used by `toggle-dark-mode'.")

(defun activate-theme (target-theme)
  "Switch the theme to `TARGET-THEME'.

All other themes will be deactivated, and powerline will be reset."
  (seq-do #'disable-theme custom-enabled-themes)
  (enable-theme target-theme)
  '(powerline-reset)
  nil)

(defun toggle-dark-mode ()
  "Toggle dark mode.

  Will activate the `dark-theme' if it is not active.
  Otherwise, activate the `light-theme'."
  (interactive)
  (let ((target-theme (if (equal dark-theme (car custom-enabled-themes))
			  light-theme
			dark-theme)))
    (seq-do #'disable-theme custom-enabled-themes)
    (enable-theme target-theme)
    '(powerline-reset)))

;; (activate-theme 'base16-tomorrow-night-eighties)
;; (activate-theme 'base16-gruvbox-dark-medium)
;; (activate-theme 'base16-tomorrow)
(activate-theme light-theme)
(bind-key "<f10>" 'toggle-dark-mode)

;; ======================================================


;; Additional keyboard configuration

(bind-keys ("s-w" . kill-current-buffer)
	   ("s-{" . previous-buffer)
	   ("s-}" . next-buffer))

;; end
