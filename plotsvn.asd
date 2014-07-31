;;;; plotsvn.asd

(asdf:defsystem #:plotsvn
  :serial t
  :description "Some SVN plots using GNUPlot"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :depends-on ("cgn"
               "s-xml")
  :components ((:file "package")
               (:file "xml-reader")
               (:file "gnuplot")
               (:file "plot")
               (:file "plotsvn")))
