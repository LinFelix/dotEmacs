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


(defun peoplesEmacs/no-prompts  ()
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq vc-follow-symlinks t))

(defun peoplesEmacs/no-fluff ()
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (setq inital-scratch-message nil)
  (peoplesEmacs/no-prompts))

(defun peoplesEmacs/use-utf-8 ()
  (set-default-coding-systems 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq buffer-file-coding-system 'utf-8))

(defun peoplesEmacs/setup-packages ()
  (package-initialize)
  (require 'package)
  (setq package-archives
        (quote
         (("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")
          ("marmalade" . "https://marmalade-repo.org/packages/"))))
  (package-refresh-contents)
  (when (not (require 'use-package nil 'noerror))
           (package-refresh-contents)
           (package-install 'use-package))
  (use-package auto-package-update
    :ensure t
    :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-hide-results t)
    (auto-package-update-maybe)))

(defun peoplesEmacs/use-neo-layout ()
  (global-set-key (kbd "C-ö") ctl-x-map)
  (setq peoplesEmacs/neo-layout-used? t)
  (use-package evil
    :ensure t
    ;:config
    ))
    
;;; Config:

;; I'm still unsure why this line is necessary, but for reference, here:
;; [[https://emacs.stackexchange.com/questions/5828/why-do-i-have-to-add-each-package-to-load-path-or-problem-with-require-packag]]
;; [[https://github.com/jwiegley/use-package/issues/275]]
(package-initialize)

;; TODO: put a new version of org-mode in a script with a reasonable
;; PATH
(add-to-list 'load-path "~/progBin/org-mode/lisp")
(add-to-list 'load-path "~/progBin/org-mode/contrib/lisp")

(peoplesEmacs/no-fluff)
(peoplesEmacs/use-utf-8)
(peoplesEmacs/setup-packages)
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

;; ;; set font
;; (add-to-list 'default-frame-alist
;;              '(font . "Fira Mono-10"))

;; ;; get a theme
;; (use-package dracula-theme
;;   :ensure t
;;   :config (load-theme 'dracula t)
;;   (set-background-color "black"))

;; ;; notmuch configuration
;; (use-package notmuch
;;   :ensure t
;;   :config (org-babel-load-file "~/.emacs.d/private/notmuch.org"))

;; (provide 'init)
;; ;;; init.el ends here
