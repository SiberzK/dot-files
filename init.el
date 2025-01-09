;;;; PACKAGE.EL ;;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless package--initialized (package-initialize))

;;;; USE-PACKAGE ;;;;

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;;; SLY ;;;;

(add-to-list 'load-path "~/git/sly")
(require 'sly-autoloads)

(with-eval-after-load 'sly
  (add-to-list 'sly-lisp-implementations
               '(sbcl ("sbcl"))))

;;;; CODE COMPLETION ;;;;

(use-package company
  :config
  (global-company-mode)
  (setq company-require-match nil))

(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode))

(use-package yasnippet
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

;;;; RIPGREP ;;;;

(use-package rg
  :init
  (rg-enable-default-bindings))

;;;; GIT ;;;;

(use-package magit
  :bind ("C-x g" . magit-status))

;;;; RUST ;;;;

(setenv "PATH" (concat (getenv "PATH") ":" (getenv "HOME") "/.cargo/bin"))
(setq exec-path (append exec-path '("~/.cargo/bin")))

(use-package rustic
  :config
  (setq rustic-lsp-client 'eglot)
  (setq rustic-format-on-save t)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) .
                 ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))

;;;; APPEARANCE ;;;;

(use-package dired-sidebar
  :bind (("C-x C-d" . dired-sidebar-toggle-sidebar))
  :config
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-theme 'nerd)
  (add-hook 'dired-sidebar-mode-hook (lambda () (display-line-numbers-mode -1))))

(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(show-paren-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-frame-maximized)
(set-frame-font "Hack-13" nil t)
;; Pretty lambda
(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'sly-mode-hook 'prettify-symbols-mode)

;;;; CUSTOM ;;;;

(setq default-directory "~/workspace/")
;; Disable startup screen
(setq inhibit-startup-screen t)
;; Emacs completion
(fido-vertical-mode 1)
;; Upcase/downcase region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; Lisp mode in .cl files
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
;; Auto-revert buffers
(global-auto-revert-mode t)
;; Default browser is Emacs built-in browser
(setq browse-url-browser-function 'eww-browse-url)
;; Delimiter matching
(electric-pair-mode 1)
;; Find file in git project
(global-set-key (kbd "C-c p") 'project-find-file)
;; Typing over selection re-writes it
(delete-selection-mode)
;; Indentation and trailing whitespace
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Disable easy suspension (use M-x suspend-emacs)
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-M-z") nil)
;; Save history across sessions
(savehist-mode 1)
;; Custom file
(setq custom-file "~/.emacs.d/emacs-custom-file-that-i-despise.el")
(load custom-file t)
