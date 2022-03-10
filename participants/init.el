;; Customize user interface.
;; (menu-bar-mode 0)
;; (tool-bar-mode 0)
;; (scroll-bar-mode 0)
(setq inhibit-startup-screen t)
;; (column-number-mode)

;; Load theme
(load-theme 'leuven)

;; Show stray whitespace.
;; (setq-default show-trailing-whitespace t)
;; (setq-default indicate-empty-lines t)

;; Use spaces, not tabs, for indentation.
(setq-default indent-tabs-mode nil)

;; Highlight matching pairs of parentheses.
(setq show-paren-delay 0)
(show-paren-mode)

;; Write auto-saves and backups to separate directory.
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)
;; Do not move the current file while creating backup.
(setq backup-by-copying t)

;; Disable lockfiles.
(setq create-lockfiles nil)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages.
(dolist (package '(markdown-mode ivy))
  (unless (package-installed-p package)
    (package-install package)))

;; Custom key sequennces.
;; (global-set-key (kbd "C-z") 'undo)

(progn
  (switch-to-buffer "a-random-buffer")
  (insert "\n\nDu hast es geschafft, Emacs ist für das Tutorial eingerichtet!"))
