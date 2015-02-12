; set guifont=ProggyCleanTT\ 12

; (set-default-font "Liberation Mono-13")
;(set-default-font "ProggyCleanTT-12")
(set-default-font "Monaco-12")
;(set-default-font "ProggyCleanTT-14")

; set theme similar to gentooish
(load-theme 'wombat t)
; Set cursor color to white
(set-cursor-color "#ffffff")

(global-linum-mode t)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

; Helm: browrser
(global-set-key (kbd "C-c h") 'helm-mini)
(helm-mode 1)

; FIPLR (like Ctrl-P)
(setq fiplr-ignored-globs '((directories (".git" ".svn" "target" ".lein-git-deps"))
                                                        (files ("*.jpg" "*.png" "*.zip" "*~" "*.class" ".gitignore" ))))
(global-set-key (kbd "C-x f") 'fiplr-find-file)

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
'(ecb-options-version "2.40"))
(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
)

; ClojureScript
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

; use Windows key as meta
(setq x-super-keysym 'meta)

; disable top toolbar
(tool-bar-mode -1)

; shift left and right for next/prev buffer
(global-set-key (kbd "S-<left>") 'previous-buffer)  ; Shift+←
(global-set-key (kbd "S-<right>") 'next-buffer)  ; Shift+←

; Evil Mode
(add-to-list 'load-path "~/.emacs.d/elpa/evil-1.0.8")
(require 'evil)
(evil-mode 1)
(define-key evil-normal-state-map "M-x" 'execute-extended-command)
