(in-package #:plotsvn)

(defun commits-by-date (logentries default-author)
  "Plots authors with commits by date."
  (cgn:set-title "Commits by date")

  (let ((authors (make-hash-table :test 'equal)))
    ; Builds the authors
    (dolist (logentry logentries)
      (let ((author (get-author logentry)))
        (unless (gethash author authors)
          (setf (gethash author authors) (make-hash-table :test 'equal)))
        (sethash authors author (add-date (get-date logentry) (gethash author authors)))))
    (let* ((dates (get-dates authors)))
      (cgn:format-gnuplot "set xdata time")
      (cgn:format-gnuplot "set timefmt '%Y%m%d'")
      (cgn:format-gnuplot "set xrange [\"20080101\":\"20093112\"]")
      (cgn:format-gnuplot "set grid")
      (cgn:format-gnuplot "set autoscale y")
      (cgn:format-gnuplot "set autoscale x")
      (cgn:format-gnuplot "set xtics format '%b %d'")
      (maphash #'(lambda (author datemap)
                   (when (string= author default-author)
                     (progn
                       (format t "~{~a~^, ~}~%" (loop for date in dates
                                                      collect (or (gethash date datemap) 0)))
                       (format t "~{~a~^, ~}~%" dates)
                       (cgn:plot-points (get-integer-dates dates)
                                        (loop for date in (reverse dates)
                                              collect (or (gethash date datemap) 0))))))
               authors)
      (cgn:format-gnuplot "plot '.cgn.dat' using 1:2 with linesp"))))

(defun find-max-commits (authors)
  (let ((max 0))
    (maphash #'(lambda (author datemap)
                 (declare (ignore author))
                 (maphash #'(lambda (date count)
                              (declare (ignore date))
                              (when (> count max)
                                (setf max count)))
                          datemap))
             authors)
    (1+ max)))

(defun get-dates (authors)
  (remove-duplicates (alexandria:flatten
                      (loop for value being the hash-values of authors
                         collect (loop for key being the hash-keys of value
                                    collect key)))
                     :test 'equal))

(defun get-integer-dates (dates)
  (loop for date in dates
        collect (get-integer-date date)))

(defun get-integer-date (date)
  (parse-integer (remove #\- date)))

(defun add-date (date datemap)
  (if (gethash date datemap)
      (incf (gethash date datemap))
      (sethash datemap date 1))
  datemap)

(defun sethash (hash-map key value)
  (setf (gethash key hash-map) value))
