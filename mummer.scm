(define-module (mummer)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages awk)
  #:use-module (gnu packages compression))

(define-public mummer
  (let ((version "4.0.0rc1")
        (commit "6c0da4101a55a0f89ecd00a5e569501a9a9f9ecd")
        (package-revision "1"))
    (package
     (name "mummer")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/atks/vt.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1bfaaywi487l28vvsz4g501qngqpif6wncrhf3ydbjk91jf4jq99"))))
     (build-system gnu-build-system)
     (arguments
      `(#:make-flags 
	    '("CC=gcc" "CXX=g++")
	    #:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (native-inputs
      `(("curl" ,curl)
        ("gcc" ,gcc-11)
        ("sed" ,sed)
        ("awk" ,awk)
        ("zlib" ,zlib)))
     (synopsis "MUMmer")
     (description "MUMmer is a system for rapidly aligning DNA and protein sequences.")
     (home-page "https://mummer4.github.io/")
     (license license:expat))))
