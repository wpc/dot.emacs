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

(setq-default fill-column 120)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (require 'solarized-dark-theme)
;; (load-theme 'whiteboard)
;; (require 'smart-tab)
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

(add-hook 'rhtml-mode-hook
          (lambda ()
            (yas/minor-mode 1)))
          

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

;; ruby-mode

(add-hook 'ruby-mode-hook
          #'(lambda ()
              (setq ruby-indent-level 2)))


(setq ring-bell-function 'ignore)
(setq scheme-program-name "mzscheme")
(add-hook 'scheme-mode-hook '(lambda()(paredit-mode 1)))


(defun ruby-get-containing-block ()
  (let ((pos (point))
        (block nil))
    (save-match-data
      (save-excursion
        (catch 'break
          ;; If in the middle of or at end of do, go back until at start
          (while (and (not (looking-at "do"))
                      (string-equal (word-at-point) "do"))
            (backward-char 1))
          ;; Keep searching for the containing block (i.e. the block that begins
          ;; before our point, and ends after it)
          (while (not block)
            (if (looking-at "do\\|{")
                (let ((start (point)))
                  (ruby-forward-sexp)
                  (if (> (point) pos)
                      (setq block (cons start (point)))
                    (goto-char start))))
            (if (not (search-backward-regexp "do\\|{" (point-min) t))
                (throw 'break nil))))))
        block))

(defun ruby-goto-containing-block-start ()
  (interactive)
  (let ((block (ruby-get-containing-block)))
    (if block
        (goto-char (car block)))))

(defun ruby-flip-containing-block-type ()
  (interactive)
  (save-excursion
    (let ((block (ruby-get-containing-block)))
      (goto-char (car block))
      (save-match-data
        (let ((strings (if (looking-at "do")
                           (cons
                            (if (= 3 (count-lines (car block) (cdr block)))
                                "do\\( *|[^|]+|\\)? *\n *\\(.*?\\) *\n *end"
                              "do\\( *|[^|]+|\\)? *\\(\\(.*\n?\\)+\\) *end")
                            "{\\1 \\2 }")
                         (cons
                          "{\\( *|[^|]+|\\)? *\\(\\(.*\n?\\)+\\) *}"
                          (if (= 1 (count-lines (car block) (cdr block)))
                              "do\\1\n\\2\nend"
                            "do\\1\\2end")))))
          (when (re-search-forward (car strings) (cdr block) t)
           (replace-match (cdr strings) t)
            (delete-trailing-whitespace (match-beginning 0) (match-end 0))
            (indent-region (match-beginning 0) (match-end 0))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "<escape>") 'hippie-expand)
(global-set-key (kbd "C-x C-\\") 'goto-last-change)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "M-8") 'extend-selection)
(global-set-key (kbd "M-9") 'select-text-in-quote)
(global-set-key (kbd "C-M-<backspace>") 'backward-kill-sexp)


(setq ffip-patterns '("*.xml" "*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.py" "*.rb" "*.rake" "*.js" "*.pl"
    "*.sh" "*.erl" "*.hs" "*.ml" "*.scm" "*.erb" "*.rxml" "*.java" "*.scss" "*.css" "*.coffee" ))


;; duplicate line
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))

(global-set-key (kbd "C-c C-d") 'duplicate-line)


(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)  

