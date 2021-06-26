;;; chris-font-scaling --- manage fonts in a way i find sane -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; font zooming without the damn font panel

(defvar chris-font "SF Mono")
(defvar chris-font-weight 'light)
(defvar chris-default-font-size 13)

(defun make-chris-font-spec (size)
  (font-spec :family chris-font :size size :weight chris-font-weight))

(set-frame-font (make-chris-font-spec chris-default-font-size) t t)

(defun chris-font-size ()
  (elt (font-info (frame-parameter nil 'font)) 2))

'(defun chris--font-watcher (&optional sym newval _ __)
   "Variable watcher that updates the font size."
   (let ((face (if (eq 'chris-font sym) newval chris-font))
	 (size (if (eq 'chris-font-size sym) newval chris-font-size))
	 (config (if (eq 'chris-font-config sym) newval chris-font-config)))
     (set-frame-font (concat face "-" (number-to-string size) config) t)))

'(chris--font-watcher)
'(add-variable-watcher 'chris-font #'chris--font-watcher)
'(add-variable-watcher 'chris-font-config #'chris--font-watcher)

(defun chris-set-font-size (arg)
  (interactive "P")
  (let ((size (if (eq nil arg) chris-default-font-size
		(prefix-numeric-value arg))))
    (set-frame-font (make-chris-font-spec size) t nil)
    (message "Font size is now %s" size)))

(defun chris-font-adjuster (delta)
  "Adjust the frame's font size by `DELTA' pixels."
  (lambda ()
    (interactive)
    (let ((current-prefix-arg (list (+ delta (chris-font-size)))))
      (call-interactively #'chris-set-font-size))))

(bind-key "s-=" (chris-font-adjuster 2))
(bind-key "s--" (chris-font-adjuster -2))
(bind-key "s-0" #'chris-set-font-size)

(provide 'chris-font-scaling)
;;; chris-font-scaling.el ends here
