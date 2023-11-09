(define-module (wfmash)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages base)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages bioinformatics)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages maths))

(define-public wfmash
  (let ((version "0.12.1")
        (commit "8a59d78a3bd243e63a9162369d1440db4d0799bf")
        (package-revision "1"))
    (package
     (name "wfmash")
     (version (string-append version "-" package-revision "+" (string-take commit 7)))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/waveygang/wfmash.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1zxj6kialf14y8d07s3lps8c1fc0pv6ks1hyx60mdp6lxlikk5gi"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; This stashes our build version in the executable
         (add-after 'unpack 'set-version
           (lambda _
             (mkdir "include")
             (with-output-to-file "include/wfmash_git_version.hpp"
               (lambda ()
                 (format #t "#define WFMASH_GIT_VERSION \"~a\"~%" version)))
             #t))
         (delete 'check))
        #:make-flags (list (string-append "CC=" ,(cc-for-target))
                           (string-append "CXX=" ,(cxx-for-target)))))
     (inputs
      `(("gcc" ,gcc-12)
        ("gsl" ,gsl)
        ("gmp" ,gmp)
        ("make" ,gnu-make)
        ("pkg-config" ,pkg-config)
        ("jemalloc" ,jemalloc)
        ("htslib" ,htslib)
        ("git" ,git)
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
