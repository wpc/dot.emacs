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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "apple" :family "Monaco")))))


(menu-bar-mode)
(scroll-bar-mode)
(tabbar-mode)
(global-hl-line-mode)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (require 'solarized-dark-theme)
(require 'smart-tab)
(require 'extend-selection)
(require 'select-text-in-quote)


(setq ruby-indent-level 2)
(setq ring-bell-function 'ignore)


(global-set-key (kbd "TAB") 'smart-tab)
(global-set-key (kbd "C-x f") 'find-file-in-project)
(global-set-key (kbd "C-x C-\\") 'goto-last-change)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "M-8") 'extend-selection)
(global-set-key (kbd "M-*") 'select-text-in-quote)
