(in-package #:plotsvn)

(defun commits-by-date (logentries)
  "Plots authors with commits by date."
  (declare (ignore logentries))
  (cgn:set-title "Commits by date")
  (cgn:set-range 'cgn:x 0 5)
  (cgn:set-range 'cgn:y 0 10)
  (cgn:plot-points '(1 2) '(3 4)))
