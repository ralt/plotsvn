(in-package #:plotsvn)

;; Gets the author from a logentry
(defun author (logentry)
  (cadr (nth 1 logentry)))
