;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Iosevka Nerd Font Propo" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Propo" :size 15 :weight 'extrabold))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;PERSONAL ---------------------
(setq read-process-output-max (* 1024 1024))

;;Projectile
(setq projectile-enable-caching nil
      projectile-project-root-functions '(projectile-root-local
                                          projectile-root-top-down
                                          projectile-root-top-down-recurring
                                          projectile-root-bottom-up))

;;LSP
(use-package! lsp-mode
  :commands lsp
  :config
  (setq lsp-semantic-tokens-enable t)
  (add-hook 'lsp-after-apply-edits-hook (lambda (&rest _) (save-buffer)))) ;; save buffers after renaming

;; Nu
(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/")
      (nu-projects-path "~/dev/nu"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t))
  (when (file-directory-p nu-projects-path)
    (add-to-list 'projectile-project-search-path nu-projects-path)
    (add-to-list 'projectile-project-search-path "~/dev/nu/mini-meta-repo/packages")))

;;MAC
(when (eq system-type 'darwin)
  (setq
   ns-command-modifier 'control
   ns-option-modifier 'meta
   ns-control-modifier 'super
   ns-function-modifier 'hyper))

;; Cider functions and config
(defun my-cider-eval-dwim ()
  "If no region is active, call `cider-eval-last-sexp'.
If a region is active, run `cider-eval-region'."
  (interactive)
  (if (use-region-p)
      (cider-eval-region (region-beginning) (region-end))
    (cider-eval-last-sexp)))

(after! cider
  (setq cider-ns-code-reload-tool 'clj-reload)
  (setq cider-enrich-classpath t))

;; compat flag lispy
(after! lispy
  (setq lispy-compat '(cider edebug)))

;; Github Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(clojure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

;; Key bindings
(map!
 ;; Global bindings
 "C-b" #'open-line
 "C-f" #'recenter-top-bottom
 "C-n" #'kill-line
 "M-n" #'kill-sentence
 "C-M-n" #'kill-sexp
 "C-p" #'forward-char
 "M-p" #'forward-word
 "C-M-p" #'forward-sexp
 "C-k" #'backward-char
 "M-k" #'backward-word
 "C-M-k" #'backward-sexp
 "C-l" #'next-line
 "C-o" 'previous-line
 "M-M" #'mc/mark-next-like-this
 "M-i" #'iedit-mode
 "M-o" #'ace-window
 ;;lispy
 (:after lispy
         (:map (lispy-mode-map lispy-mode-map-lispy)
               "C-n" #'lispy-kill
               "C-k" #'backward-char
               "M-k" #'backward-word
               "C-3" #'lispy-backward
               "C-4" #'lispy-forward
               ";" nil
               "M-M" nil
               "M-o" nil
               "C-<backspace>" #'backward-delete-char-untabify
               "[" #'lispy-brackets
               "{" #'lispy-braces
               "(" #'lispy-parens
               "]" nil
               "}" nil
               ")" nil))
 ;;copilot
 (:after copilot
         (:map copilot-completion-map
               ("<tab>" #'copilot-accept-completion)
               ("TAB" #'copilot-accept-completion)
               ("C-TAB" #'copilot-accept-completion-by-word)
               ("C-<tab>" #'copilot-accept-completion-by-word)
               ("C-n" #'copilot-next-completion)
               ("C-p" #'copilot-previous-completion)))
 ;;lsp
 (:after lsp-mode
         (:map lsp-mode-map
               "M-SPC" #'lsp-find-definition
               "M-s-SPC" #'lsp-find-references))
 ;; dired
 (:after dired
         (:map dired-mode-map
               "C-o" nil))
 ;; cider
 (:after cider
         (:map cider-mode-map
               "C-ñ" #'my-cider-eval-dwim)))
