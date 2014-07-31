;;;; plotsvn.lisp

(in-package #:plotsvn)

;;; "plotsvn" goes here. Hacks and glory await!

;; Function ran from command-line
(defun main (argv)
  (let ((filename (second argv)))
    (unless filename
      (format t "XML file required.~%")
      (quit))
    (let* ((xml (read-xml filename))
           (logentries (cdr xml))
           (plot-type (third argv)))
      (plot (cond
              ((string= "commits-by-date" plot-type) (commits-by-date logentries))
              (t (format t "No plot specified.~%")))))))

;; Reads the XML file and returns it as a string.
(defun read-xml (filename)
  (handler-case (s-xml:parse-xml-string (file-as-string filename))
    (s-xml:xml-parser-error () (progn
                                 (format t "Malformed XML.~%")
                                 (quit)))))
  
;; Utility functions
(defun file-as-string (file)
  (format nil
          "~{~a~}"
          (with-open-file (s file)
            (loop for line = (read-line s nil 'eof)
                 until (eq line 'eof)
                 collect line))))

(defun quit ()
  (sb-thread:abort-thread :allow-exit t))
