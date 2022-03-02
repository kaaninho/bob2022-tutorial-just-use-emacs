(ns bob.emacs.clj)

(defn celsius-to-fahrenheit [celsius]
  "Converts Celsius to Fahrenheit"
  (+ (* celsius 1.8)
     32))

(celsius-to-fahrenheit 30)
