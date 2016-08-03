;;----------------------------------------------------------
;; System-specific Settings
;;----------------------------------------------------------
(cond
 ((string-equal system-type "gnu/linux")
  (defvar running-on-linux t)
  ;; use Windows key as meta
  (setq x-super-keysym 'meta)
  
  (if (string-prefix-p "mobileKong" system-name)
      (set-frame-font "ProggyCleanTT-12")
      ;;(set-default-font "Mono-13"))
    (set-frame-font "Droid Sans Mono-12")))

 ((string-equal system-type "darwin")
  (defvar running-on-mac t)
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'alt)
  (global-unset-key (kbd "<mouse-2>"))
  (global-set-key (kbd "<mouse-2>") 'clipboard-yank)
  (global-unset-key "\M-v")
  (global-set-key "\M-v" 'clipboard-yank)
  ;;(Set-default-font "VeraMono-14")
  ))

;;----------------------------------------------------------
;; Visual Style
;;----------------------------------------------------------

; Set theme similar to gentooish
(load-theme 'wombat t)
;(load-theme 'wheatgrass t)
; Set theme to light, like summerfruit
; (load-theme 'adwaita t)

; Set cursor color to white
(set-cursor-color "#ffffff")

(global-linum-mode t)

;; disable startup message
(setq inhibit-startup-message t)

;;----------------------------------------------------------
;; Package Management
;;----------------------------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(require 'nav)
(require 'f)
;
(defun was-compiled-p (path)
  "Does the directory at PATH contain any .elc files?"
  (--any-p (f-ext? it "elc") (f-files path)))

(defun ensure-packages-compiled ()
  "If any packages installed with package.el aren't compiled yet, compile them."
  (--each (f-directories package-user-dir)
    (unless (was-compiled-p it)
      (byte-recompile-directory it 0))))

(ensure-packages-compiled)

;;----------------------------------------------------------
; Backup management
;;----------------------------------------------------------
; (global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;;----------------------------------------------------------
;; Buffer Management
;;---------------------------------------------------------

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;;----------------------------------------------------------
;; core keybindings
;;----------------------------------------------------------
(global-set-key "\M-w" 'backward-kill-word)

;;----------------------------------------------------------
; Helm: browser
;;----------------------------------------------------------
(global-set-key (kbd "C-c h") 'helm-mini)
(helm-mode 1)

;;----------------------------------------------------------
; FIPLR (Emacs Ctrl-P)
;;----------------------------------------------------------
(require 'fiplr)
(setq fiplr-ignored-globs '((directories (".git" ".svn" ".hg"
					  "bin" "target" "archive" "out" "ui-out" "build"
					  "lib"
					  "repl" ".repl" ".cljs_node_repl" ".cljs_rhino_repl" ".lein-git-deps" 
					  ".gradle" ".cabal-sandbox" "venv" "node_modules" "Pods"))
                            (files ("*.gif" "*.jpg" "*.pdf" "*.png" "*.tif" "*.amz"
				    "*.xls" "*.xlsx" "*.XLS" "*.XLSX"
				    "*.zip" "*.gz"
				    "*.bin" "*.dll" "*.o"
				    "*.class" "*.jar" "*.pyc" 
				    "*.pem" "*.cer" "*.p12" 
				    ".*" "*~" ".#*" "#*#" ".gitignore"))))


(setq fiplr-root-markers '(".git" ".svn" ".fiplr-root"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-\\") 'fiplr-find-file)
(define-key *fiplr-keymap* (kbd "<f5>")   'fiplr-reload-list)

;;----------------------------------------------------------
; CEDET
;;----------------------------------------------------------
; (add-to-list 'load-path "~/.emacs.d/cedet-1.1")
; (load-file "~/.emacs.d/cedet-1.1/cedet-devel-load.el")

;;----------------------------------------------------------
; Emacs Code Browser
;;----------------------------------------------------------

(setq stack-trace-on-error t)
(require 'ecb)
(add-to-list 'load-path "~/.emacs.d/elpa.ecb-2.40")
(load-file "~/.emacs.d/install.el")

(defun my-toggle-ecb ()
  (interactive)
  (if (boundp 'ecb-window-showing)
    (progn (makunbound 'ecb-window-showing)
	   (ecb-deactivate))
      (progn (setq ecb-window-showing t) 
	     (ecb-activate)
	     (ecb-goto-window-directories))))

(global-set-key (kbd "<f3>") 'my-toggle-ecb)
(setq ecb-tip-of-the-day nil)

;;----------------------------------------------------------
; Emacs Nav
;;----------------------------------------------------------

(add-to-list 'load-path "~/.emacs.d/emacs-nav-49")
(require 'nav)
(nav-disable-overeager-window-splitting)
;; Optional: set up a quick key to toggle nav
(global-set-key [f5] 'nav-toggle)


; NREPL
(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)
; Hide NREPL buffers
(setq nrepl-hide-special-buffers t)

; Rainbow Delimiters
(require 'rainbow-delimiters)

; enable in all programming-related modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(show-paren-mode 1)

;;----------------------------------------------------------
;; Emacs Code Browser
;;----------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-path (quote ((#("/" 0 1 (help-echo "Mouse-2 toggles maximizing, mouse-3 displays a popup-menu")) #("/" 0 1 (help-echo "Mouse-2 toggles maximizing, mouse-3 displays a popup-menu")))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; TODO: see if this works out. If not, make it language-specific
(global-set-key (kbd "RET") 'newline-and-indent)

;;----------------------------------------------------------
;; Yasnippet
;;----------------------------------------------------------

(require 'yasnippet)
(yas-global-mode 1)

;;----------------------------------------------------------
;; Auto-Complete
;; NOTE: does this conflict with Company? Should we get rid of this?
;;----------------------------------------------------------

(add-to-list 'load-path "/Users/dk/.emacs.d")
(require 'auto-complete-config)
(ac-config-default)

;;----------------------------------------------------------
;; Tab Completion / Company Mode
;;----------------------------------------------------------

(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;
(setq company-tooltip-align-annotations t)

;;----------------------------------------------------------
;; Evil Mode
;;----------------------------------------------------------

(setq evil-want-C-u-scroll t)
(require 'evil)
(define-key evil-normal-state-map "M-x" 'execute-extended-command)
(evil-mode 1)

(define-key evil-window-map "\C-h" 'evil-window-left)
(define-key evil-window-map "\C-j" 'evil-window-down)
(define-key evil-window-map "\C-k" 'evil-window-up)
(define-key evil-window-map "\C-l" 'evil-window-right)

;;----------------------------------------------------------
;; Flycheck
;;----------------------------------------------------------
(add-hook 'after-init-hook #'global-flycheck-mode)

;; pos-tip for displaying error messages
(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

(require 'pyvenv)

(defun get-current-buffer-flake8 ()
  (executable-find "flake8"))
  ;;(if pyvenv-virtual-env
  ;;    (concat pyvenv-virtual-env "/bin/flake8")
  ;;  nil))

(defun get-current-buffer-pylint ()
  (executable-find "pylint"))
  ;;(if pyvenv-virtual-env
  ;;    (concat pyvenv-virtual-env "/bin/pylint")
  ;;  nil))

;;pyvenv-virtual-env

(defun set-flychecker-executables ()
  "Configure virtualenv for flake8 and lint."
  (when (get-current-buffer-flake8)
    (flycheck-set-checker-executable (quote python-flake8)
				     (get-current-buffer-flake8)))
  (when (get-current-buffer-pylint)
    (flycheck-set-checker-executable (quote python-pylint)
				     (get-current-buffer-pylint))))

(add-hook 'flycheck-before-syntax-check-hook
      #'set-flychecker-executables 'local)

(add-hook 'pyvenv-post-activate-hooks 'set-flychecker-executables)

;;----------------------------------------------------------
;; C
;;----------------------------------------------------------
(defun my-flycheck-c-setup ()
  (setq flycheck-clang-language-standard "gnu99")
  (setq flycheck-gcc-language-standard "gnu99"))

(add-hook 'c-mode-hook #'my-flycheck-c-setup)

;;----------------------------------------------------------
;; Java
;;----------------------------------------------------------
(setq jdee-server-dir "~/.emacs.d/java/")

;;----------------------------------------------------------
;; Groovy
;;----------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.gradle\\'" . groovy-mode))

;;----------------------------------------------------------
;; Lisp / Clojure(script)
;;----------------------------------------------------------

;; Cider
(add-to-list 'load-path "~/.emacs.d/cider-0.12.0")
(require 'cider)
(setq cider-lein-command "~/bin/lein")

(add-hook 'lisp-mode-hook '(lambda ()
			     (local-set-key (kbd "RET") 'newline-and-indent)))

;; (add-hook 'cider-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
;; (add-hook 'cider-mode-hook 'eldoc-mode)
;; (add-hook 'clojure-mode-hook 'eldoc-mode)
;; (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(add-hook 'clojure-mode-hook '(lambda ()
				(local-set-key (kbd "RET") 'newline-and-indent)))

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; Clojure(script)

;; (define-key map "C-l" #'cider-inspector-pop)
(define-key cider-inspector-mode-map "\C-l" 'cider-inspector-pop)

; (add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;(global-set-key (kbd "RET") 'newline-and-indent)
;(local-set-key (kbd "RET") 'newline-and-indent)

; ClojureScript
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

;; flycheck clojure / squiggly
;(eval-after-load 'flycheck '(flycheck-clojure-setup))

;;----------------------------------------------------------
;; Python
;;----------------------------------------------------------


; (pyenv-mode)
(setq exec-path (append exec-path '("~/.pyenv/shims")))
(add-hook 'python-mode-hook
	  (function (lambda ()
		      (setq indent-tabs-mode nil
			    tab-width 4))))

; disable top toolbar
(tool-bar-mode -1)

; shift left and right for next/prev buffer
(global-set-key (kbd "S-<left>") 'previous-buffer)  ; Shift+←
(global-set-key (kbd "S-<right>") 'next-buffer)  ; Shift+←


;;----------------------------------------------------------
;; C
;;----------------------------------------------------------

;; (add-to-list 'auto-mode-alist '("\\.cu\\'" . c-mode))
 
;;----------------------------------------------------------
;; SConstruct
;;----------------------------------------------------------

(define-derived-mode scons-mode python-mode
  (setq mode-name "SConstruct"))

(add-to-list 'auto-mode-alist '("\\SConstruct\\'" . scons-mode))

;;----------------------------------------------------------
;; Rust
;;----------------------------------------------------------

(setq racer-cmd "~/.multirust/toolchains/stable/cargo/bin/racer")
(setq racer-rust-src-path "~/Tools/rust/lang/latest/src")

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

;; flycheck rust
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;----------------------------------------------------------
;; Markdown
;;----------------------------------------------------------
 
(autoload 'markdown-mode "markdown-mode"
 "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))


;;----------------------------------------------------------
; String Manipulation
;;----------------------------------------------------------

(defun to-kebab-case (start end)
  "convert to lispy case. Note that this does not current filter out symbols like [ ] { }"
  (interactive "r")
  (insert (s-dashed-words (delete-and-extract-region start end))))

(defun to-snake-case (start end)
  "convert to C/python case. Note that this does not current filter out symbols like [ ] { }"
  (interactive "r")
  (insert (s-snake-case (delete-and-extract-region start end))))

(defun to-camel-case (start end)
  "convert to camel case. Note that this does not current filter out symbols like [ ] { }"
  (interactive "r")
  (insert (s-lower-camel-case (delete-and-extract-region start end))))

(defun wrap-text (b e txt)
  "simple wrapper"
  (interactive "r\nMEnter text to wrap with: ")
  (save-restriction
    (narrow-to-region b e)
    (goto-char (point-min))
    (insert "(")
    (insert txt)
    (goto-char (point-max))
    (insert ")")))

;;----------------------------------------------------------
;; ---- BEGIN Email client ----
;;----------------------------------------------------------

;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
;;
;; (require 'mu4e)
;; 
;; ;; default
;; (setq mu4e-maildir "~/Maildir")
;; (setq mu4e-drafts-folder "/[Gmail].Drafts")
;; (setq mu4e-sent-folder   "/[Gmail].Sent Mail")
;; (setq mu4e-trash-folder  "/[Gmail].Trash")
;; 
;; ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;; (setq mu4e-sent-messages-behavior 'delete)
;; 
;; ;; setup some handy shortcuts
;; ;; you can quickly switch to your Inbox -- press ``ji''
;; ;; then, when you want archive some messages, move them to
;; ;; the 'All Mail' folder by pressing ``ma''.
;; 
;; (setq mu4e-maildir-shortcuts
;;       '( ("/INBOX"               . ?i)
;;          ("/[Gmail].Sent Mail"   . ?s)
;;          ("/[Gmail].Trash"       . ?t)
;;          ("/[Gmail].All Mail"    . ?a)))
;; 
;; ;; allow for updating mail using 'U' in the main view:
;; (setq mu4e-get-mail-command "offlineimap")
;; 
;; ;; something about ourselves
;; (setq
;;  user-mail-address "davidykay@gmail.com"
;;  user-full-name  "David Young-chan Kay"
;;  message-signature
;;  (concat
;;   "David Y. Kay\n"
;;   "www.DavidYKay.com\n"
;;   "Want to schedule a call with me?\n"
;;   "sohelpful.me/davidykay\n"
;;   "\n"))
;; 
;; ;; sending mail -- replace USERNAME with your gmail username
;; ;; also, make sure the gnutls command line utils are installed
;; ;; package 'gnutls-bin' in Debian/Ubuntu
;; (require 'smtpmail)
;; 
;; ; alternatively, for emacs-24 you can use:
;; (setq message-send-mail-function 'smtpmail-send-it
;;     smtpmail-stream-type 'starttls
;;     smtpmail-default-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-service 587)
;; 
;; ;; don't keep message buffers around
;; (setq message-kill-buffer-on-exit t)

;;----------------------------------------------------------
;; ---- END Email client ----
;;----------------------------------------------------------

;;----------------------------------------------------------
;; ---- Skeleton Mode / File Templates ----
;;----------------------------------------------------------

(defun filename-no-extension (filename)
  (file-name-sans-extension (file-name-nondirectory filename)))

(define-skeleton jekyll-skeleton
  "Generate the scaffolding of a Jekyll blog post"
  nil
  ;"Type title of post: "
  "---"
  \n >
  "layout: post"
  \n >
  "title: " (filename-no-extension (buffer-file-name))
  \n >
  "---"
  \n >)

(define-auto-insert "\\.\\(md\\)\\'" 'jekyll-skeleton)

(defun make-jekyll-filename (title)
  (s-replace " " "-"
	     (make-jekyll-title title)))

(defun make-jekyll-title (title)
	     (capitalize title))

(defun make-jekyll-post (title)
  "Generate a Jekyll post"
  (interactive "sTitle of blog post?")
  (message "Converted title: %s" (make-jekyll-title title))
  (let ((filename (make-jekyll-filename title))
	(title (make-jekyll-title title)))
    (generate-new-buffer filename)
    (switch-to-buffer filename)
    (jekyll-skeleton title)))

;;(eval-after-load 'autoinsert
;;  '(define-auto-insert
;;     '("\\.\\(md\\)\\'" "jekyll blog post")
;;     '(nil
;;       "---" \n
;;       "layout: post"
;;       "title: " str
;;       (file-name-nondirectory (buffer-file-name)) \n
;;       "---" \n
;;       > _ \n

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(clj\\)\\'" . "Clojure skeleton")
     '(
       nil
       ;"Short description: "
       ";;" \n
       ";; " (filename-no-extension (buffer-file-name))
       ";; " \n
       ";;" > \n \n
       "(ns myproject." (filename-no-extension (buffer-file-name)) \n 
       "(:require [clojure.string :refer [join]]))" \n 
       \n
       "(defn main []" \n
       > _ \n
       ")" > \n)))

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(CC?\\|cc\\|cxx\\|cpp\\|c++\\)\\'" . "C++ skeleton")
     '("Short description: "
       "/*" \n
       (file-name-nondirectory (buffer-file-name))
       " -- " str \n
       " */" > \n \n
       "#include <iostream>" \n \n
       "using namespace std;" \n \n
       "main()" \n
       "{" \n
       > _ \n
       "}" > \n)))


;; 
;; (eval-after-load 'autoinsert
;;   '(define-auto-insert '("\\.c\\'" . "C skeleton")
;;      '(
;;        "Short description: "
;;        "/**\n * "
;;        (file-name-nondirectory (buffer-file-name))
;;        " -- " str \n
;;        " *" \n
;;        " * Written on " (format-time-string "%A, %e %B %Y.") \n
;;        " */" > \n \n
;;        "#include <stdio.h>" \n
;;        "#include \""
;;        (file-name-sans-extension
;;         (file-name-nondirectory (buffer-file-name)))
;;        ".h\"" \n \n
;;        "int main()" \n
;;        "{" > \n
;;        > _ \n
;;        "}" > \n)))

;;----------------------------------------------------------
;; Plugins to try
;;----------------------------------------------------------

; parinfer - infer parenthesis for lisp

; ido	similar to helm	
; magit	Everything about git	None
; git-gutter.el	Mark the VCS (git, subversion …) diff
; company-mode	code completion	auto-complete

; Org	Get Things Done (GTD)	none
; expand-region	selection region efficiently	none
; smex	Input command efficiently	none
; yasnippet	text template	none
; js2-mode	everything for javascript	js-mode

; simple-httpd	web server	elnode
; smartparens	auto insert matched parens	autopair

; window-numbering.el	jump focus between sub-windows	switch-window.el
; web-mode	everything for edit HTML templates	nxml-mode
; w3m	web browser	Eww

(provide '.emacs)
;;; .emacs ends here
