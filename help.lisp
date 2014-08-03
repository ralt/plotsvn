(in-package #:plotsvn)

(defun help (argv)
  (let ((graph-type (third argv)))
    (if graph-type
        (cond
          ((string= "commits-by-date" graph-type) (help/commits-by-date))
          ((string= "commits-total" graph-type) (help/commits-total))
          (t (format t "Invalid arguments.~%")))
        (help/help))))

(defun help/help ()
  (format t "Usage: plotsvn <XML-LOG-FILE> <GRAPH-TYPE> [OPTION]~%")
  (format t "~%")
  (format t "List of graph types:~%~%")
  (format t "~T- commits-by-date: shows the number of commits per day per author~%")
  (format t "~T- commits-total: shows the total number of commits per author~%~%")
  (format t "Type `$ plotsvn help <graph-type>` for more information.~%"))

(defun help/commits-by-date ()
  (format t "Usage: plotsvn <XML-LOG-FILE> commits-by-date [AUTHOR]~%~%")
  (format t "Plots the number of commits per day, per author.~%~%")
  (format t "Option:~%~%")
  (format t "~T- AUTHOR: if specified, it filters the graph to this single author.~%"))

(defun help/commits-total ()
  (format t "Usage: plotsvn <XML-LOG-FILE> commits-total~%~%")
  (format t "Plots a histogram representing the total number of commits, for each author.~%"))
