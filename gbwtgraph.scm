(define-module (gbwtgraph)
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

(define-public gbwtgraph
  (let ((version "0.0.0")
        (commit "0d79d48dd6f2b21e065c6925d7d6b7a41d17d4a8")
        (package-revision "1"))
    (package
     (name "gbwtgraph")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/gbwtgraph.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "02db3lpri5pdciqhqza07ymlj6qh5dqhxapjh4r36zy62cva118j"))))
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
     (synopsis "GBWT-based handle graph for succinct genome graph storage and query")
     (description
"The GBWTGraph represents the graph induced by the haplotypes stored
in a GBWT index. It uses the GBWT index for graph topology and stores
the node sequences in plain form for fast extraction.")
     (home-page "https://github.com/vgteam/gbwtgraph")
     (license license:expat))))

