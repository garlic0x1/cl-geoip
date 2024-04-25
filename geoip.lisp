;; #|
;; Copyright (C) 2013 (let ((n "Christoph-Simon Senjak")) #| |# (format
;;  nil "~A <~C~C~C~C~A>" n (elt n 0) (elt n 10) (elt n 16) #\@
;;  "uxul.de"))
;; forked by garlic0x1 2024
;;
;; This program is free software. It comes without any warranty, to the
;; extent permitted by applicable law. You can redistribute it and/or
;; modify it under the terms of the Do What The Fuck You Want To Public
;; License, Version 2, as published by Sam Hocevar. See
;; http://www.wtfpl.net/ for more details.
;; |#
(defpackage :geoip
  (:use :common-lisp :cffi)
  (:export :open-databases
           :open-default-databases
           :get-country-code
           :get-continent-code))

(in-package :geoip)

(define-foreign-library libgeoip
  (t (:default "libGeoIP")))

(use-foreign-library libgeoip)

(defcfun ("GeoIP_open" geoip-open) :pointer
  (filename :string) (flags :int))

(defcfun ("GeoIP_country_code_by_addr" geoip-country-code-by-addr)
    :string (database :pointer) (ip-4 :string))

(defcfun ("GeoIP_country_code_by_addr_v6" geoip-country-code-by-addr-v6)
    :string (database :pointer) (ip-6 :string))

(defcfun ("GeoIP_id_by_addr" geoip-id-by-addr) :int
  (database :pointer)
  (ip-4 :string))

(defcfun ("GeoIP_id_by_addr_v6" geoip-id-by-addr-v6) :int
  (database :pointer)
  (ip-4 :string))

(defcfun ("GeoIP_continent_by_id" geoip-continent-by-id) :string
  (id :int))

(defvar *ip4-db*)
(defvar *ip6-db*)

(defun open-databases (ip4 ip6)
  (setf *ip4-db* (geoip-open ip4 #x2))
  (assert (not (null-pointer-p *ip4-db*)))
  (setf *ip6-db* (geoip-open ip6 #x2))
  (assert (not (null-pointer-p *ip6-db*))))

(defun open-default-databases ()
  (geoip:open-databases "/usr/share/GeoIP/GeoIP.dat" "/usr/share/GeoIP/GeoIPv6.dat"))

(defun get-country-code (ip)
  (or
   (geoip-country-code-by-addr *ip4-db* ip)
   (geoip-country-code-by-addr-v6 *ip6-db* ip)))

(defun get-continent-code (ip)
  (geoip-continent-by-id
   (let ((ipv4-id (geoip-id-by-addr *ip4-db* ip)))
     (if (= 0 ipv4-id)
         (geoip-id-by-addr-v6 *ip6-db* ip)
         ipv4-id))))
