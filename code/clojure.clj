(ns bob.emacs.clj)


def celsius_to_fahrenheit (celsius):

    return (celsius * 1.8) + 32

print(celsius_to_fahrenheit(3))


(defn celsius-to-fahrenheit [celsius]
  "Converts Celsius to Fahrenheit"
  (+ (* celsius 1.8)
     32))

(celsius-to-fahrenheit 30)
