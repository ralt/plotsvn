;;;; plotsvn.lisp

(in-package #:plotsvn)

;;; "plotsvn" goes here. Hacks and glory await!

;; A simple macro to quickly exit the app.
;; A macro instead of a function to let functions
;; handle format's arguments as they wish.
(defmacro quit (&body body)
  `(progn
     (format t ,@body)
     (sb-thread:abort-thread :allow-exit t)))

;; Function ran from command-line
(defun main (argv)
  (let ((filename (second argv)))
    (unless filename
      (quit "XML file required.~%"))
    (let* ((xml (read-xml filename))
           (logentries (cdr xml))
           (plot-type (third argv)))
      (plot (cond
              ((string= "commits-by-date" plot-type) (commits-by-date logentries))
              (t (quit "No plot specified.~%")))))))

;; Reads the XML file and returns it as a string.
(defun read-xml (filename)
  (handler-case (s-xml:parse-xml-string (file-as-string filename))
    (s-xml:xml-parser-error () (quit "Malformed XML.~%"))))

;; Utility functions
(defun file-as-string (file)
  (format nil
          "~{~a~}"
          (with-open-file (s file)
            (loop for line = (read-line s nil 'eof)
                 until (eq line 'eof)
                 collect line))))
