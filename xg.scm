(define-module (xg)
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

(define-public xg
  (let ((version "0.1.0")
        (commit "1828931b8e9f2f6eecdd3ab9920c5b01f026ba2e")
        (package-revision "1"))
    (package
     (name "xg")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/vgteam/xg.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0gg099bafnjw6bdv83lh00hvls8xb6xivcwm2ax71vxvn6k1gqdv"))))
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
        ("zlib" ,zlib)))
     (synopsis "succinct static genome variation graph index")
     (description
"The XG index is a succinct, static index for genome variation graphs.
This utility reads GFA and writes XG format version of the graph. It
may also be used to annotate the nodes of graphs in GFA with path
positions.")
     (home-page "https://github.com/vgteam/xg")
     (license license:expat))))

