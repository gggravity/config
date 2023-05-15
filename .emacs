;; first, declare repositories
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

;; Init the package facility
(require 'package)
(package-initialize)
;; (package-refresh-contents) ;; this line is commented 
;; since refreshing packages is time-consuming and should be done on demand

;; Declare packages
(setq my-packages '(
		    racket-mode
		    ;; smartparens
		    powerline
		    yasnippet
		    yasnippet-snippets
		    company
		    which-key
		    super-save
		    guru-mode
		    one-themes
		    rainbow-delimiters
		    xterm-color
		    ))

;; Iterate on packages and install missing ones
(dolist (pkg my-packages)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; Set custom require
;; (require 'smartparens-config)
(require 'racket-xp)
(require 'helm)
(require 'yasnippet)

(eshell)



(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd-15"
                    "-j=8"
                    "--log=error"
                    "--malloc-trim"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"))))



;; Set term envitonment for compilation buffer
(setq compilation-environment '("TERM=xterm-256color"))
(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))
(advice-add 'compilation-filter :around #'my/advice-compilation-filter)

;; Set custom font
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "SRC" :slant normal :weight normal :height 109 :width normal))))
 '(show-paren-match ((t (:background "dim gray" :underline t :weight bold)))))

;; Set custom keys helm
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap switch-to-buffer] #'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "s-<print>") 'helm-mini)
(define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)

;; Set custom keys
(define-key global-map (kbd "C-<return>") 'recompile)
;; (define-key global-map (kbd "C-<return>") 'racket-run)
(define-key global-map (kbd "C-M-<delete>") 'backward-kill-sexp)
(define-key global-map (kbd "C-;") 'comment-line)
(define-key global-map (kbd "C-½") 'eglot-format-buffer)
(define-key global-map (kbd "C-c o") 'ff-find-other-file)
(define-key global-map (kbd "C-c f") 'eglot-code-action-quickfix)
(define-key global-map (kbd "C-c r") 'eglot-rename)
(define-key global-map (kbd "C-c i") 'eglot-inlay-hints-mode)
(global-set-key (kbd "s-<left>")  'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)
(global-set-key (kbd "s-<up>")    'windmove-up)
(global-set-key (kbd "s-<down>")  'windmove-down)

;; mode for different files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; follow symbolic links
(setq vc-follow-symlinks t)

;; Treat all themes as safe
(setq custom-safe-themes t)

;; Custom configs
(helm-mode 1)
(which-key-mode)
(yas-global-mode 1)
(super-save-mode +1)
(show-smartparens-global-mode +1)
;; (turn-on-smartparens-strict-mode)
(powerline-default-theme)
;; (global-aggressive-indent-mode -1)
(menu-bar-mode 1)
;; (scroll-bar-mode -1)
(tool-bar-mode -1)
(global-hl-line-mode +1)
(global-font-lock-mode 1) ;;; Always do syntax highlighting 

(set-default 'truncate-lines nil)

(setq racket-images-inline t)
(setq geiser-mode-smart-tab-p t)
(setq geiser-debug-jump-to-debug-p nil)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(setq scroll-down-aggressively 0.01)
(setq tab-always-indent 'complete) ;; for racket mode autocompleate
;; (setq smartparens-strict-mode f)
(setq compilation-scroll-output t)
(setq compile-command "cmake .; make && ./application")

;;disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Split screen on startup and open standard files
(split-window-horizontally)
(find-file "~/.emacs")
(switch-to-buffer ".emacs")
(other-window 1)
(switch-to-buffer "*scratch*")
(other-window 1)

;; Custom hooks
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'column-number-mode)
(add-hook 'prog-mode-hook #'toggle-truncate-lines)
(add-hook 'prog-mode-hook 'eglot-ensure)
;; (add-hook 'prog-mode-hook #'show-paren-mode)
;; (add-hook 'prog-mode-hook #'show-smartparens-mode)
(add-hook 'racket-mode-hook #'racket-xp-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'auto-revert-tail-mode 'compilation-mode)
(add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode)


;; Misc custom variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#a1efe4" "#fcfcfa"])
 '(ansi-term-color-vector
   [unspecified "#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#a1efe4" "#fcfcfa"] t)
 '(connection-local-criteria-alist
   '(((:application tramp :protocol "flatpak")
      tramp-container-connection-local-default-flatpak-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-container-connection-local-default-flatpak-profile
      (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin"))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-enabled-themes '(one-dark))
 '(font-use-system-font t)
 '(fringe-mode 6 nil (fringe))
 '(initial-frame-alist '((fullscreen . maximized)))
 '(ispell-dictionary nil)
 '(linum-format " %7d ")
 '(package-selected-packages
   '(eglot yasnippet-snippets yasnippet powerline one-themes guru-mode racket-mode smartparens company rainbow-delimiters xterm-color helm super-save which-key))
 '(show-paren-mode t)
 '(vertico-mode t)
 '(warning-suppress-log-types '((comp))))

;; enable fullscreen on startup

