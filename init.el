;;; Commentary:

;;; Code:
(package-initialize)

(add-to-list 'load-path "~/progBin/org-mode/lisp")
(add-to-list 'load-path "~/progBin/org-mode/contrib/lisp")
;;  we want a couple of sane defaults
(org-babel-load-file "~/.emacs.d/peoplesEmacs/sanity.org")

;; we want a nice layout
(org-babel-load-file "~/.emacs.d/peoplesEmacs/layout.org")

;; langtools
(org-babel-load-file "~/.emacs.d/peoplesEmacs/langsupport.org")

;; langs
(org-babel-load-file "~/.emacs.d/peoplesEmacs/langs.org")

;; completion
(org-babel-load-file "~/.emacs.d/peoplesEmacs/completions.org")

;; otter tools
(org-babel-load-file "~/.emacs.d/peoplesEmacs/otters.org")

;; org
(org-babel-load-file "~/.emacs.d/peoplesEmacs/org.org")

;; set font
(add-to-list 'default-frame-alist
             '(font . "Fira Mono-10"))

;; get a theme
(use-package dracula-theme
  :ensure t
  :config (load-theme 'dracula t)
  (set-background-color "black"))

;; notmuch configuration
(use-package notmuch
  :ensure t
  :config (org-babel-load-file "~/.emacs.d/private/notmuch.org"))

(provide 'init)
;;; init.el ends here

