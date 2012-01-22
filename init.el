(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-cleanup-whitespace t)
 '(js2-indent-on-enter-key t)
 '(js2-enter-indents-newline t))

;; increase font size
(set-face-attribute 'default nil :height 130)
;; hard code back/fore ground color, so that we get simular editing
;; experience in both cocoa and -nw mode 
(setq default-frame-alist '((background-color . "white")
                            (foreground-color . "black")))

(menu-bar-mode)
(scroll-bar-mode)
(tabbar-mode)
(global-hl-line-mode)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (require 'solarized-dark-theme)
;; (load-theme 'whiteboard)
(require 'smart-tab)
(require 'extend-selection)
(require 'select-text-in-quote)


(setq ruby-indent-level 2)
(setq ring-bell-function 'ignore)
(setq scheme-program-name "mzscheme")
(add-hook 'scheme-mode-hook '(lambda()(paredit-mode 1)))


(global-set-key (kbd "TAB") 'smart-tab)
(global-set-key (kbd "<f1>") 'find-file-in-project)
(global-set-key (kbd "C-x C-\\") 'goto-last-change)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "M-8") 'extend-selection)
(global-set-key (kbd "M-9") 'select-text-in-quote)


(setq ffip-patterns '("*.xml" "*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.py" "*.rb" "*.rake" "*.js" "*.pl"
    "*.sh" "*.erl" "*.hs" "*.ml" "*.scm" "*.erb" "*.rxml" "*.java" ))

(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)  
