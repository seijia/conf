;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(load-theme 'wheatgrass t)
(setq emacs-plugins-path "~/.emacs.d/plugins/")
(add-to-list 'load-path emacs-plugins-path)


(tool-bar-mode 0)
;(menu-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)

(line-number-mode 1)
(column-number-mode 1)
;; alway show line number
;; (global-linum-mode 1)

;; create buffer named `empty, and switched to it
(switch-to-buffer (get-buffer-create "empty"))
(delete-other-windows)

(setenv "PAGER" "/bin/cat")
;; Terminus-12, DejaVu Sans Mono-10
(setq davei-font "Terminus-10")
(set-default-font davei-font)
(set-frame-font davei-font)
;; (setq default-frame-alist '((font . davei-font)))
;; (set-face-attribute 'mode-line nil font davei-font)

(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)



(setq frame-title-format '("%f" (dired-directory "%b")))

;; S-<left> S-<right> S-<up> S-<down>
(windmove-default-keybindings)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


(setq inhibit-startup-screen 1)
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)


(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(setq default-directory "~/work/")
(defvar custom-tmp-dir "~/.tmp/")
(defvar autosave-dir "~/.tmp/emacs_save/")
(make-directory autosave-dir t)
(setq backup-directory-alist (list (cons "." autosave-dir)))


(require 'exec-path-from-shell)
(setq exec-path-from-shell-arguments '("-l"))
(exec-path-from-shell-copy-env "PATH")


;; (require 'multi-term)
;; (setq multi-term-program "/bin/bash")

;; shell-mode
(add-hook 'shell-mode-hook '(lambda () (global-linum-mode 0)))

;; highlight the current line
;; (global-hl-line-mode 1)
;; (setq highlight-current-line-globally 1)
;; (setq highlight-current-line-high-faces 0)
;; (setq highlight-current-line-whole-line 0)
;; (setq hl-line-face (quote highlight))

(fset 'yes-or-no-p 'y-or-n-p)

;; make ibuffer default
(defalias 'list-buffers 'ibuffer)

(defun kill-all-buffers ()
  "kill all other buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list))
  (delete-other-windows)
  )

(global-set-key [C-f1] 'kill-all-buffers)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; (ido-mode 1)

(global-set-key [f11] 'toggle-frame-fullscreen)



(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; change c-mode style

(setq c-default-style "linux")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gnus
;; disable nntp stuff
(setq gnus-nntp-server nil
      gnus-read-active-file nil
      gnus-save-newsrc-file nil
      gnus-read-newsrc-file nil
      gnus-check-new-newsgroups nil)


;; company-mode

(add-to-list 'load-path (concat emacs-plugins-path "company-mode"))
(require 'company)
(setq company-global-modes '(not gud-mode))
(add-hook 'after-init-hook 'global-company-mode)



;; yasnippet
(add-to-list 'load-path (concat emacs-plugins-path "yasnippet"))

(require 'yasnippet)
(setq yas/snippet-dirs (concat emacs-plugins-path "yasnippet/snippets"))
(yas/global-mode 1)

;; markdown-mode
(add-to-list 'load-path (concat emacs-plugins-path "markdown"))
(require 'markdown-mode)
(setq markdown-command "/usr/bin/markdown2")
;; (add-hook 'markdown-mode-hook 'auto-fill-mode)

(add-to-list 'load-path (concat emacs-plugins-path "go-mode"))
(require 'go-mode)
;; (require 'go-flymake)
;; (require 'go-flycheck)

(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)
  ;; Godef jump key binding                                                     
  (local-set-key (kbd "M-.") 'godef-jump)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  )

(add-hook 'go-mode-hook 'my-go-mode-hook)


;; elpy-mode

(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(package-initialize)
(elpy-enable)
(setq elpy-rpc-backend "jedi")
(define-key elpy-mode-map (kbd "M-,") 'pop-tag-mark)

(add-hook 'python-mode-hook 'elpy-mode)
(eval-after-load 'elpy
  (add-hook 'elpy-mode-hook 'elpy-use-ipython "ipython"))


(setq gud-pdb-command-name "python -m pdb")

(add-to-list 'load-path (concat emacs-plugins-path "iedit"))
(require 'iedit)
(define-key global-map (kbd "C-c o") 'iedit-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-set-key (kbd "M-g") 'goto-line)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq gdb-many-windows 1)
;;

(eval-after-load "gud"
  '(progn
     (define-key gud-minor-mode-map (kbd "<up>") 'comint-previous-input)
     (define-key gud-minor-mode-map (kbd "<down>") 'comint-next-input)
     (define-key gud-minor-mode-map [f5] 'gud-step)
     (define-key gud-minor-mode-map [f6] 'gud-next)
     (define-key gud-minor-mode-map [C-f5] 'gud-stepi)
     (define-key gud-minor-mode-map [C-f6] 'gud-nexti)
     (define-key gud-minor-mode-map [f7] 'gud-finish)
     (define-key gud-minor-mode-map [C-f7] 'gud-until)
     (define-key gud-minor-mode-map [f8] 'gud-cont)
     (define-key gud-minor-mode-map [C-f8] 'gud-stop)
     (define-key gud-minor-mode-map [f9] 'gud-run)
     (define-key gud-minor-mode-map [f12] 'gdb-many-windows)
     (define-key gud-minor-mode-map [C-f12] 'gdb-restore-windows)
     ))

(defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))
        (win1 (split-window nil nil 'left))
        (win2 (split-window-below (/ (* (window-height) 1) 2)))
        )

    (select-window win2)
    (gdb-set-window-buffer (if gdb-show-threads-by-default
			       (gdb-threads-buffer-name)
			     (gdb-breakpoints-buffer-name)))
    (split-window nil (/ (* (window-height) 1) 2))

    (other-window 1)
    (gdb-set-window-buffer (gdb-stack-buffer-name))

    (select-window win1)
    (set-window-buffer
     win1
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (if gdb-main-file
           (gud-find-file gdb-main-file)
         ;; Put buffer list in window if we
         ;; can't find a source file.
         (list-buffers-noselect))))

    (setq gdb-source-window (selected-window))
    (split-window nil (/ (* (window-height) 1) 2))

    (other-window 1)
    (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-disassembly-buffer t))
    (split-window nil (/ (* (window-height) 1) 2))

    (other-window 1)
    (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io))

    (select-window win0)
    ))
