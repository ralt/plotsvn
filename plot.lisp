(in-package #:plotsvn)

(defun commits-by-date (logentries)
  "Plots authors with commits by date."
  (cgn:set-title "Commits by date")

  (let ((authors (make-hash-table :test 'equal)))
    ; Builds the authors
    (build-authors logentries authors)
    
    (let ((dates (sort (get-dates authors) #'sort-dates))
          (lines))
      (dolist (date dates)
        (let ((authors-line))
          (push date authors-line)
          (maphash #'(lambda (author datemap)
                       (declare (ignore author))
                       (push (or (gethash date datemap) 0) authors-line))
                   authors)
          (push authors-line lines)))
      (plot-file lines)
      (plot-lines authors))))

(defun plot-lines (authors)
  (let ((gnuplot-lines)
        (i 2))
    (maphash #'(lambda (author datemap)
                 (declare (ignore datemap))
                 (push (format nil "'~a' using 1:~d title '~a' with linespoints" *plot-file* i author) gnuplot-lines)
                 (incf i))
             authors)
    (cgn:format-gnuplot (format nil "plot ~{~a~^, ~}" (reverse gnuplot-lines)))))

(defun sort-dates (x y)
  (> (get-integer-date x) (get-integer-date y)))

(defun plot-file (lines)
  (when (probe-file *plot-file*)
    (delete-file *plot-file*))
  (with-open-file (s *plot-file* :direction :output)
    (dolist (line lines)
      (format s "~{~a~^~T~}~%" (reverse line)))))

(defun build-authors (logentries authors)
  (dolist (logentry logentries)
    (let ((author (get-author logentry)))
      (unless (gethash author authors)
        (sethash authors author (make-hash-table :test 'equal)))
      (sethash authors author (add-date (get-date logentry) (gethash author authors))))))

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
