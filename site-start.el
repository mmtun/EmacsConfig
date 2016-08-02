(defvar %~dp0 (substring data-directory 0 3)) (defvar usb-home-dir (concat %~dp0 "home/"))
(setenv "HOME" usb-home-dir)
