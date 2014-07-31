(in-package #:plotsvn)

(defun plot (points)
  "Uses GNUPlot to plot the points."
  (cgn:start-gnuplot)
  (cgn:plot-points (car points) (cadr points))
  (cgn:postscript-copy "your-plot.ps")
  (cgn:print-graphic)
  (cgn:close-gnuplot))
