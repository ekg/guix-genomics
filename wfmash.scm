(define-module (wfmash)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages maths))

(define-public wfmash
  (let ((version "0.6.0")
        (commit "0cab667ec3d3a9a27f8ab9248e86ca7667a090b5")
        (package-revision "16"))
    (package
     (name "wfmash")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/wfmash.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1wl4d19f52mr5nn7gbrjwrc6xnwncxxix4x02k3pg61r8pk5dqy6"))))
     (build-system cmake-build-system)
     (arguments
      `(#:tests? #f
        ;;#:configure-flags '("-DBUILD_TESTING=false")
        #:make-flags (list (string-append "CC=" ,(cc-for-target))
                           (string-append "CXX=" ,(cxx-for-target)))))
     (inputs
      `(("gcc" ,gcc-11)
        ("gsl" ,gsl)
        ("jemalloc" ,jemalloc)
        ("zlib" ,zlib)))
     (synopsis "base-accurate DNA sequence alignments using WFA and mashmap2")
     (description "wfmash is a fork of MashMap that implements
base-level alignment using the wavefront alignment algorithm WFA. It
completes an alignment module in MashMap and extends it to enable
multithreaded operation. A single command-line interface simplfies
usage. The PAF output format is harmonized and made equivalent to that
in minimap2, and has been validated as input to seqwish.")
     (home-page "https://github.com/ekg/wfmash")
     (license license:expat))))
