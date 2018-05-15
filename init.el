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
  (setq inital-scratch-message nil)
  (peoplesEmacs/core/no-prompts)
  (blink-cursor-mode nil))

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
  (global-set-key (kbd "C-ö") ctl-x-map)
					;(use-package evil
					;  :ensure t
					;  ;:config
					;  ))
  )
(defun peoplesEmacs/core/theme () ;;
  "Eventually replace by own theme"
  (use-package monokai-theme
    :ensure t
    :config
    (load-theme 'monokai t t)
    (set-background-color "black")))


(defun peoplesEmacs/helper/prog-mode-hl-line-mode ()
  (setq hl-line-range-function
	#'(lambda () (save-excursion
		       (cons (progn (beginning-of-visual-line) (point))
			     (progn (end-of-visual-line) (point))))))
  (hl-line-mode))

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

(peoplesEmacs/no-fluff)
(peoplesEmacs/core/use-utf-8)
(when (eval peoplesEmacs/core/neo-layout-used?) (peoplesEmacs/core/use-neo-layout))
(peoplesEmacs/core/setup-packages)
(peoplesEmacs/core/history)
(peoplesEmacs/core/theme)
(peoplesEmacs/core/editing)

(use-package nlinum-relative
  :ensure t
  :delight
  :hook ((prog-mode text-mode) . nlinum-relative-mode))

(use-package beacon
  :ensure t
  :delight
  :hook ((prog-mode text-mode) . beacon-mode))


(use-package helm
  :delight 
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
  ("C-x b " . helm-for-files))


(use-package delight
  :ensure t
  :delight)
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
;; ;;; init.el ends here
