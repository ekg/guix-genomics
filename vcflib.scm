(define-module (vcflib)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages python)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public vcflib
  (let ((version "v1.0.1")
        (commit "40dbb399b5d25ae694e15755724475b274d1b8fe")
        (package-revision "1"))
    (package
     (name "vcflib")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/vcflib/vcflib.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "04zz3a3glk270prqld7xg4r9mfmanmw2y2vf46j44kxvdxz811rn"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; Setting the SHELL environment variable is required by SeqLib's configure script
         (add-after 'unpack 'set-shell
                    (lambda _
                      (setenv "CONFIG_SHELL" (which "sh"))
                      #t))
         (delete 'check))
        #:make-flags (list "CC=gcc")))
     (native-inputs
      `(("wget" ,wget)
        ("cmake" ,cmake)
        ("gcc" ,gcc-9)
        ("zlib" ,zlib)))
     (synopsis "vcflib variant call file (VCF) manipulation and analysis")
     (description
"vcflib provides methods to manipulate and interpret sequence variation as it
can be described by VCF.  It is both: an API for parsing and operating on
records of genomic variation as it can be described by the VCF format, and a
collection of command-line utilities for executing complex manipulations on VCF
files.")
     (home-page "https://github.com/vcflib/vcflib")
     (license license:expat))))
