(define-module (seqwish)
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

(define-public seqwish
  (let ((version "0.5.0")
        (commit "c0880e9e813f55fc801789dc8829434956f6b72d")
        (package-revision "1"))
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
                "186yqh5fwxksncfypmphqx0bamdfk06grv9hb9srp81nq0r94c5n"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (native-inputs
      `(("gcc" ,gcc-9)
        ("cmake" ,cmake)
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
