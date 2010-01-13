(defpackage #:lla-asd
  (:use :cl :asdf))

(in-package #:lla-asd)

(defparameter *fasl-directory*
  (make-pathname :directory '(:relative
			      #+sbcl "fasl-sbcl"
			      #+openmcl "fasl-ccl"
			      #+cmu "fasl-cmucl"
			      #+clisp "fasl-clisp"
			      #-(or sbcl openmcl clisp cmucl) "fasl"
			      )))

(defsystem #:lla
  :description "Lisp Linear Algebra"
  :version "alpha"
  :author "Tamas K Papp <tkpapp@gmail.com>"
  :license "BSD without advertising clause"
  :serial t
  :components 
  ((:module 
    "package-init"
    :pathname #P"src/"
    :components
    ((:file "package")))
   (:module
    "fortran-interface"
    :pathname #P"src/"
    :serial t
    :components
    ((:file "load-libs")
     (:file "fortran-types")
     (:file "blas-cffi")
     (:file "lapack-cffi")))
   (:module 
    "basics"
    :pathname #P"src/"
    :depends-on ("package-init" "fortran-interface")
    :serial t
    :components
    ((:file "utilities")
     (:file "types")
     (:file "fortran-atoms")
     (:file "numeric-vector")
     (:file "numeric-vector-wrappers")
     (:file "matrix-classes")
     (:file "printing")
     (:file "matrix-implementation")
     (:file "readmacros")))
   (:module
    "linear-algebra"
    :pathname #P"src/"
    :depends-on ("basics")
    :serial t
    :components
     ((:file "fortran-call")
      (:file "linear-algebra"))))
  :depends-on
  (:cl-utilities :iterate :metabang-bind :cffi :xarray :lift
                 :anaphora :named-readtables))


;;;; !! ASDF loading for unit tests. 
;;;;
;;;; ?? I think it should go into a separate defsystem so it could be
;;;;    loaded separately -- Tamas
;;;;
;;;; ?? providing something else besides ASDF?  Mudballs? -- Tamas
