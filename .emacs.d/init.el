; ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ ;
; ║                                                                                              ║ ;
; ║                      o8o               o8o      .                 oooo                       ║ ;
; ║                      `"'               `"'    .o8                 `888                       ║ ;
; ║                     oooo  ooo. .oo.   oooo  .o888oo      .ooooo.   888                       ║ ;
; ║                     `888  `888P"Y88b  `888    888       d88' `88b  888                       ║ ;
; ║                      888   888   888   888    888       888ooo888  888                       ║ ;
; ║                      888   888   888   888    888 . .o. 888    .o  888                       ║ ;
; ║                     o888o o888o o888o o888o   "888" Y8P `Y8bod8P' o888o                      ║ ;
; ║                                                                                              ║ ;
; ║                                      Created by datwaft                                      ║ ;
; ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ ;

; ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ ;
; ║                                        User interface                                        ║ ;
; ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ ;
  ; ┌────────────────────────────────────────────────────────────────────────────────────────────┐ ;
  ; │                                          Titlebar                                          │ ;
  ; └────────────────────────────────────────────────────────────────────────────────────────────┘ ;
    (setq frame-title-format '("%m " invocation-name "@" (system-name)))
  ; ┌────────────────────────────────────────────────────────────────────────────────────────────┐ ;
  ; │                                    Modeline management                                     │ ;
  ; └────────────────────────────────────────────────────────────────────────────────────────────┘ ;
    (require 'time)
    (defun cm/display-time-mail-function ()
      "Return t if new important mail, else nil"
      (let* ((s (shell-command-to-string "notmuch count tag:inbox AND tag:unread"))
          (st (string-trim s))
          (newmail (string= "0" st)))
        (not newmail)))
    (setq display-time-mail-function nil)
    (setq display-time-format "%Y-%m-%d %H:%M")
    (setq display-time-day-and-date t)
    (setq display-time-24hr-format t)
    (setq display-time-use-mail-icon t)
    (setq display-time-default-load-average nil)
    (display-time-mode t)
  ; ┌────────────────────────────────────────────────────────────────────────────────────────────┐ ;
  ; │                                 Miscelaneous configuration                                 │ ;
  ; └────────────────────────────────────────────────────────────────────────────────────────────┘ ;
    ; Better emacs look
    (if (boundp 'menu-bar-mode)
      (menu-bar-mode -1))
    (if (boundp 'tool-bar-mode)
      (tool-bar-mode -1))
    (if (boundp 'scroll-bar-mode)
      (scroll-bar-mode -1))
    ; Indicate empty lines
    (set-default 'indicate-empty-lines t)
    ; No audible bells
    (setq visible-bell 1)
    ; Recursive minibuffers
    (setq enable-recursive-minibuffers t)
; ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ ;
; ║                                         Environment                                          ║ ;
; ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ ;
  ; Prefer newer bitcode
  (setq load-prefer-newer t)
; ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ ;
; ║                                           Packages                                           ║ ;
; ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ ;
  ; ┌────────────────────────────────────────────────────────────────────────────────────────────┐ ;
  ; │                                            ELPA                                            │ ;
  ; └────────────────────────────────────────────────────────────────────────────────────────────┘ ;
    (require 'use-package)
    (require 'use-package-diminish)
    (require 'bind-key)
  ; ┌────────────────────────────────────────────────────────────────────────────────────────────┐ ;
  ; │                                        Color theme                                         │ ;
  ; └────────────────────────────────────────────────────────────────────────────────────────────┘ ;
    (defadvice load-theme (before theme-dont-propagate activate)
      "Disable theme before loading new one."
      (mapc #'disable-theme custom-enabled-themes))
    (defvar cm/theme-style 'dark
      "What style of preferred theme I'm using")
    (defvar cm/theme-before-hook '()
      "Hooks to run before setting a theme")
    (defvar cm/theme-after-hook '()
      "Hooks to run after setting a theme")
    (defvar cm/configured-theme-styles '(dark light author)
      "Which styles are currently configured for use")
    (defun cm/set-theme (theme)
      (interactive "Theme to swap to: ")
      (run-hooks 'cm/theme-before-hook)
      (pcase theme
        ('dark
         (progn (setq cm/theme-style 'dark)
            (load-theme 'wombat t)))
        ('light
         (progn (setq cm/theme-style 'light)
            (load-theme 'adwaita t)))
        ('author
         (progn (setq cm/theme-style 'author)
            (load-theme 'poet t))))
      (run-hooks 'cm/theme-after-hook))
    (defun cm/swap-theme ()
      (interactive)
      (pcase cm/theme-style
        ('dark (cm/set-theme 'light))
        ('light (cm/set-theme 'dark))))
    (cm/set-theme 'dark)
