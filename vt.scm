(define-module (vt)
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
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public vt
  (let ((version "v0.57721")
        (commit "88da43649b5a39ddfc00d8a8f4d494fad50d5eec")
        (package-revision "1"))
    (package
     (name "vt")
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
	 (delete 'configure)
	 (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                           (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                             (install-file "vt" bin))))
         (delete 'check))))
     (native-inputs
      `(("curl" ,curl)
        ("gcc" ,gcc-9)
	("crypto++" ,crypto++)
	("openssl" ,openssl)
        ("zlib" ,zlib)))
     (synopsis "A tool set for short variant discovery in genetic sequence data.")
     (description "A tool set for short variant discovery in genetic sequence data.")
     (home-page "http://genome.sph.umich.edu/wiki/vt" )
     (license license:expat))))
