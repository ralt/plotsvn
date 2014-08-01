(in-package #:plotsvn)

;; Gets the author from a logentry
(defun get-author (logentry)
  (cadr (nth 1 logentry)))

;; Gets the date from a logentry
(defun get-date (logentry)
  (let ((d (local-time:parse-timestring (cadr (nth 2 logentry)))))
    (format nil
            "~4d-~2,'0d-~2,'0d"
            (local-time:timestamp-year d)
            (local-time:timestamp-month d)
            (local-time:timestamp-day d))))
