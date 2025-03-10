(defvar ovadia/default-font-size 120)
(defvar ovadia/default-variable-font-size 120)
(defvar ovadia/frame-transparency '(90 . 90))

(set-frame-parameter (selected-frame) 'alpha ovadia/frame-transparency)
(set-frame-parameter (selected-frame) 'fullscreen 'fullboth)

(add-to-list 'default-frame-alist `(alpha . ,ovadia/frame-transparency))
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

(set-face-attribute 'default nil :height ovadia/default-font-size)
(set-face-attribute 'fixed-pitch nil :height ovadia/default-font-size)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(set-fringe-mode 10)

(electric-pair-mode t)
(column-number-mode t)
(save-place-mode t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq visible-bell t
      inhibit-startup-screen t
      display-line-numbers-type 'relative
      use-dialog-box nil)

(global-display-line-numbers-mode t)
(global-auto-revert-mode t)
(global-completion-preview-mode 1)

(load-theme 'dracula t)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package doom-modeline
  :init (doom-modeline-mode)
  :config
  (setq doom-modeline-height 30))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package marginalia
  :init (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package vertico
  :init (vertico-mode))

(use-package vertico-posframe)
;; :init (vertico-posframe-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode)
  :config
  (setq corfu-auto t
	corfu-quit-no-match 'separator
	corfu-auto-prefix 1
	corfu-min-width 30
	corfu-left-margin-width 2
	corfu-right-margin-width 0.5)
  (keymap-set corfu-map "S-SPC" #'corfu-insert-separator))

(use-package nerd-icons-corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
