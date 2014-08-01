(in-package #:plotsvn)

(defun plot (fn logentries)
  "Uses GNUPlot to plot the points."
  (cgn:start-gnuplot)
  (apply fn (list logentries))
  (cgn:postscript-copy "your-plot.ps")
  (cgn:close-gnuplot))
