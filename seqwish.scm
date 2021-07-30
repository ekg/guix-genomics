(define-module (seqwish)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages compression))

(define-public seqwish
  (let ((version "0.7.1")
        (commit "6da2102b2fdcfe95d92e9648fd0ee3cc46f8f8ce")
        (package-revision "3"))
    (package
     (name "seqwish")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/seqwish.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "010a6y7qnzn1nqwnl4jwc6r6gj7gr41c6n5hg9wdliahpmi9wms5"))))
     (build-system cmake-build-system)
     (arguments
      `(#:tests? #f))
     (inputs
      `(("jemalloc" ,jemalloc)
        ("gcc" ,gcc-11)
        ("zlib" ,zlib)))
     (synopsis "variation graph inducer")
     (description
"seqwish implements a lossless conversion from pairwise alignments between
sequences to a variation graph encoding the sequences and their alignments.  As
input we typically take all-versus-all alignments, but the exact structure of
the alignment set may be defined in an application specific way.  This algorithm
uses a series of disk-backed sorts and passes over the alignment and sequence
inputs to allow the graph to be constructed from very large inputs that are
commonly encountered when working with large numbers of noisy input sequences.")
     (home-page "https://github.com/ekg/freebayes")
     (license license:expat))))
