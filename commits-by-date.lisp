(in-package #:plotsvn)

(defun commits-by-date (logentries args)
  "Plots authors with commits by date."
  (cgn:set-title "Commits by date")
  (cbd/set-gnuplot-options)

  (let ((authors (make-hash-table :test 'equal)))
    ; Builds the authors
    (build-authors logentries authors)

    (let ((dates (sort (cbd/get-dates authors) #'cbd/sort-dates))
          (lines))
      (dolist (date dates)
        (let ((authors-line))
          (push date authors-line)
          (maphash #'(lambda (author datemap)
                       (declare (ignore author))
                       (push (or (gethash date datemap) 0) authors-line))
                   authors)
          (push authors-line lines)))
      ; We put everything in the file, even if a single author is plotted.
      (plot-file lines)
      (cbd/plot-lines authors args))))

(defun cbd/set-gnuplot-options ()
  (cgn:format-gnuplot "set xdata time")
  (cgn:format-gnuplot "set timefmt '%Y-%m-%d'")
  (cgn:format-gnuplot "set xtics format '%d/%m/%y' rotate by -45"))

(defun cbd/plot-lines (authors args)
  (let ((gnuplot-lines)
        (i 2)
        (single-author))

    ; Set the single author
    (when (>= (length (first args)) 4)
      (setf single-author (third (first args))))
    (maphash #'(lambda (author datemap)
                 (declare (ignore datemap))
                 (if single-author
                     ; Only plot if it's current author
                     (when (string= author single-author)
                       (push (cbd/add-plot-line i author) gnuplot-lines))
                     (push (cbd/add-plot-line i author) gnuplot-lines))
                 (incf i))
             authors)
    (cgn:format-gnuplot (format nil "plot ~{~a~^, ~}" (reverse gnuplot-lines)))))

(defun cbd/add-plot-line (i author)
  (format nil "'~a' using 1:~d title '~a' with linespoints" *plot-file* i author))

(defun cbd/sort-dates (x y)
  (> (cbd/get-integer-date x) (cbd/get-integer-date y)))

(defun cbd/get-dates (authors)
  (remove-duplicates (alexandria:flatten
                      (loop for value being the hash-values of authors
                         collect (loop for key being the hash-keys of value
                                    collect key)))
                     :test 'equal))

(defun cbd/get-integer-date (date)
  (parse-integer (remove #\- date)))
