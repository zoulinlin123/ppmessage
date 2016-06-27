;(set-background-color "black")
;(set-foreground-color "white")

(add-to-list 'default-frame-alist '(foreground-color . "#FFFFFF"))
(add-to-list 'default-frame-alist '(background-color . "#000000"))

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
;(prefer-coding-system 'chinese-gb18030-unix)

(global-linum-mode 1)
(blink-cursor-mode t)
(show-paren-mode t)
(global-font-lock-mode t)
(global-hl-line-mode t)
(show-paren-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(mouse-avoidance-mode 'animate)

(setq-default indent-tabs-mode nil)
(setq auto-save-default nil)
(setq visible-bell t)
(setq show-paren-style 'parentheses)
(setq kill-ring-max 200)
(setq uniquify-buffer-name-style 'forward)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq c-basic-offset 4)

(transient-mark-mode t)
(column-number-mode t)
(show-paren-mode t)
(global-set-key [(f2)] 'set-mark-command)
(global-set-key [(control space)] nil)
(global-set-key [(f9)] 'toggle-frame-fullscreen)
(setq-default cursor-type 'bar)
(setq make-backup-files nil)

;;'y' for 'yes', 'n' for 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; For Linux
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)
 
;; For Windows
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)


(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size) 
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))

(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))
 
    ;; Set the default English font
    ;; 
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)
 
    ;; Set Chinese font 
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))

(qiang-set-font
 '("Inconsolata" "Consolas" "Monaco" "Courier New") "24"
 '("Microsoft Yahei" "wqy" "Hiragino Sans GB"))

(setq frame-title-format
       '("  GNU Emacs   -   [ " (buffer-file-name "%f \]"
               	(dired-directory dired-directory "%b \]"))
	)
)
