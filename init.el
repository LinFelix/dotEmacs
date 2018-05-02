;;; Commentary:
;; This is like my 4th Emacs config. It's mainly inspired by
;; github.com/exot and spacemacs. You can use it for whatever you want
;;

;;; License:
;;
;; ----------------------------------------------------------------------------
;; "THE BEER-WARE LICENSE" (Revision 42):
;; As long as you retain this notice you
;; can do whatever you want with this stuff. If we meet some day, and you think
;; this stuff is worth it, you can buy me a beer in return.   Felix alias Lin ()
;; ----------------------------------------------------------------------------


;;; Code:
;; (package-initialize)

;; (add-to-list 'load-path "~/progBin/org-mode/lisp")
;; (add-to-list 'load-path "~/progBin/org-mode/contrib/lisp")
;; ;;  we want a couple of sane defaults
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (which-key use-package smartparens ranger rainbow-mode rainbow-delimiters py-autopep8 paredit ob-ipython multiple-cursors multi-term magit linum-relative latex-preview-pane latex-math-preview indent-guide highlight-symbol helm-projectile helm-c-yasnippet ggtags flycheck fill-column-indicator expand-region evil emms elscreen elpy diminish diff-hl dashboard company-statistics calfw beacon autopair auctex aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
