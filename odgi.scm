(define-module (odgi)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public odgi
  (let ((version "0.4.1")
        (commit "1a0623886e88066543bb8cf9f9994d102bfe4e02")
        (package-revision "1"))
    (package
     (name "odgi")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/vgteam/odgi.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0dzcjfzk6mv52cqzsj3dkz5wkias8p0r46biyjpqzdqy0hfm8ffh"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))
        #:make-flags (list "CC=gcc")))
     (native-inputs
      `(("cmake" ,cmake)
        ("glibc" ,glibc)
        ("gcc" ,gcc-9)
        ("python" ,python)
        ("pybind11" ,pybind11)
        ("zlib" ,zlib)))
     (synopsis "odgi optimized dynamic sequence graph implementation")
     (description
"odgi provides an efficient, succinct dynamic DNA sequence graph model, as well
as a host of algorithms that allow the use of such graphs in bioinformatic
analyses.")
     (home-page "https://github.com/vgteam/odgi")
     (license license:expat))))

