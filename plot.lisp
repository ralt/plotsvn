(in-package #:plotsvn)

(defun commits-by-date (logentries default-author)
  "Plots authors with commits by date."
  (cgn:set-title "Commits by date")

  (let ((authors (make-hash-table :test 'equal)))
    ; Builds the authors
    (build-authors logentries authors)
    ; Sets the plot options
    (plot-options)
    (let* ((dates (get-dates authors)))
      (maphash #'(lambda (author datemap)
                   (when (string= author default-author)
                     (plot-file (sort (loop for date in (reverse dates)
                                    collect (list date (or (gethash date datemap) 0)))
                                      #'(lambda (x y)
                                          (< (get-integer-date (car x)) (get-integer-date (car y))))))))
               authors)
      (cgn:format-gnuplot (format nil "plot '~a' using 1:2 title '~a' with linesp" plot-file default-author)))))

(defun plot-file (points)
  (when (probe-file plot-file)
    (delete-file plot-file))
  (with-open-file (s plot-file :direction :output)
    (dolist (point points)
      (format s "~{~a~^~T~}~%" point))))

(defun build-authors (logentries authors)
  (dolist (logentry logentries)
    (let ((author (get-author logentry)))
      (unless (gethash author authors)
        (sethash authors author (make-hash-table :test 'equal)))
      (sethash authors author (add-date (get-date logentry) (gethash author authors))))))

(defun plot-options ()
  (cgn:format-gnuplot "set xdata time")
  (cgn:format-gnuplot "set timefmt '%Y-%m-%d'")
  (cgn:format-gnuplot "set grid")
  (cgn:format-gnuplot "set autoscale y")
  (cgn:format-gnuplot "set autoscale x")
  (cgn:format-gnuplot "set xtics format '%b %d'"))

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
