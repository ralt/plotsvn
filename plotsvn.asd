;;;; plotsvn.asd

(asdf:defsystem #:plotsvn
  :serial t
  :description "Some SVN plots using GNUPlot"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :depends-on ("cgn"
               "s-xml"
               "local-time"
               "alexandria")
  :components ((:file "package")
               (:file "xml-reader")
               (:file "help")
               (:file "commits-by-date")
               (:file "commits-total")
               (:file "plot")
               (:file "gnuplot")
               (:file "plotsvn")))
