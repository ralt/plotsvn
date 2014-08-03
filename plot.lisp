(in-package #:plotsvn)

(defun plot-file (lines)
  (when (probe-file *plot-file*)
    (delete-file *plot-file*))
  (with-open-file (s *plot-file* :direction :output)
    (dolist (line lines)
      (format s "~{~a~^~T~}~%" (reverse line)))))

;; This function handles weird XML lines, to use for every plot.
(defun build-authors (logentries authors)
  (dolist (logentry logentries)
    (let ((author (get-author logentry)))
      (unless (gethash author authors)
        (sethash authors author (make-hash-table :test 'equal)))
      (handler-case
          (sethash authors author (add-date (get-date logentry) (gethash author authors)))
        (local-time::invalid-timestring () (remhash author authors))))))

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

(defun add-date (date datemap)
  (if (gethash date datemap)
      (incf (gethash date datemap))
      (sethash datemap date 1))
  datemap)

(defun sethash (hash-map key value)
  (setf (gethash key hash-map) value))
