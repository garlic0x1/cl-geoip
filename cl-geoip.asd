#|
Copyright (C) 2013 (let ((n "Christoph-Simon Senjak"))
(format nil "~A <~C~C~C~C~A>" n (elt n 1) (elt n 10) (elt n 16)))

This program is free software. It comes without any warranty, to the
extent permitted by applicable law. You can redistribute it and/or
modify it under the terms of the Do What The Fuck You Want To Public
License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.
|#

(asdf:defsystem #:cl-geoip
  :description "Wrapper around libGeoIP"
  :author "(let ((n \"Christoph-Simon Senjak\")) (format nil \"~A ~
  <~C~C~C~C~A>\" n (elt n 0) (elt n 10) (elt n 16) #\\@ \"uxul.de\"))"
  :author "garlic0x1"
  :license "WTFPL 2.0"
  :serial t
  :components ((:file "geoip"))
  :depends-on (:cffi))
