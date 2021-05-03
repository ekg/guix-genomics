(define-module (wfmash)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression))

(define-public wfmash
  (let ((version "0.4.0")
        (commit "c4f2095cb6b350d67a0f99ebeb2097412468c2af")
        (package-revision "28"))
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
                "1vb19x045mlzpndis20zfklb843296s0vaafnldr1znqq5ch9sk0"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))
        ;;#:configure-flags '("-DBUILD_TESTING=false")
        #:make-flags (list "CC=gcc CXX=g++")))
     (native-inputs
      `(("cmake" ,cmake)
        ("gsl" ,gsl)
        ("gcc" ,gcc-10)
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
