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
    (add-to-list 'recentf-exclude "~/.emacs.d/games/*")
    (add-to-list 'recentf-exclude "~/.emacs.d/elpa/*")
    (add-to-list 'recentf-exclude "\\\*Org Src *.org\[ * \]\*")))

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
    :delight))

(defun peoplesEmacs/core/checkers ()
  "Text."
  nil)

(defun _peoplesEmacs/core/vc ()
  "Text."
  nil)

(defun peoplesEmacs/core/projects ()
  "Projectmanagement configuration."
  (use-package projectile
    :ensure t
    :delight '(:eval (concat "P[" (projectile-project-name) "]")))
  (global-ede-mode t)
  (_peoplesEmacs/core/vc))

(defun peoplesEmacs/core/folding ()
  "Text.")

(defun peoplesEmacs/core/completion ()
  "Text.")

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
					;(package-refresh-contents)
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
					;(use-package evil
					;  :ensure t
					;  ;:config
					;  ))
  )

(defun peoplesEmacs/core/no-clutter ()
  (setq custom-file "~/customize")
  
  (let '(tmp_dir "~/cacheAndTmp/emacs_auto_save")
    '((setq backup-directory-alist
            '((".*" . ,"~/cacheAndTmp/emacs_auto_save")))
      (setq auto-save-file-name-transforms
            '((".*" ,tmp_dir)))
      (setq auto-save-list-file-prefix tmp_dir))))

(defun peoplesEmacs/core/theme () ;;
  "Eventually replace by own theme."
  (use-package monokai-theme
    :ensure t
    :config
    (load-theme 'monokai t t) 
    (set-background-color "black")
    (custom-set-faces
     '(font-lock-comment-face ((t (:background "#202020" :foreground "#75715E")))))))


(defun peoplesEmacs/helper/prog-mode-hl-line-mode ()
  "Enable a non-annoying hl-line-mode."
  (setq-default hl-line-range-function
		#'(lambda () (save-excursion
			       (cons (progn (beginning-of-visual-line) (point))
				     (progn (end-of-visual-line) (point))))))
  (hl-line-mode))

(setq-default blubb
	      '((name . "Helm at the Emacs")
		(candidates . ("Office Code Pro" "Go MONO" "GO" "Hack" "Monaco" "Fira-Mono" "Fira-Mono Code"))
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
  (set-frame-font "Hack" nil t)
  ;; (set-frame-font "Monaco 11" nil t)
  ;; (set-frame-font "Fira-Mono10" nil t)

  
  
  (add-hook 'prog-mode-hook #'peoplesEmacs/helper/prog-mode-hl-line-mode)
  (add-hook 'text-mode-hook #'hl-line-mode))

(defun peoplesEmacs/core/editing ()
  (show-paren-mode t)
  (delete-selection-mode t))

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
(when (eval peoplesEmacs/core/neo-layout-used?) (peoplesEmacs/core/use-neo-layout))
(peoplesEmacs/core/no-clutter)
(peoplesEmacs/core/history)
(peoplesEmacs/core/theme)
(peoplesEmacs/core/font)
(peoplesEmacs/core/editing)


;;; ** Core Modes:
(use-package paredit
  :delight
  :ensure t
  :hook ((lisp-mode eval-expression-minibuffer-setup lisp-mode lisp-inetraction emacs-lisp-mode ielm-mode clojure-mode clojurec-mode clojurescript-mode common-lisp-mode slime-mode scheme-mode)
	 . enable-paredit-mode))

(use-package aggressive-indent
  :ensure t
  :delight
  :hook ((prog-mode) . aggressive-indent-mode))

(use-package nlinum-relative
  :ensure t
  :delight
  :hook ((prog-mode text-mode) . nlinum-relative-mode))

(use-package  yasnippet
  :delight
  :ensure t
  :init
  (add-hook 'after-init-hook 'yas-global-mode)
  (setq-default yas-snippet-dirs
		'("~/.emacs.d/snippets/yasnippet-snippets" ;; from AndreaCrotti/yasinppet-snippets
		  "~/my_snippets" ;; my own snippets
		  ))
  (setq-default yas-prompt-functions '(yas-completing-prompt))
  :config
  (setq yas-triggers-in-field t
	yas-wrap-around-region t))

(use-package company
  :ensure t
  :delight
  :after (gtags))

(use-package beacon
  :ensure t
  :delight
  :hook ((prog-mode text-mode) . beacon-mode))


(use-package helm
  :delight helm-mode
  :ensure t
  :init (helm-mode t)
  :config
  (setq helm-autoresize-mode 1)
  (setq helm-autoresize-min-height 0)
  (setq helm-autoresize-max-height 80)
  (setq-default helm-ff-file-name-history-use-recentf t)
  (setq-default helm-split-window-in-side-p t)
  :bind
  ("M-ö" . helm-M-x)
  ("C-x r b" . helm-filtered-bookmarks)
  ("C-ö C-f" . helm-find-files)
  ("C-x C-b" . helm-buffers-list)
  ("C-x b " . helm-for-files)
  ("M-f" . helm-occur)
  ("M-F" . helm-projectile-grep))

;; which-key # shows the following possible key strokes and what they do
(use-package which-key
  :delight
  :ensure t
  ;; :init (which-key-mode t)
  :config
  (which-key-setup-minibuffer)
  (setq which-key-idle-delay 0.2)
  (setq which-key-special-keys '("SPC" "TAB" "RET" "ESC" "DEL"))
  (add-hook 'after-init-hook (
  			      lambda ()
  				     ;; this is a work around because which
  				     ;; key wasn't showing
  				     ;; »Did you try turning it of on again
  				     (which-key-mode -1)
				     (which-key-mode t)))
  (setq which-key-paging-prefixes '("C-x"))
  (setq which-key-paging-prefixes '("C-c"))
  (setq which-key-paging-key "M-ß"))

(use-package dictcc
  :ensure t)

;; TODO
(use-package multiple-cursors
  :ensure t)

(use-package smartparens
  :ensure t)

(use-package hungry-delete
  :ensure t)

(use-package move-text
  :ensure t)

(use-package expand-region
  :ensure t)

(use-package gtags
  :ensure t
  :delight)

;;; Langs and major modes-etc

(use-package latex-math-preview
  :ensure t
  :delight
  :after (tex))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-mode)
  :config
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

;; we want a couple of sane defaults
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/sanity.org")

;; ;; we want a nice layout
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/layout.org")

;; ;; langtools
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/langsupport.org")

;; ;; langs
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/langs.org")

;; ;; completion
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/completions.org")

;; ;; otter tools
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/otters.org")

;; ;; org
;; (org-babel-load-file "~/.emacs.d/peoplesEmacs/org.org")

;; ;; notmuch configuration
;; (use-package notmuch
;;   :ensure t
;;   :config (org-babel-load-file "~/.emacs.d/private/notmuch.org"))

;; (provide 'init)
;;; init.el ends here
