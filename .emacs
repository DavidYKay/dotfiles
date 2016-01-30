(cond
   ((string-equal system-type "gnu/linux")
    (defvar running-on-linux t)
    ; use Windows key as meta
    (setq x-super-keysym 'meta)
    (set-default-font "ProggyCleanTT-12"))
    ;(set-default-font "Mono-13"))

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
     ;(Set-default-font "VeraMono-14")
     ))

; Set theme similar to gentooish
;(load-theme 'wombat t)
(load-theme 'wheatgrass t)
;
; Set cursor color to white
(set-cursor-color "#ffffff")

(global-linum-mode t)


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

; Backup management
; (global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)

; Backup management

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

; Helm: browrser
(global-set-key (kbd "C-c h") 'helm-mini)
(helm-mode 1)

(require 'fiplr)
; FIPLR (like Ctrl-P)
(setq fiplr-ignored-globs '((directories (".git" ".svn" ".hg" 
					  "target" "archive" "out"
					  "repl" ".repl" ".cljs_node_repl" ".cljs_rhino_repl" ".lein-git-deps" 
					  ".gradle" ".cabal-sandbox" "venv" "node_modules" "Pods"))
                            (files ("*.gif" "*.jpg" "*.pdf" "*.png" "*.tif" "*.amz"
				    "*.xls" "*.xlsx" "*.XLS" "*.XLSX"
				    "*.zip" "*.gz"
				    "*.bin" "*.dll" 
				    "*.class" "*.jar" "*.pyc" 
				    "*.pem" "*.cer" "*.p12" 
				    ".*" "*~" ".#*" "#*#" ".gitignore"))))


(setq fiplr-root-markers '(".git" ".svn" ".fiplr-root"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-\\") 'fiplr-find-file)
(define-key *fiplr-keymap* (kbd "<f5>")   'fiplr-reload-list)

; CEDET
; (add-to-list 'load-path "~/.emacs.d/cedet-1.1")
; (load-file "~/.emacs.d/cedet-1.1/cedet-devel-load.el")

; Emacs Code Browser
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


; Emacs Nav
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

 
 
(autoload 'markdown-mode "markdown-mode"
 "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
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

; ClojureScript
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))


; disable top toolbar
(tool-bar-mode -1)

; shift left and right for next/prev buffer
(global-set-key (kbd "S-<left>") 'previous-buffer)  ; Shift+←
(global-set-key (kbd "S-<right>") 'next-buffer)  ; Shift+←

; Evil Mode
; (add-to-list 'load-path "~/.emacs.d/elpa/evil-1.0.8")
(setq evil-want-C-u-scroll t)
(require 'evil)
(define-key evil-normal-state-map "M-x" 'execute-extended-command)
(evil-mode 1)

; Cider
(setq cider-lein-command "~/bin/lein")

; Auto-Complete
(add-to-list 'load-path "/Users/dk/.emacs.d")
(require 'auto-complete-config)
(ac-config-default)

; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

; pos-tip for displaying error messages
(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; flycheck rust

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; flycheck clojure / squiggly

;(eval-after-load 'flycheck '(flycheck-clojure-setup))

; string manip

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



;(provide '.emacs)

