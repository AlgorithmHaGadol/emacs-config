(defvar ovadia/default-font-size 110)
(defvar ovadia/default-variable-font-size 110)
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
(savehist-mode t)

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
  (setq doom-modeline-height 30
	doom-modeline-minor-modes t))

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

(use-package cape
  :init
  ;;(add-hook 'completion-at-point-functions #'cape-dabbrev)
  ;;(add-hook 'completion-at-point-functions #'cape-file)
  ;;(add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-hook 'completion-at-point-functions #'cape-history)
  )

(defun cape-all()
  (cape-wrap-super #'yasnippet-capf #'cape-dabbrev #'cape-file #'cape-elisp-block #'cape-history))
(use-package yasnippet-snippets)
(use-package yasnippet
  :ensure t
  :init (yas-global-mode))
(use-package yasnippet-capf
  :after cape
  :init (add-hook 'completion-at-point-functions #'cape-all))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :hook (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode 
  :hook (prog-mode . rainbow-mode))

(add-to-list 'load-path
             (expand-file-name "~/.config/emacs30/edwina"))

(add-to-list 'nerd-icons-mode-icon-alist '(edwina-mode nerd-icons-codicon "nf-cod-layout" :face nerd-icons-dblue))
(require 'edwina)
(edwina-setup-dwm-keys)
(edwina-mode 1)

(load-file "~/.config/emacs30/type-speed.el")

(use-package minions
  :ensure t
  :config (minions-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config (which-key-mode))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-center-content t
	dashboard-startup-banner "~/.config/emacs30/ovadiaTech_Logo.png"
	dashboard-banner-logo-title "Work SMART, not HARD!"
	dashboard-display-icons-p t
	dashboard-icon-type 'nerd-icons
	dashboard-set-file-icons t
	dashboard-set-heading-icons t)
  (dashboard-modify-heading-icons '((recents . "nf-oct-file_code")
				    (bookmarks . "nf-oct-bookmark")
				    (agenda . "nf-oct-tasklist")
				    (projects . "nf-oct-code")))
  (dashboard-setup-startup-hook))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


(set-face-attribute 'default nil :font "JetBrainsMono NF" :height ovadia/default-font-size)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono NF" :height ovadia/default-font-size)

(defvar ligatures-JetBrainsMono
    '("--" "---" "==" "===" "!=" "!==" "=!=" "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++"
      "***" ";;" "!!" "??" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<>" "<<<" ">>>" "<<" ">>" "||" "-|"
      "_|_" "|-" "||-" "|=" "||=" "##" "###" "####" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:"
      "#!" "#=" "^=" "<$>" "<$" "$>" "<+>" "<+ +>" "<*>" "<* *>" "</" "</>" "/>" "<!--"
      "<#--" "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>" "==>" "=>"
      "=>>" ">=>" ">>=" ">>-" ">-" ">--" "-<" "-<<" ">->" "<-<" "<-|" "<=|" "|=>" "|->" "<-"
      "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~" "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]"
      "|>" "<|" "||>" "<||" "|||>" "|||>" "<|>" "..." ".." ".=" ".-" "..<" ".?" "::" ":::"
      ":=" "::=" ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__"))
  (use-package ligature
    :config
    (ligature-set-ligatures 'prog-mode ligatures-JetBrainsMono)
    (ligature-set-ligatures 'org-mode ligatures-JetBrainsMono)
    (global-ligature-mode 1))


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
