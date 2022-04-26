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
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages bioinformatics)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gdb)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages python)
  #:use-module (gnu packages parallel)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl6)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages compression))

(define-public vcflib
  (let ((version "1.0.3")
        (commit "0afe84191a280b910c4c22366cc97f4be1fd51d3")
        (package-revision "3"))
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
                "05ifijm3x8yqs5yrj0wx7524zcznbskxf55is6xssmiinsc9yk6l"))))
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
     (inputs
      `(("curl" ,curl)
        ("fastahack" ,fastahack)
        ("gcc" ,gcc-11)
        ("gdb" ,gdb)
        ("htslib" ,htslib)
        ("pandoc" ,pandoc)
        ("perl" ,perl)
        ("python" ,python)
        ("ruby" ,ruby)
        ("tabixpp" ,tabixpp)
        ("xz" ,xz)
        ("zlib" ,zlib)))
     (native-inputs
      `(("pkg-config" ,pkg-config)))
     (synopsis "vcflib variant call file (VCF) manipulation and analysis")
     (description
      "vcflib provides methods to manipulate and interpret sequence variation as it
can be described by VCF.  It is both: an API for parsing and operating on
records of genomic variation as it can be described by the VCF format, and a
collection of command-line utilities for executing complex manipulations on VCF
files.")
     (home-page "https://github.com/vcflib/vcflib")
     (license license:expat))))
