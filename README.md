\#TITLE: 麦东的Emacs配置文件

Emacs的组件
===========

添加package源
-------------

``` {.commonlisp}
(require 'package)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)
```

Emacs通用设置
=============

编辑器默认行为设置
------------------

``` {.commonlisp}
;; 设置tab space
(setq tab-width 4)

;; 设置自动显示行号
;;(setq linum-format "%4d \u2502") ;;设置行号显示模式，行号边缘添加竖线
(setq linum-format "%04d ") ;;设置行号显示格
(global-linum-mode t)

;; 设置默认换行模式为“在窗口边缘自动换行”
(toggle-truncate-lines t)
```

Emacs外观设置
-------------

### 字体设置

Emacs的界面可以进行大量的定制化设置。为了保证在Emacs中使用中文和英文混排时表格可以对齐，需要对Emacs中的字体进行相应的设置。

定义字体设置函数。

``` {.commonlisp}
(require 'cl)

(defun set-font (english chinese english-size chinese-size)
  (set-face-attribute 'default nil :font
                      (format "%s:pixelsize=%d" english english-size))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))
```

设置Emacs中英文字体，以满足中英文混排时表格对齐要求。这里完成的是Linux和Windows环境下的字体设置。其他系统暂未考虑支持。

在Emacs中由于表格的宽度计算使用了“中文汉字的宽度是英文字母的两倍”的假设。因此，如果要实现表格的对齐，可能需要不同的中英文字体配合。同时字体的大小也存在不一致的情况，以迁就Emacs的“假设”。

在Windows环境下，目前发现可以实现良好显示的中英文字体及大小搭配为：

  English Font name         Size   Chinese Font Name          Size
  ------------------------- ------ -------------------------- ------
  Consolas                  14     Microsoft Yahei            16
  Liberation Mono           14     WenQuanyi Micro Hei Mono   16
  DejaVu Sans Mono          16     WenQuanyi Micro Hei Mono   20
  Yahei Mono                16     Yahei Mono                 16
  Dejavu Sans YuanTi Mono   14     DejaVu Sans YuanTi Mono    16

``` {.commonlisp}
(case system-type
  (gnu/linux
   (set-face-bold-p 'bold nil)
   (set-face-underline-p 'bold nil)
   (set-font "monofur" "WenQuanyi Micro Hei Mono" 16 16))
  ( windows-nt
     (set-font "Consolas" "Microsoft Yahei" 14 14))
)
```

### Eamcs界面元素显示状态

Eamcs运行时我不想让工具条、滚动条和菜单条显示出来，所以关掉。

``` {.commonlisp}
(when (string-equal system-type "windows-nt")
  "在Windows环境中关闭菜单条"
  (menu-bar-mode -1))
;; 关闭工具条
(tool-bar-mode -1)
;; 关闭滚动条
(scroll-bar-mode -1)
```

启动时显示启动信息没有用，关闭之。

``` {.commonlisp}
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;;如果安装了fill-column-indicator扩展，则默认激活
(unless (package-installed-p "fill-column-indicator")
  (add-hook 'python-mode-hook 'fci-mode))
```

### Theme 设置

Emacs上有不少Theme。可以到 [Emacs
Themes](http://emacsthemes.caisah.info)
看看，基本上符合Emacs2.4的Theme都有抓图可以预览效果。

``` {.Emacs-lisp}
(when window-system (load-theme 'molokai t))
```

Trust all themes.

``` {.commonlisp}
(setq custom-safe-themes t)
```

Emacs编辑功能设置
=================

文件编码
--------

设置Emacs的默认编码集。考虑到跨操作系统使用Emacs配置文件的需求，使用utf-8作为主要文件编码。

``` {.Emacs-lisp}
(case system-type
  (windows-nt
   (prefer-coding-system 'utf-8)
   (setq file-name-coding-system 'gbk))
  (gnu/linux
   (prefer-coding-system 'utf-8))
)
```

附录
====
