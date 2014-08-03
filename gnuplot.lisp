(in-package #:plotsvn)

(defun plot (fn logentries argv)
  "Uses GNUPlot to plot the points."
  (cgn:start-gnuplot)
  (cgn:format-gnuplot "set term png size 1280,800 enhanced")
  (cgn:format-gnuplot "set output 'output.png'")
  (cgn:format-gnuplot "set grid")
  (cgn:format-gnuplot "set autoscale y")
  (cgn:format-gnuplot "set autoscale x")
  ; Call the plotting function with a single argument
  (apply fn (list logentries argv))
  (cgn:close-gnuplot))
