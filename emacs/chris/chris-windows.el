;;; chris-windows --- manage windows in a way i find sane -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(defun chris-window-coord-to-steps (coord)
  "From a coordinate `COORD', create a list of directions to look.

Will return a list of symbols, either right or down."
  (let ((steps nil)
	(col (car coord))
	(row (cdr coord)))
    (while (> row 0)
      (setq steps (cons 'down steps)
	    row (- row 1)))
    (while (> col 0)
      (setq steps (cons 'right steps)
	    col (- col 1)))
    steps))

(defun chris-window-resolve (window)
  "If `WINDOW' is not live, find its first live child, recursively."
  (while (not (window-live-p window))
    (setq window (window-child window)))
  window)

(defun chris-window-from (window dir)
  "Find the window relative to `WINDOW' in direction `DIR'.
`DIR' may be down or right."
  (let* ((horiz (eq 'right dir)))
    (or (when (window-combined-p window horiz)
	  (window-next-sibling window))
	(when-let ((main (window-combination-p window horiz)))
	  (window-next-sibling main))
	(when-let ((alt (window-combination-p window (not horiz))))
	  (chris-window-from alt dir)))))

(defun chris-window-at (coord &optional frame)
  "Find the window at `COORD' in `FRAME', or the current frame.

There are three possible returns:
- the list ('found the-window) if it has been located
- the list ('near a-window 'dir) if it can be easily split
- nil, if the window is not found and can't be easily split"
  (let* ((frame (or frame (selected-frame)))
	 (main-window (window-main-window frame))
	 ;; Here we prefer following horizontal splits:
	 (at (or (window-combination-p main-window t)
		 main-window))
	 (near nil)
	 (steps (chris-window-coord-to-steps coord)))
    (while (and (not near) at (car steps))
      (let* ((dir (car steps))
	     (next-window (if (not (window-live-p main-window))
			      ;; if the root window is live, we must split.
			      ;; this prevents us from accidentally identifying a side window.
			      (chris-window-from at dir))))
	(when (and (not next-window) (not (cdr steps)))
	  (setq near (list at dir)))
	(setq steps (cdr steps)
	      at next-window)))
    (cond (near (cons 'near near))
	  (at (list 'found (chris-window-resolve at))))))

(defun chris-jump-to-window (coord)
  "Jump to (creating, if it only requires one split) the desired window at `COORD'."
  (let ((target (chris-window-at coord)))
    (cond ((eq 'found (car target)) (select-window (car (cdr target))))
	  ((eq 'near (car target))
	   (let ((parent (nth 1 target))
		 (dir (nth 2 target)))
	     (select-window (split-window parent nil (eq 'right dir))))))))

(defun chris-window-jumper
    (coord)
  "Create a function that will activate the window at `COORD'."
  (lambda ()
    (interactive)
    (chris-jump-to-window coord)))

(bind-key "s-1" (chris-window-jumper '(0 . 0)))
(bind-key "s-2" (chris-window-jumper '(1 . 0)))
(bind-key "s-3" (chris-window-jumper '(0 . 1)))
(bind-key "s-4" (chris-window-jumper '(1 . 1)))

(provide 'chris-windows)
;;; chris-windows.el ends here
