;;;; plotsvn.lisp

(in-package #:plotsvn)

;;; "plotsvn" goes here. Hacks and glory await!

;;; Simple example to see how I can go from there.

;; Utility function
(defun file-as-string (file)
  (format nil
          "~{~a~}"
          (with-open-file (s file)
            (loop for line = (read-line s nil 'eof)
                 until (eq line 'eof)
                 collect line))))

;; Function ran from command-line
(defun main (argv)
  (let* ((xml (s-xml:parse-xml-string (file-as-string (second argv))))
         (logentries (cdr xml)))
    (loop for logentry in logentries
       ;; print authors
       do (format t "~A~%" (print-author logentry)))))

(defun print-author (logentry)
  (cadr (nth 1 logentry)))
