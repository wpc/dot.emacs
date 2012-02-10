(server-start)

(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-cleanup-whitespace t)
 '(js2-indent-on-enter-key t)
 '(js2-enter-indents-newline t)
 '(ido-ubiquitous-enabled nil)
 '(js-indent-level 2))

;; increase font size
(set-face-attribute 'default nil :height 130)
;; hard code back/fore ground color, so that we get simular editing
;; experience in both cocoa and -nw mode 
(setq default-frame-alist '((background-color . "white")
                            (foreground-color . "black")))
(setq initial-frame-alist '((top . 50)
                            (left . 50)
                            (width . 135)
                            (height . 42)))
;; fix css-mode indentation problem
;; (http://www.stokebloke.com/wordpress/2008/03/21/css-mode-indent-buffer-fix/)
(setq cssm-indent-level 4)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-mirror-mode nil)


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

;; ruby-compilation
(require 'ruby-compilation)
(setenv "JAVA_OPTS" "-d32 -client")
(setenv "JRUBY_OPTS" "--1.9")
 

;; textmate
(add-to-list 'load-path "~/.emacs.d/site-lisp/textmate.el")
(require 'textmate)
(textmate-mode)

(defun is-rails-project ()
  (when (textmate-project-root)
    (file-exists-p (expand-file-name "config/environment.rb" (textmate-project-root)))))

(defun cd-project-root (&optional args)
  (interactive "P")
  (cd (textmate-project-root)))

(defun rgrep-in-project (regexp &optional files dir confirm)
  "rgrep through textmate-project-root"
   (interactive
   (progn
     (grep-compute-defaults)
     (cond
      ((and grep-find-command (equal current-prefix-arg '(16)))
       (list (read-from-minibuffer "Run: " grep-find-command
				   nil nil 'grep-find-history)))
      (t (let* ((regexp (grep-read-regexp))
		(files (grep-read-files regexp))
		(dir (textmate-project-root))
		(confirm (equal current-prefix-arg '(4))))
	   (list regexp files dir confirm))))))
   (rgrep regexp files dir confirm))

(defun run-rails-test-or-ruby-buffer ()
  (interactive)
  (if (is-rails-project)
      (let* ((path (buffer-file-name))
             (filename (file-name-nondirectory path))
             (test-path (expand-file-name "test" (textmate-project-root)))
             (command (list ruby-compilation-executable "-I" test-path path)))
        (pop-to-buffer (ruby-compilation-do filename command)))
    (ruby-compilation-this-buffer)))

(global-set-key [(super r)] 'run-rails-test-or-ruby-buffer)

;; rvm
(add-to-list 'load-path "~/.emacs.d/site-lisp/rvm.el")
(require 'rvm)
(rvm-use-default)


;; rhtml
(add-to-list 'load-path "~/.emacs.d/site-lisp/rhtml.git")
(require 'rhtml-mode)

;; speedbar config
(setq speedbar-show-unknown-files t)
(add-hook 'speedbar-mode-hook 
    (lambda () 
        (auto-raise-mode 1) 
        (add-to-list 'speedbar-frame-parameters '(top . 50)) 
        (add-to-list 'speedbar-frame-parameters '(left . 1190))
        (add-to-list 'speedbar-frame-parameters '(width . 25))
    )
)



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
    "*.sh" "*.erl" "*.hs" "*.ml" "*.scm" "*.erb" "*.rxml" "*.java" "*.scss" "*.css" "*.coffee" ))

(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)  

