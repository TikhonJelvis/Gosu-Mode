;; This is just a simple mode for interacting with an inferior Gosu process.
;;
;; This mode is based on comint, which is the base on which all respectable 
;; interactive process modes like shell and ielm are based. This mode is really
;; simple--it only sets the appropriate command ("gosu -i") and the name of the
;; buffer.
(require 'comint)

(defvar inferior-gosu-mode-map nil)
(unless inferior-gosu-mode-map
  (setq inferior-gosu-mode-map (copy-keymap comint-mode-map)))

(defvar gosu-executable "gosu")

(put 'inferior-gosu-mode 'mode-class 'special)

(defun inferior-gosu-mode ()
  (interactive)
  (comint-mode)
  (setq comint-prompt-regex inferior-gosu-prompt)
  (setq major-mode 'inferior-gosu-mode)
  (setq mode-name "Inferior Gosu")
  (setq mode-line-process '(":%s"))
  (use-local-map 'inferior-gosu-mode-map))

(defun inferior-gosu ()
  (interactive)
  (message gosu-executable)
  (if (not (comint-check-proc "*inferior-gosu*"))
      (progn (set-buffer (apply (function make-comint) "inferior-gosu" 
                                 gosu-executable nil '("-i")))))
  (pop-to-buffer "*inferior-gosu*"))

(defalias 'run-gosu 'inferior-gosu)

(provide 'inferior-gosu-mode)
