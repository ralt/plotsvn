;;;; plotsvn.lisp

(in-package #:plotsvn)

;;; "plotsvn" goes here. Hacks and glory await!

;; A simple macro to quickly exit the app.
;; A macro instead of a function to let functions
;; handle format's arguments as they wish.
(defmacro quit (code &body body)
  `(progn
     (format t ,@body)
     (sb-ext:exit :code ,code)))

(defconstant xml-file-required 1)
(defconstant no-plot-specified 2)
(defconstant malformed-xml 3)
(defconstant plotting-file ".cgn.dat")

;; Function ran from command-line
(defun main (argv)
  (let ((filename (second argv))
        (plot-type (third argv)))
    (unless filename
      (quit xml-file-required "XML file required.~%"))
    (run-plotting filename plot-type argv)
    (sb-ext:exit :code 0)))

(defun run-plotting (filename plot-type argv)
  (let* ((xml (read-xml filename))
         (logentries (cdr xml)))
    (plot (cond
            ((string= "commits-by-date" plot-type) #'commits-by-date)
            (t (quit no-plot-specified "No plotting specified.~%")))
          logentries
          argv))
  nil)


;; Reads the XML file and returns it as a string.
(defun read-xml (filename)
  (handler-case (s-xml:parse-xml-string (file-as-string filename))
    (s-xml:xml-parser-error () (quit malformed-xml "Malformed XML.~%"))))

;; Utility functions
(defun file-as-string (file)
  (format nil
          "~{~a~}"
          (with-open-file (s file)
            (loop for line = (read-line s nil 'eof)
                 until (eq line 'eof)
                 collect line))))
