;;; Commentary:
;; This is like my 4th Emacs config. It's mainly inspired by
;; github.com/exot and spacemacs. You can use it for whatever you want


;;; License:
;;
;; -------------------------------------------------------------------
;; "THE BEER-WARE LICENSE" (Revision 42):
;;
;; As long as you retain this notice you can do whatever you want with
;; this stuff. If we meet some day, and you think this stuff is worth
;; it, you can buy me a beer in return.  Felix alias Lin (林宜德)
;; -------------------------------------------------------------------


;;; Code:

;;;
;;; Peoples Emacs:
;;;

(defgroup peoplesEmacs nil
  "The peoplesEmacs group")


;;;
;;; Peoples Emacs Core:
;;;

(defgroup peoplesEmacs/core nil
  "The core configurations"
  :group 'peoplesEmacs)
(defcustom peoplesEmacs/core/neo-layout-used? t
  "Should adjustment for the neo2 keyboard layout be made?"
  :type 'boolean
  :group 'peoplesEmacs/core)

(defun pE/tweak ()
  "Having a function to tweak Emacs is just ... nevermind!"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun peoplesEmacs/core/history ()
  "We want to remember places we've been to, cos that's more
   intuitive I guess"
  (savehist-mode t)
  (save-place-mode t)
  (use-package recentf
    :ensure t
    :delight
    :init (recentf-mode t)
    :config
    (add-to-list 'recentf-exclude "\\~/.emacs.d/games/*\\")
    (add-to-list 'recentf-exclude "\\~/.emacs.d/elpa/*\\")
    (add-to-list 'recentf-exclude "\\\*Org Src *.org\[ * \]\*")
    (add-to-list 'recentf-exclude "~/.emacs.d/emms/history")))

(defun peoplesEmacs/core/no-prompts ()
  "There are annoying prompts in Emacs.
   Let's get rid of them"
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq vc-follow-symlinks t))

(defun peoplesEmacs/core/no-fluff ()
  "Emacs has many 'visual benefits' that make it intuitive for
   some Generation Z people .. I think?"
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (setq-default inital-scratch-message nil)
  (peoplesEmacs/core/no-prompts)
  (blink-cursor-mode nil)
  (use-package delight
    :ensure t
    :delight
    :config
    (delight '((emacs-lisp-mode "ξ")
	       (eldoc-mode nil "eldoc")
	       (hs-minor-mode nil "hideshow")
	       (helm-gtags-mode  nil "helm-gtags")
	       (auto-fill-function nil t))))
  (blink-cursor-mode 0))

(defun peoplesEmacs/core/checkers ()
  (use-package flycheck
    :ensure t
    :init (global-flycheck-mode t)
    :hook (prog-mode . flycheck-mode))
  (use-package flycheck-pos-tip
    :ensure t
    :after (flycheck)
					;:config (flycheck-pos-tip-mode)
    :hook (prog-mode . flycheck-pos-tip-mode))
  )

(defun _peoplesEmacs/core/vc ()
  "Text."
  (global-set-key (kbd "C-x G") 'vc-diff)
  (use-package diff-hl
    :ensure t
    :delight
    :hook ((prog-mode org-mode) . (lambda ()
				    (diff-hl-mode)
				    (diff-hl-flydiff-mode)))))

(defun peoplesEmacs/core/projects ()
  "Projectmanagement configuration."
  (use-package projectile
    :ensure t
    :init (projectile-global-mode)
    :delight '(:eval (concat "P[" (projectile-project-name) "]"))
    :config
    (setq projectile-enable-caching t)
    (setq projectile-completion-system 'helm))
  (use-package helm-projectile
    :ensure t
    :after (helm projectile)
    :init (helm-projectile-on))
  (global-ede-mode t)
  (_peoplesEmacs/core/vc)
  (use-package neotree
    :ensure t
    :after (projectile)
    :bind ([f8] . neotree-toggle)
    :config
    (setq projectile-switch-project-action 'neotree-projectile-action)
    (setq neo-smart-open t))
  ;; TODO
  ;; cmake-mode
  ;; stack
  ;; pip
  ;; ede config
  ;; mvn
  ;; clj
  ;; cabal
  ;; semantic config
  )

(defun pE/helper/unfold-on-point ()
  (yafolding-hide-parent-element)
  (yafolding-toggle-element))

(defun peoplesEmacs/core/folding ()
  (use-package yafolding
    :ensure t
    :delight
    :hook (prog-mode . yafolding-mode)
					;:bind ("<C-tab>" . hs-toggle-hiding)
    )
					;(global-set-key (kbd "<C-tab>") 'hs-toggle-hiding)
					;(add-hook 'prog-mode-hook 'hs-minor-mode)
  (add-hook 'isearch-mode-end-hook 'yafolding-show-element))

(defun peoplesEmacs/core/completion ()
  (use-package ggtags
    :ensure t
    :delight "g"
    :hook (c-mode c++-mode java-mode perl-mode cperl-mode awk-mode asm-mode cobol-mode csharp-mode erlang-mode f90-mode fortran-mode javascript-mode lua-mode pascal-mode clisp-mode python-mode ruby-mode octave-mode scheme-mode lisp-mode tex-mode latex-mode vimrc-mode) . 'ggtags-mode)
  (defvar-local company-fci-mode-on-p nil)

  (defun company-turn-off-fci (&rest ignore)
    (when (boundp 'fci-mode)
      (setq company-fci-mode-on-p fci-mode)
      (when fci-mode (fci-mode -1))))
  (defun company-maybe-turn-on-fci (&rest ignore)
    (when company-fci-mode-on-p (fci-mode 1)))
  (use-package company
    ;; TODO requires more configuration
    :after (ggtags)
    :ensure t
    :delight "cc"
    :config ;(global-company-mode t)
    (setq company-minimum-prefix-length 1)
    (setq company-idle-delay 0.2)
    (add-hook 'after-init-hook 'global-company-mode)
    (add-hook 'company-completion-started-hook 'company-turn-off-fci)
    (add-hook 'company-completion-finished-hook
	      'company-maybe-turn-on-fci)
    (add-hook 'company-completion-cancelled-hook
	      'company-maybe-turn-on-fci)
    (push 'company-capf company-backends)
    (setq company-auto-complete 'company-explicit-action-p)
    (setq company-auto-select-first-candidate nil))
  (use-package company-flx
    :ensure t
    :delight
    :after (company)
    :hook (company-mode . company-flx-mode))
  (use-package company-quickhelp
    :ensure t
    :delight
    :after (company) ;; TODO in the future confige the colors
    :config (setq company-quickhelp-delay 0.3)
    :hook (company-mode . company-quickhelp-mode))
  (use-package company-statistics
    :ensure t
    :defer t
    :delight
    :config (company-statistics-mode))
  (use-package auto-complete
    :ensure t
    :delight "ac")

  ;; TODO automatic download new snippets and create them faster
  (use-package  yasnippet
    :delight (yas-minor-mode nil "yasnippet")
    :ensure t
    :hook ((prog-mode text-mode) . yas-minor-mode)
    :config
    (setq yas-triggers-in-field t
	  yas-wrap-around-region t)
    (setq-default yas-prompt-functions '(yas-completing-prompt))
    :bind ("C-<tab>" . company-yasnippet)
    ;;:init
    ;; (setq-default yas-snippet-dirs
    ;; 		  ;;from AndreaCrotti/yasinppet-snippets and my own snippets
    ;; 		  '("~/.emacs.d/snippets/yasnippet-snippets/snippets" ;;
    ;; 		    "~/my_snippets")))
    )
  (use-package yasnippet-snippets
    :after yasnippet
    :ensure t)
  (use-package helm-c-yasnippet
    :ensure t
    :after (yasnippet)
    :config (setq helm-yas-space-match-any-greedy t)
    :bind ("<print> n" . helm-yas-complete))
  (use-package helm
    :delight helm-mode
    :ensure t
    :init (helm-mode t)
    :config
    (setq-default helm-mode-fuzzy-match t)
    (setq helm-autoresize-mode 1)
    (setq helm-autoresize-min-height 0)
    (setq helm-autoresize-max-height 80)
    (setq-default helm-ff-file-name-history-use-recentf t)
    (setq-default helm-split-window-in-side-p t)
    :bind
    ("M-ö" . helm-M-x)
    ("C-x r b" . helm-filtered-bookmarks)
    ("C-x f" . helm-find-files)
    ("C-x C-b" . helm-buffers-list)
    ("C-x b" . helm-for-files)
    ("M-f" . helm-occur)
    ("M-F" . helm-projectile-grep))
  (use-package helm-descbinds
    :ensure t
    :bind ("C-h b" . helm-descbinds)
    )
  ;; which-key # shows the following possible key strokes and what
  ;; they do
  
  (use-package which-key
    :delight
    :ensure t
    ;; :init (which-key-mode t)
    :config
    (which-key-setup-minibuffer)
    (setq which-key-idle-delay 0.2)
    (setq which-key-special-keys '("SPC" "TAB" "RET" "ESC" "DEL"))
    (add-hook 'after-init-hook (lambda ()
  				 ;; this is a work around because which
  				 ;; key wasn't showing
  				 ;; »Did you try turning it of on again
  				 (which-key-mode -1)
				 (which-key-mode t)))
    (setq which-key-paging-prefixes '("C-x"))
    (setq which-key-paging-prefixes '("C-c"))
    (setq which-key-paging-key "M-ß")))

(defun peoplesEmacs/core/use-utf-8 ()
  "If you are not Using UTF->=8, get out!"
  (set-default-coding-systems 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq buffer-file-coding-system 'utf-8))

(defun peoplesEmacs/core/setup-packages ()
  "Managing packages is everybodies hobby, isn't it? Or just in
   our basement?"
  ;; I'm still unsure why this line is necessary, but for reference,
  ;; here:
  ;; https://emacs.stackexchange.com/questions/5828/why-do-i-have-to-add-each-package-to-load-path-or-problem-with-require-packag
  ;; https://github.com/jwiegley/use-package/issues/275
  (package-initialize)
  (require 'package)
  (setq package-archives
        (quote
         (("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")
          ("marmalade" . "https://marmalade-repo.org/packages/"))))
  (when (not (require 'use-package nil 'noerror))

    ;; Enabling the following
    (package-refresh-contents)
    (package-install 'use-package))
  (use-package auto-package-update
    :ensure t
    :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-hide-results t)
    (auto-package-update-maybe) ))

(defun peoplesEmacs/core/use-neo-layout ()
  "When using the neo2 keyboard layout a bunch of things are not
   where they are on querty/quertz.  So peoplesEmacs adapts."
  (global-set-key (kbd "C-ö") ctl-x-map)
  (global-set-key (kbd "M-s-j") 'other-window)
  (global-set-key (kbd "C-ö g") 'magit-status)
  (global-set-key (kbd "C-f") 'isearch-forward)
  (global-set-key (kbd "C-ä") mode-specific-map)
  (define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
  (global-set-key (kbd "C-s") 'save-buffer)
  (use-package evil
    :ensure t
    :config
    (evil-mode)
    (setq evil-default-state 'emacs)))

(defun peoplesEmacs/core/no-clutter ()
  (setq custom-file "~/customize")
  (let '(tmp_dir "~/cacheAndTmp/emacs_auto_save")
    '((setq backup-directory-alist
            '((".*" . ,"~/cacheAndTmp/emacs_auto_save")))
      (setq auto-save-file-name-transforms
            '((".*" ,tmp_dir)))
      (setq auto-save-list-file-prefix tmp_dir))))

(defun peoplesEmacs/core/theme ()
  "Eventually replace by own theme."
  (use-package monokai-theme
    :ensure t
    :config
    (load-theme 'monokai t t)
    (set-background-color "black")
    (custom-set-faces
     '(font-lock-comment-face
       ((t (:background "#202020" :foreground "#75715E")))))))

(defun peoplesEmacs/helper/prog-mode-hl-line-mode ()
  "Enable a non-annoying hl-line-mode."
  (setq-default hl-line-range-function
		#'(lambda () (save-excursion
			  (cons (progn (beginning-of-visual-line) (point))
				(progn (end-of-visual-line) (point))))))
  (hl-line-mode))

(setq-default blubb
	      '((name . "Helm at the Emacs")
		(candidates . ("Office Code Pro 9" "Go MONO 9" "GO 9"
			       "Hack 9" "Monaco 9" "Fira-Mono 9"
			       "Fira-Mono Code 9" "Office Code Pro 12"
			       "Go MONO 12" "GO 12" "Hack 12"
			       "Monaco 12" "Fira-Mono 12"
			       "Fira-Mono Code 12"
			       "Office Code Pro 15" "Go	MONO 15"
			       "GO 15" "Hack 15" "Monaco 15"
			       "Fira-Mono 15" "Fira-Mono Code 15"))
		(action . (lambda (candidate)
			    (set-frame-font candidate nil t)))))

(defun pE/font-selction ()
  "Select a Font."
  (interactive)
  (helm :sources '(blubb)))

(defun peoplesEmacs/core/font ()
  "Ok, this function is not going to pretty because it will not
   last for ever and will possibly die as a construction side.
   There is a list of fonts, which are supposed to get checked
   first if they are somehow available on the system. Then set
   them for different modes/languages
   https://emacs.stackexchange.com/questions/3038/using-a-different-font-for-each-major-mode:

   Some of the fonts are go - https://blog.golang.org/go-fonts
   Iosevka - https://github.com/be5invis/Iosevka - this one has
             many features, it seems
   Monaco - well Monaco
   Source-code-pro ->> Office-Code-pro
                   - https://github.com/nathco/Office-Code-Pro
   hack - https://github.com/source-foundry/Hack"
  ;; (set-frame-font "Office Code Pro" nil t)
  ;; (set-frame-font "Go MONO" nil t)
  (set-frame-font "Go MONO 9" nil t)
  (use-package fill-column-indicator
    :delight
    :ensure t
    :hook (prog-mode mail-mode text-mode) . 'fci-mode)
  ;; (set-frame-font "Monaco 11" nil t)
  ;; (set-frame-font "Fira-Mono10" nil t)
  (add-hook 'prog-mode-hook #'peoplesEmacs/helper/prog-mode-hl-line-mode)
  (add-hook 'text-mode-hook #'hl-line-mode))

(defun peoplesEmacs/core/editing ()
  (delete-selection-mode t)
  (use-package undo-tree
    :diminish ""
    :ensure t
    :init (global-undo-tree-mode t)
    :config (setq-default undo-tree-visualizer-diff t
       	                  undo-tree-visualizer-timestamps t)
    :bind
    ("C-z" . undo-tree-undo)
    ("C-Z" . undo-tree-redo)
    ("C-x C-z" . undo-tree-visualize))
  (use-package expand-region
    :ensure t
    :bind ("C-@" . er/expand-region))
  (use-package autopair
    :ensure t)
  (use-package paredit
    :delight
    :ensure t
    :hook ((lisp-mode eval-expression-minibuffer-setup lisp-mode lisp-inetraction emacs-lisp-mode ielm-mode clojure-mode clojurec-mode clojurescript-mode common-lisp-mode slime-mode scheme-mode) . 'enable-paredit-mode))
  (use-package aggressive-indent
    :ensure t
    :delight
    :hook ((prog-mode) . aggressive-indent-mode)))

(defun peoplesEmacs/core/visuals ()
  (global-prettify-symbols-mode)
  (custom-set-variables
   '(company-quickhelp-color-background "black")
   '(company-quickhelp-color-foreground "medium blue")
   '(company-quickhelp-delay 0.3))
  (custom-set-faces'(flycheck-error ((t (:underline (:color "#F92672" :style wave))))))
  (show-paren-mode t)
  (use-package nlinum-relative
    :ensure t
    :delight
    :hook ((prog-mode text-mode) . nlinum-relative-mode))
  (use-package beacon
    :ensure t
    :delight
    :hook ((prog-mode text-mode) . beacon-mode))
  (column-number-mode t)
  (line-number-mode -1)
  (use-package whitespace
    :diminish ""
    :ensure t
    :config
    (custom-set-variables
     '(whitespace-style
       '(face trailing tabs))))
  (add-hook 'text-mode-hook 'whitespace-mode)
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (use-package ws-trim
    :ensure t
    :delight
    :config (global-ws-trim-mode t))
  (use-package highlight-symbol
    :ensure t
    :diminish ""
    :config
    (add-hook 'prog-mode-hook 'highlight-symbol-mode)
    (setq highlight-symbol-idle-delay 0.5))
  (setq truncate-partial-width-windows nil)
  (setq word-wrap t)
  (size-indication-mode t)
  (use-package paren
    :diminish ""
    :ensure t
    :init (show-paren-mode 1)
    :config
    (setq-default show-paern-delay nil)
    (set-face-background 'show-paren-match "yellow")
    (set-face-foreground 'show-paren-match "purple")
					;(set-face-attribute 'show-paren-match-face :weight 'extra-bold)
    )
  (use-package rainbow-mode
    :diminish ""
    :ensure t
    :config
    (add-hook 'text-mode-hook 'rainbow-mode)
    (add-hook 'prog-mode-hook 'rainbow-mode)
					;(add-hook 'special-mode-hook 'rainbow-mode)
    )
  (use-package rainbow-delimiters
    :diminish ""
    :ensure t
    :hook ((prog-mode ielm-mode LaTeX-mode org-mode ipython-mode) . rainbow-delimiters-mode)
    :config
    (custom-set-faces
     '(rainbow-delimiters-depth-1-face ((t (:foreground "blue" :height 1.0))))
     '(rainbow-delimiters-depth-2-face ((t (:foreground "green" :height 1.0))))
     '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow" :height 1.0))))
     '(rainbow-delimiters-depth-4-face ((t (:foreground "violet" :height 1.0))))
     '(rainbow-delimiters-depth-5-face ((t (:foreground "red"))))
     '(rainbow-delimiters-depth-6-face ((t (:foreground "orange"))))
     '(rainbow-delimiters-depth-7-face ((t (:foreground "cyan"))))
     '(rainbow-delimiters-depth-8-face ((t (:foreground "black" :height 1.0))))
     '(rainbow-delimiters-mismatch-face ((t (:foreground "red" :height 1.0))))
     '(rainbow-delimiters-unmatched-face ((t (:foreground "red" :height 1.0)))))))
;; TODO speedbar configuration
;; (use-package minimap
;;   :ensure t
;;   :bind ([f7] . minimap-mode))
;;


(defun peoplesEmacs/core/navigationAndWindowing ()
  (winner-mode t))


;;;  #################################################################
;;;                                                                  #
;;;  Config:                                                         #
;;;                                                                  #
;;;  The following first sets the possibly desired settings and      #
;;;  executes the neccessary configurations followed by customizing  #
;;;  packages from elpa/melpa/marmelade/gnu.                         #
;;;                                                                  #
;;;  #################################################################


;; TODO: put a new version of org-mode in a script with a reasonable
;; PATH
(add-to-list 'load-path "~/progBin/org-mode/lisp")
(add-to-list 'load-path "~/progBin/org-mode/contrib/lisp")

(peoplesEmacs/core/setup-packages)
(peoplesEmacs/core/no-fluff)
(peoplesEmacs/core/use-utf-8)
(when (eval peoplesEmacs/core/neo-layout-used?)
  (peoplesEmacs/core/use-neo-layout))
(peoplesEmacs/core/no-clutter)
(peoplesEmacs/core/history)
(peoplesEmacs/core/theme)
(peoplesEmacs/core/font)
(peoplesEmacs/core/editing)
(peoplesEmacs/core/checkers)
(peoplesEmacs/core/projects)
(peoplesEmacs/core/folding)
(peoplesEmacs/core/completion)
(peoplesEmacs/core/visuals)


;; hookedi hook
(setq-local eldoc-documentation-function #'ggtags-eldoc-function)
(add-hook 'prog-mode-hook #'(lambda ()
			      (helm-gtags-mode)
			      (semantic-mode)
			      (auto-fill-mode)))
(global-set-key (kbd "<f9>") 'ispell-word)
(global-set-key (kbd "<f12>") 'ispell-buffer)
(global-set-key (kbd "C-<f12>") 'flyspell-buffer)
(with-eval-after-load "ispell"
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "english,german8")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "english,german8"))
(add-hook 'text-mode-hook 'flyspell-mode)
(global-set-key (kbd "<f10>") 'edebug-set-breakpoint)


;;; Future projects build your own mode line
;; inspriation from:
;; https://github.com/flycheck/flycheck-color-mode-line
;; https://github.com/milkypostman/powerline
;; https://emacs.stackexchange.com/questions/13836/how-to-abbreviate-version-control-information-in-the-mode-line
;; https://www.emacswiki.org/emacs/ModeLineConfiguration


(use-package dictcc
  :ensure t)

;; TODO
(use-package multiple-cursors
  :ensure t
  :delight
  :config
  :hook ((prog-mode text-mode) . multiple-cursors-mode)
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

(use-package smartparens
  :ensure t)

(use-package hungry-delete
  :ensure t)

(use-package move-text
  :ensure t)

(use-package ranger
  :ensure t
  :bind ("C-x r r" . ranger))

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (emms-add-directory-tree "~/music")
  (emms-all)
  (emms-default-players))

(use-package gist
  :ensure t)

(use-package multi-term
  :ensure t
  :config
  (setq multi-term-dedicated-skip-other-window-p t)
  (setq multi-term-dedicated-select-after-open-p t)
  :bind ("C-S-t" . multi-term))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "")
  (setq dashboard-startup-banner nil)
  (setq dashboard-items '((bookmarks .12)
			  (projects .7)
			  (recents . 20)
			  (agenda . 25))))

(use-package hackernews
  :ensure t)

(use-package md4rd
  :ensure t)

(use-package helm-google
  :ensure t)

(use-package sx
  :ensure t)

(defun pE/org-config ()
  "Configs for org-mode"
  (use-package org-bullets
    :ensure t
    :init
    (setq org-bullets-bullet-list
	  '("◉" "◎" "<img draggable="false" class="emoji" alt="⚫" src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/svg/26ab.svg">" "○" "►" "◇"))
    ;; (setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "<img draggable="false" class="emoji" alt="✔" src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/svg/2714.svg"> DONE(d)")
    ;; 			      (sequence "⚑ WAITING(w)" "|")
    ;; 			      (sequence "|" "✘ CANCELED(c)")))
    :hook (org-mode . org-bullets-mode))
  (use-package calfw
    :ensure t)
  (use-package calfw-org
    :ensure t)
  (use-package calfw-cal
    :ensure t)
  (calendar-set-date-style 'iso)
  (setq org-src-fontify-natively t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (ipython . t)
     (octave . t)
     (haskell . t)
     (maxima . t)
     (fortran . t)))
  (setq  org-confirm-babel-evaluate 'nil)
  (defun my-org-mode-hook ()
    (add-hook 'completion-at-point-functions
	      'pcomplete-completions-at-point nil t))
  (add-hook 'org-mode-hook #'my-org-mode-hook)
  (setq org-log-done t)
					;(org-babel-load-file
					;"~/.emacs.d/personal/personal-org-mode-config.org")
  
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown nil)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled nil)
  (setq org-agenda-skip-timestamp-if-deadline-is-shown nil)
  (setq org-agenda-skip-timestamp-if-done t)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c A") (kbd "C-c a a")))
(pE/org-config)
;;; Langs and major modes-etc
(use-package elpy
  :ensure t
  :delight)
(use-package py-autopep8
  :ensure t
  :delight)


(use-package latex-math-preview
  :ensure t
  :delight
  :after (tex))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-mode)
  :config
  (auto-fill-mode)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master t)
					;  (latex-preview-pane-enable)
  (setq-default TeX-electric-math '("$" . "$"))
  (setq-default TeX-electric-sub-and-superscript t)
  (setq-default LaTeX-electric-left-right-brace t)
  ;; (add-hook 'LaTeX-mode-hook '(lambda ()
  ;; 				(TeX-PDF-mode 1)
  ;; 				(TeX-source-correlate-mode 1)
  ;; 				(TeX-fold-mode 1)))

  ;; PDF Viewer

  (add-to-list 'TeX-view-program-selection
               '(output-pdf "Evince"))

					;:hook
  (setq fill-column 80)
  (auto-fill-mode t)
  (autopair-mode -1)
  (TeX-PDF-mode 1)
  (TeX-source-correlate-mode 1)
  (TeX-fold-mode 1))

(use-package notmuch
  :ensure t
  :config (org-babel-load-file "~/.emacs.d/private/notmuch.org"))

;; (provide 'init)
;;; init.el ends here
