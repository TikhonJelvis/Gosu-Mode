;; The simplest approach to starting an Emacs major mode is to make it
;; a "generic" mode.  Other options are to make it from scratch, or to
;; derive it from another mode (such as java-mode, or cc-mode).
;; Creating it from scratch confers more flexibility, while deriving
;; it enjoys the benefits of code reuse.  On the other hand,
;; overriding behavior from the parent mode can be awkward, so for the
;; moment, I'm sticking with making a so-called generic mode.  (See
;; the Emacs Info manuals on generic modes and on the
;; define-generic-mode macro).
(require 'generic-x)

(defvar gosu-mode-syntax-table
  (let ((gosu-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" gosu-mode-syntax-table)
    (modify-syntax-entry ?* ". 23" gosu-mode-syntax-table)
    (modify-syntax-entry ?' "\"'" gosu-mode-syntax-table)
    (modify-syntax-entry ?\n "> b" gosu-mode-syntax-table)
    gosu-mode-syntax-table)
  "`define-generic-defun' takes COMMENT-LIST, but its support for
ending comments with the lint terminator seems not to work,
so here we are setting up our own syntax table.")

(defvar gosu-mode-map (make-keymap))
(define-key gosu-mode-map (kbd "C-c C-l") 'run-gosu)

(defun line-matchesp (regexp offset)
  "Return t if line matches regular expression REGEXP.  The 
selected line is chosen by applying OFFSET as a numeric 
increment or decrement away from the current line number.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (save-excursion
    (forward-line offset)
    (beginning-of-line)
    (looking-at regexp)))

(defun previous-line-matchesp (regexp)
  "Return t if previous line matches regular expression REGEXP.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (line-matchesp regexp -1))

(defun current-line-matchesp (regexp)
  "Return t if current line matches regular expression REGEXP.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (line-matchesp regexp 0))

(defun gosu-indent-line ()
  (interactive)
  "Establish a set of conditional cases for the types of lines that
point currently is on, and the associated indentation rules."
  (indent-line-to
   (cond
    ((and
      (previous-line-matchesp "^[ \t]*\\*")
      (current-line-matchesp "^[ \t]*\\*"))
     (save-excursion
       (forward-line -1)
       (current-indentation)))
    ((and
      (previous-line-matchesp "^[ \t]*/\\*")
      (current-line-matchesp "^[ \t]*\\*"))
     (save-excursion
       (forward-line -1)
       (+ (current-indentation) 1)))
    ((and
      (previous-line-matchesp "^[ \t]*\\.")
      (current-line-matchesp "^[ \t]**\\."))
     (save-excursion
       (forward-line -1)
       (current-indentation)))
    ((and
      (not (previous-line-matchesp "^[ \t]*\\."))
      (current-line-matchesp "^[ \t]*\\."))
     (save-excursion
       (forward-line -1)
       (+ (current-indentation) default-tab-width)))
    ((current-line-matchesp "^[ \t]*}")
     (save-excursion
       (beginning-of-line)
       (backward-up-list)
       (current-indentation)))
    (t
     (save-excursion
       (condition-case nil
           (progn
             (beginning-of-line)
             (backward-up-list)
             (+ (current-indentation) default-tab-width))
         (error 0)))))))

;; Set up the actual generic mode
(define-generic-mode 'gosu-mode
  ;; comment-list
  nil
  ;; keyword-list
  '(
    "application"
    "new"
    "as"
    "break"
    "override"
    "case"
    "package"
    "catch"
    "private"
    "class"
    "property"
    "continue"
    "protected"
    "default"
    "public"
    "do"
    "readonly"
    "else"
    "request"
    "eval"
    "return"
    "except"
    "session"
    "execution"
    "set"
    "extends"
    "static"
    "finally"
    "super"
    "final"
    "switch"
    "find"
    "for"
    "try"
    "foreach"
    "typeas"
    "function"
    "typeis"
    "get"
    "typeof"
    "hide"
    "unless"
    "implements"
    "uses"
    "index"
    "var"
    "interface"
    "void"
    "internal"
    "while"
    "native"
    "construct"
    "if"
    "using"
    "in"
    "block"
    "and"
    "or"
    "not"
    "property"
    "writeable"
    "throw"
    "enhancement")
  ;; font-lock-list
  '(("\\b[0-9]+\\b\\|true\\|false\\|null\\|this" . font-lock-constant-face)
    ("\\s-\\([A-Z][aA-zZ]*\\)\\." 1 'font-lock-type-face)
    ("\\(uses\\|:\\|as\\).+\\.\\([A-Z][aA-zZ]*\\)" 2 'font-lock-type-face)
    ("\\(:\\|\\bas\\b\\).+\\([A-Z][aA-zZ]*\\)" 2 'font-lock-type-face)
    ("\\(\\\\\\).*\\(->\\)" 
     (1 (prog1 ()
          (compose-region (match-beginning 1) (match-end 1) ?λ)
          (put-text-property (match-beginning 1) (match-end 1) 'font-lock-face 'font-lock-builtin-face)))
     (2 (prog1 ()
          (compose-region (match-beginning 2) (match-end 2) ?→)
          (put-text-property (match-beginning 2) (match-end 2) 'font-lock-face 'font-lock-builtin-face))))
    ("\\(->\\)" 
     (1 (prog1 ()
          (compose-region (match-beginning 1) (match-end 1) ?→)
          (put-text-property (match-beginning 1) (match-end 1) 'font-lock-face 'font-lock-builtin-face)))))
  ;; auto-mode-list
  '(".gs\\'")
  ;; function-list
  '((lambda () 
      (set-syntax-table gosu-mode-syntax-table)
      (setq comment-start "//")
      (setq comment-end "")
      (set (make-local-variable 'indent-line-function) 'gosu-indent-line)
      (use-local-map gosu-mode-map))))

(provide 'gosu-mode)
