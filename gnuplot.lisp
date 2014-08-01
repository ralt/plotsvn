(in-package #:plotsvn)

(defun plot (fn logentries)
  "Uses GNUPlot to plot the points."
  (cgn:start-gnuplot)
  ; Don't show the filename
  (cgn:format-gnuplot "set nokey")
  ; Call the plotting function with a single argument
  (apply fn (list logentries))
  ; Save the file to an image
  (cgn:format-gnuplot "set term png")
  (cgn:format-gnuplot "set output 'output.png'")
  (cgn:format-gnuplot "replot")
  (cgn:close-gnuplot))
